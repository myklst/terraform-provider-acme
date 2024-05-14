Terraform ACME Provider
=======================

This is the repository for the Terraform ACME Provider, which one can use with
Terraform to manage and generate certificates generated by an [ACME](https://ietf-wg-acme.github.io/acme/draft-ietf-acme-acme.html)
CA, such as Let's Encrypt, ZeroSSL and GCP.

For general information about Terraform, visit the [official
website](https://www.terraform.io/) and the [GitHub project page](https://github.com/hashicorp/terraform).

**WARNING:** The ACME provider found here supports ACME v2 only.

## Documentation

This is a submodule repository of Terraform ACME provider by vancluever.
Documentation for this provider can be found at [Terraform ACME Provider](https://registry.terraform.io/providers/vancluever/acme/latest/docs)

## Why Patch

To make use repository of Terraform ACME provider by vancluever and customize backoff retry functionalities when ordering/revoking/making challange to certificates.

Facing issue unable to apply the patch, mean that the version might changed or the patch files has beend modified.

If the version of Terraform ACME provider by vancluever has been changes, you might need to patch agains.

## Retryable Errors

Add retryable errors under `./acme/errorlist.go` such as API limiting and throttling.
