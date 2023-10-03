---
page_title: "rfc2136"
subcategory: "DNS Providers"
---

-> The following documentation is auto-generated from the ACME
provider's API library [lego](https://go-acme.github.io/lego/).  Some
sections may refer to lego directly - in most cases, these sections
apply to the Terraform provider as well.

# RFC2136 DNS Challenge Provider

The `rfc2136` DNS challenge provider can be used to perform DNS challenges for
the [`acme_certificate`][resource-acme-certificate] resource with
[RFC2136](https://www.rfc-editor.org/rfc/rfc2136.html).

[resource-acme-certificate]: ../resources/certificate.md

For complete information on how to use this provider with the `acme_certifiate`
resource, see [here][resource-acme-certificate-dns-challenges].

[resource-acme-certificate-dns-challenges]: ../resources/certificate.md#using-dns-challenges

## Example

```hcl
resource "acme_certificate" "certificate" {
  ...

  dns_challenge {
    provider = "rfc2136"
  }
}
```
## Argument Reference

The following arguments can be either passed as environment variables, or
directly through the `config` block in the
[`dns_challenge`][resource-acme-certificate-dns-challenge-arg] argument in the
[`acme_certificate`][resource-acme-certificate] resource. For more details, see
[here][resource-acme-certificate-dns-challenges].

[resource-acme-certificate-dns-challenge-arg]: ../resources/certificate.md#dns_challenge

In addition, arguments can also be stored in a local file, with the path
supplied by supplying the argument with the `_FILE` suffix. See
[here][acme-certificate-file-arg-example] for more information.

[acme-certificate-file-arg-example]: ../resources/certificate.md#using-variable-files-for-provider-arguments

* `RFC2136_NAMESERVER` - Network address in the form "host" or "host:port".
* `RFC2136_TSIG_ALGORITHM` - TSIG algorithm. See [miekg/dns#tsig.go](https://github.com/miekg/dns/blob/master/tsig.go) for supported values. To disable TSIG authentication, leave the `RFC2136_TSIG*` variables unset..
* `RFC2136_TSIG_KEY` - Name of the secret key as defined in DNS server configuration. To disable TSIG authentication, leave the `RFC2136_TSIG*` variables unset..
* `RFC2136_TSIG_SECRET` - Secret key payload. To disable TSIG authentication, leave the` RFC2136_TSIG*` variables unset..

* `RFC2136_DNS_TIMEOUT` - API request timeout.
* `RFC2136_POLLING_INTERVAL` - Time between DNS propagation check.
* `RFC2136_PROPAGATION_TIMEOUT` - Maximum waiting time for DNS propagation.
* `RFC2136_SEQUENCE_INTERVAL` - Time between sequential requests.
* `RFC2136_TTL` - The TTL of the TXT record used for the DNS challenge.


