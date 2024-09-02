# Enterprise Contract Configuration Files

This repo contains a set of `policy.yaml` files which can be used by the [Enterprise Contract
Command Line Interface](https://github.com/enterprise-contract/ec-cli) with a variety of
environments.

## Konflux CI

When using Red Hat's [Konflux CI](https://github.com/konflux-ci/)
environment, there is a predefined Integration Test pipeline definition for each of the configs in
this section. They can be used when creating an Integration Test in Konflux as per the [documentation
here](https://konflux-ci.dev/docs/advanced-how-tos/managing-compliance-with-ec/).

The policy configuration files are:

### Default

Includes rules for levels 1, 2 & 3 of SLSA v0.1. This is the default config used for new Konflux applications.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//default`
* Source: [default/policy.yaml](https://github.com/enterprise-contract/config/blob/main/default/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)

### Red Hat

Includes the full set of rules and policies required internally by Red Hat when building Red Hat products.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//redhat`
* Source: [redhat/policy.yaml](https://github.com/enterprise-contract/config/blob/main/redhat/policy.yaml)
* Collections: [@redhat](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#redhat)

### Red Hat (non hermetic)

Includes most of the rules and policies required internally by Red Hat when building Red Hat products. It excludes the requirement of hermetic builds.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//redhat-no-hermetic`
* Source: [redhat-no-hermetic/policy.yaml](https://github.com/enterprise-contract/config/blob/main/redhat-no-hermetic/policy.yaml)
* Collections: [@redhat](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#redhat)

### SLSA3

Rules specifically related to levels 1, 2 & 3 of SLSA v0.1, plus a set of basic checks that are expected to pass for all Konflux builds.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//slsa3`
* Source: [slsa3/policy.yaml](https://github.com/enterprise-contract/config/blob/main/slsa3/policy.yaml)
* Collections: [@minimal](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#minimal), [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)


## Stable (versioned policies)

The main branch of the [enterprise-contract/ec-policies](https://github.com/enterprise-contract/ec-policies)
is always tested with the [latest build of ec-cli](https://github.com/enterprise-contract/ec-cli/releases). If
your environment uses a specific version of ec-cli, such as
[the official Red Hat build](https://catalog.redhat.com/software/containers/rhtas/ec-rhel9/65f1f9dcfc649a18c6075de5),
then you can use one of these instead of the
[main branch default](https://github.com/enterprise-contract/config?tab=readme-ov-file#default).

They are similar to the [Konflux CI "default"](#default) configuration except they use a specific branch
of the policies repo for stability and compatiblity with specific verisons of ec. These configurations are
suggested for use in [Red Hat Trusted Application Pipeline](https://developers.redhat.com/products/trusted-application-pipeline/overview) templates.

The policy configuration files are:

### Default (v0.1-alpha)

Includes rules for levels 1, 2 & 3 of SLSA v0.1. For use with ec version v0.1-alpha.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//default-v0.1-alpha`
* Source: [default-v0.1-alpha/policy.yaml](https://github.com/enterprise-contract/config/blob/main/default-v0.1-alpha/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)

### Default (v0.2)

Includes rules for levels 1, 2 & 3 of SLSA v0.1. For use with ec version v0.2.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//default-v0.2`
* Source: [default-v0.2/policy.yaml](https://github.com/enterprise-contract/config/blob/main/default-v0.2/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)

### Default (v0.4)

Includes rules for levels 1, 2 & 3 of SLSA v0.1. For use with ec version v0.4

* URL for Enterprise Contract: `github.com/enterprise-contract/config//default-v0.4`
* Source: [default-v0.4/policy.yaml](https://github.com/enterprise-contract/config/blob/main/default-v0.4/policy.yaml)
* Collections: [@slsa3](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#slsa3)

### RHTAP Jenkins

Includes rules suitable for use with the attestations created by RHTAP Jenkins build pipelines.

* URL for Enterprise Contract: `github.com/enterprise-contract/config//rhtap-jenkins`
* Source: [rhtap-jenkins/policy.yaml](https://github.com/enterprise-contract/config/blob/main/rhtap-jenkins/policy.yaml)
* Collections: [@rhtap-jenkins](https://enterprisecontract.dev/docs/ec-policies/release_policy.html#rhtap-jenkins)


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
