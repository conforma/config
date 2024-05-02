# Enterprise Contract Configuration Files

This repo contains a set of `policy.yaml` files which can be used by the [Enterprise Contract
Command Line Interface](https://github.com/enterprise-contract/ec-cli) with a variety of
environments.

## Konflux CI

When using Red Hat's [Konflux CI](https://github.com/konflux-ci/), (formerly
[Red Hat App Studio](https://github.com/redhat-appstudio/)),
environment, there is a predefined Integration Test pipeline definition for each of the configs in
this section. They can be used when creating an Integration Test in Konflux as per the [documentation
here](https://redhat-appstudio.github.io/docs.appstudio.io/Documentation/main/how-to-guides/proc_managing-compliance-with-the-enterprise-contract/).

The policy configuration files are:

### Default

Includes rules for levels 1, 2 & 3 of SLSA v0.1. This is the default config used for new Konflux applications.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//default`
* Source: [default/policy.yaml](https://github.com/enterprise-contract/config/blob/main/default/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)
* Konflux Integration Test pipeline definition:
  * Github URL: `https://github.com/redhat-appstudio/build-definitions`
  * Path in repository: [`pipelines/enterprise-contract.yaml`](https://github.com/redhat-appstudio/build-definitions/blob/main/pipelines/enterprise-contract.yaml)

### Everything (experimental)

Include every rule in the default policy source. For experiments only. This is not expected to pass for Konflux builds without excluding some rules.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//everything`
* Source: [everything/policy.yaml](https://github.com/enterprise-contract/config/blob/main/everything/policy.yaml)
* Collections:
* Konflux Integration Test pipeline definition:
  * Github URL: `https://github.com/redhat-appstudio/build-definitions`
  * Path in repository: [`pipelines/enterprise-contract-everything.yaml`](https://github.com/redhat-appstudio/build-definitions/blob/main/pipelines/enterprise-contract-everything.yaml)

### Red Hat

Includes the full set of rules and policies required internally by Red Hat when building Red Hat products.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//redhat`
* Source: [redhat/policy.yaml](https://github.com/enterprise-contract/config/blob/main/redhat/policy.yaml)
* Collections: [@redhat](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#redhat)
* Konflux Integration Test pipeline definition:
  * Github URL: `https://github.com/redhat-appstudio/build-definitions`
  * Path in repository: [`pipelines/enterprise-contract-redhat.yaml`](https://github.com/redhat-appstudio/build-definitions/blob/main/pipelines/enterprise-contract-redhat.yaml)

### Red Hat (non hermetic)

Includes most of the rules and policies required internally by Red Hat when building Red Hat products. It excludes the requirement of hermetic builds.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//redhat-no-hermetic`
* Source: [redhat-no-hermetic/policy.yaml](https://github.com/enterprise-contract/config/blob/main/redhat-no-hermetic/policy.yaml)
* Collections: [@redhat](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#redhat)
* Konflux Integration Test pipeline definition:
  * Github URL: `https://github.com/redhat-appstudio/build-definitions`
  * Path in repository: [`pipelines/enterprise-contract-redhat-no-hermetic.yaml`](https://github.com/redhat-appstudio/build-definitions/blob/main/pipelines/enterprise-contract-redhat-no-hermetic.yaml)

### SLSA3

Rules specifically related to levels 1, 2 & 3 of SLSA v0.1, plus a set of basic checks that are expected to pass for all Konflux builds.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//slsa3`
* Source: [slsa3/policy.yaml](https://github.com/enterprise-contract/config/blob/main/slsa3/policy.yaml)
* Collections: [@minimal](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#minimal), [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)
* Konflux Integration Test pipeline definition:
  * Github URL: `https://github.com/redhat-appstudio/build-definitions`
  * Path in repository: [`pipelines/enterprise-contract-slsa3.yaml`](https://github.com/redhat-appstudio/build-definitions/blob/main/pipelines/enterprise-contract-slsa3.yaml)


## Red Hat Trusted Application Pipeline (RHTAP)

This configuration is designed to be used with RHTAP. The sample RHTAP
pipelines include [a GitOps PR pipeline with an EC
check](https://github.com/redhat-appstudio/tssc-sample-pipelines/blob/main/pac/pipelines/gitops-pull-request-rhtap.yaml).
The pipeline uses the [`verify-enterprise-contract` task](https://github.com/redhat-appstudio/tssc-sample-pipelines/blob/main/pac/tasks/verify-enterprise-contract.yaml),
with this EC configuration.

It's similar to the Konflux CI default configuration but for compatibility and
stability reasons it doesn't use policies directly from `main` branch.

The policy configuration files are:

### TSSC Default Stable

Includes rules for levels 1, 2 & 3 of SLSA v0.1. This is the default config used by the RHTAP's TSSC templates.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//tssc-default`
* Source: [tssc-default/policy.yaml](https://github.com/enterprise-contract/config/blob/main/tssc-default/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)


## Konflux CI & Red Hat Trusted Application Pipeline (RHTAP) - Tasks

These are policy rules used to verify Tekton Task definitions meet the Red Hat guidelines for being
considered trusted.

The policy configuration files are:

### Red Hat Trusted Tasks

Rules used to verify Tekton Task definitions comply to Red Hat's standards.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//redhat-trusted-tasks`
* Source: [redhat-trusted-tasks/policy.yaml](https://github.com/enterprise-contract/config/blob/main/redhat-trusted-tasks/policy.yaml)


## GitHub

Container images built via [GitHub Actions](https://docs.github.com/actions) can be verified with
the following policy configurations.

### GitHub Default

Rules for container images built via GitHub Workflows.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//github-default`
* Source: [github-default/policy.yaml](https://github.com/enterprise-contract/config/blob/main/github-default/policy.yaml)
* Collections: [@github](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#github)

## See also

* [Policy Rule Documentation](https://enterprisecontract.dev/docs/ec-policies/release_policy.html)
* [Getting Started with Enterprise Contract &amp; Konflux CI](https://enterprisecontract.dev/docs/user-guide/main/getting-started.html)
