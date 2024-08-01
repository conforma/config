#!/usr/bin/env bash
# Copyright The Enterprise Contract Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

# Updates a local clone of redhat-appstudio/infra-deployments to use the Konflux
# configs defined in this repo.
# Usage:
#   update-infra-deployments.sh <PATH_TO_INFRA_DEPLOYMENTS>

set -o errexit
set -o pipefail
set -o nounset

# Ensure the expected output file exists.
OUTPUT="${1}/components/enterprise-contract/ecp.yaml"
if [[ ! -f "${OUTPUT}" ]]; then
    echo "Expected output file not found, ${OUTPUT}"
    exit 1
fi

# NOTE: Data sources are used via transient references. Some data sources, e.g. acceptable data
# bundles, are updated very frequently (multiple times a day in some cases). Propagating those
# changes to other repositories via git worfklows is cumbersome. Also, the risk of introducing a
# breaking change to a data source is lower than changes to the policy rules themselves.

# Make it easier to load the policy configs.
cd "$(git rev-parse --show-toplevel)"

# Something else is reponsible for maintaining the policy URL refs. Here we save their current value
# so we can ensure they stay the same. As a sanity check, we ensure that a single policy URL is used
# across all policies for the sake of simplicity given that is the current state.
function get_policy_url() {
    local marker
    local url

    marker="$1"

    url="$(
        < "${OUTPUT}" \
        marker="${marker}" \
        yq '.spec.sources[].policy[] | select(contains(strenv(marker)))' -o json -r | sort -u
    )"

    if [[ "$(echo $url | wc -w)" -gt "1" ]]; then
        echo -e "Unexpected amount of policy URLs: \n${url}"
        exit 1
    fi

    printf "${url}"
}

function get_policy_configs() {
    local configs
    local environment

    environment="$1"

    configs="$(
        < src/data.yaml \
        environment="${environment}" \
        yq 'to_entries | .[] | select(.value.environment == env(environment)) | select(.value.deprecated != true) | "\(.key)/policy.yaml"' \
    | sort)"

    printf "${configs}"
}

release_policy_url="$(get_policy_url "ec-release-policy")"
echo "Release policy URL: ${release_policy_url}"

task_policy_url="$(get_policy_url "ec-task-policy")"
echo "Task policy URL: ${task_policy_url}"

# Always generate the output file from scratch and add some helper text on the generated file.
echo '#
# The contents of this file are automatically generated based on the Konflux configs defined in the
# github.com/enterprise-contract/config repo. Any manual modifications will be overridden.
#
' > "${OUTPUT}"

if [[ ! -z $release_policy_url ]]; then
    # Figure out which release policy config files to use.
    policy_configs="$(get_policy_configs "konflux")"

    for policy_config in $policy_configs; do
        name="$(dirname $policy_config)"
        # For legacy reasons, the everything config is called "all" in Konflux
        if [[ "${name}" == 'everything' ]]; then
            name='all'
        fi

        echo "---" >> "${OUTPUT}"
        name="${name}" policy="${release_policy_url}" \
        yq -P -o yaml '{
            "apiVersion": "appstudio.redhat.com/v1alpha1",
            "kind": "EnterpriseContractPolicy",
            "metadata": {
                "name": strenv(name),
                "namespace": "enterprise-contract-service"
            },
            "spec": . }
            | .spec.sources[].policy = [strenv(policy)]
            | .spec.publicKey = "k8s://openshift-pipelines/public-key"
            | sort_keys(..) ' \
            "${policy_config}"  >> "${OUTPUT}"
    done
fi

if [[ ! -z $task_policy_url ]]; then
    # Figure out which task policy config files to use.
    task_policy_configs="$(get_policy_configs "konflux-tasks")"

    for policy_config in $task_policy_configs; do
        name="$(dirname $policy_config)"

        echo "---" >> "${OUTPUT}"
        name="${name}" policy="${task_policy_url}" \
        yq -P -o yaml '{
            "apiVersion": "appstudio.redhat.com/v1alpha1",
            "kind": "EnterpriseContractPolicy",
            "metadata": {
                "name": strenv(name),
                "namespace": "enterprise-contract-service"
            },
            "spec": . }
            | .spec.sources[].policy = [strenv(policy)]
            | sort_keys(..) ' \
            "${policy_config}"  >> "${OUTPUT}"
    done
fi

echo 'infra-deployments updated successfully'
