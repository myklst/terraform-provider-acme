package acme

import (
	"reflect"
	"testing"

	"github.com/davecgh/go-spew/spew"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
)

func testACMERegistrationStateDataV0() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "regurl",
		Attributes: map[string]string{
			"server_url":                 "https://acme-staging.api.letsencrypt.org/directory",
			"account_key_pem":            "key",
			"email_address":              "nobody@example.com",
			"registration_body":          "regbody",
			"registration_url":           "https://acme-staging.api.letsencrypt.org/acme/reg/123456789",
			"registration_new_authz_url": "https://acme-staging.api.letsencrypt.org/acme/new-authz",
			"registration_tos_url":       "https://letsencrypt.org/documents/LE-SA-v1.0.1-July-27-2015.pdf",
		},
	}
}

func testACMERegistrationStateDataV1() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "regurl",
		Attributes: map[string]string{
			"account_key_pem":  "key",
			"email_address":    "nobody@example.com",
			"registration_url": "https://acme-staging.api.letsencrypt.org/acme/reg/123456789",
		},
	}
}

func testACMECertificateStateDataV0() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "certurl",
		Attributes: map[string]string{
			"server_url":                  "https://acme-staging.api.letsencrypt.org/directory",
			"account_key_pem":             "key",
			"common_name":                 "foobar",
			"subject_alternative_names.#": "2",
			"subject_alternative_names.0": "barbar",
			"subject_alternative_names.1": "bazbar",
			"key_type":                    "2048",
			"certificate_request_pem":     "req",
			"min_days_remaining":          "30",
			"dns_challenge.#":             "1",
			"dns_challenge.1234.provider": "route53",
			// Workaround for E2E migration test. recursive_nameservers is
			// not a part of schema at this version.
			"dns_challenge.1234.recursive_nameservers.#": "1",
			"dns_challenge.1234.recursive_nameservers.0": "my.name.server",
			"http_challenge_port":                        "80",
			"tls_challenge_port":                         "443",
			"registration_url":                           "regurl",
			"must_staple":                                "0",
			"certificate_domain":                         "foobar",
			"certificate_url":                            "certurl",
			"account_ref":                                "regurl",
			"private_key_pem":                            "certkey",
			"certificate_pem":                            "certpem",
		},
	}
}

func testACMECertificateStateDataV1() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "certurl",
		Attributes: map[string]string{
			"account_key_pem":             "key",
			"common_name":                 "foobar",
			"subject_alternative_names.#": "2",
			"subject_alternative_names.0": "barbar",
			"subject_alternative_names.1": "bazbar",
			"key_type":                    "2048",
			"certificate_request_pem":     "req",
			"min_days_remaining":          "30",
			"dns_challenge.#":             "1",
			"dns_challenge.1234.provider": "route53",
			// Workaround for E2E migration test. recursive_nameservers is
			// not a part of schema at this version.
			"dns_challenge.1234.recursive_nameservers.#": "1",
			"dns_challenge.1234.recursive_nameservers.0": "my.name.server",
			"must_staple":        "0",
			"certificate_domain": "foobar",
			"account_ref":        "regurl",
			"private_key_pem":    "certkey",
			"certificate_pem":    "certpem",
			"certificate_url":    "certurl",
		},
	}
}

func testACMECertificateStateDataV2() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "certurl",
		Attributes: map[string]string{
			"account_key_pem":             "key",
			"common_name":                 "foobar",
			"subject_alternative_names.#": "2",
			"subject_alternative_names.0": "barbar",
			"subject_alternative_names.1": "bazbar",
			"key_type":                    "2048",
			"certificate_request_pem":     "req",
			"min_days_remaining":          "30",
			"dns_challenge.#":             "1",
			"dns_challenge.1234.provider": "route53",
			// Workaround for E2E migration test. recursive_nameservers is
			// not a part of schema at this version.
			"dns_challenge.1234.recursive_nameservers.#": "1",
			"dns_challenge.1234.recursive_nameservers.0": "my.name.server",
			"must_staple":        "0",
			"certificate_domain": "foobar",
			"private_key_pem":    "certkey",
			"certificate_pem":    "certpem",
			"certificate_url":    "certurl",
		},
	}
}

func testACMECertificateStateDataV3() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "certurl",
		Attributes: map[string]string{
			"account_key_pem":                         "key",
			"common_name":                             "foobar",
			"subject_alternative_names.#":             "2",
			"subject_alternative_names.0":             "barbar",
			"subject_alternative_names.1":             "bazbar",
			"key_type":                                "2048",
			"certificate_request_pem":                 "req",
			"min_days_remaining":                      "30",
			"dns_challenge.#":                         "1",
			"dns_challenge.0.provider":                "route53",
			"dns_challenge.0.recursive_nameservers.#": "1",
			"dns_challenge.0.recursive_nameservers.0": "my.name.server",
			"must_staple":                             "0",
			"certificate_domain":                      "foobar",
			"private_key_pem":                         "certkey",
			"certificate_pem":                         "certpem",
			"certificate_url":                         "certurl",
		},
	}
}

func testACMECertificateStateDataV4() *terraform.InstanceState {
	return &terraform.InstanceState{
		ID: "certurl",
		Attributes: map[string]string{
			"account_key_pem":             "key",
			"common_name":                 "foobar",
			"subject_alternative_names.#": "2",
			"subject_alternative_names.0": "barbar",
			"subject_alternative_names.1": "bazbar",
			"key_type":                    "2048",
			"certificate_request_pem":     "req",
			"min_days_remaining":          "30",
			"dns_challenge.#":             "1",
			"dns_challenge.0.provider":    "route53",
			"recursive_nameservers.#":     "1",
			"recursive_nameservers.0":     "my.name.server",
			"must_staple":                 "0",
			"certificate_domain":          "foobar",
			"private_key_pem":             "certkey",
			"certificate_pem":             "certpem",
			"certificate_url":             "certurl",
		},
	}
}

func TestResourceACMERegistrationMigrateState(t *testing.T) {
	expected := testACMERegistrationStateDataV1()
	actual, err := resourceACMERegistrationMigrateState(0, testACMERegistrationStateDataV0(), nil)
	if err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestMigrateACMERegistrationStateV1(t *testing.T) {
	expected := testACMERegistrationStateDataV1()
	actual := testACMERegistrationStateDataV0()
	if err := migrateACMERegistrationStateV1(actual, nil); err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestResourceACMECertificateMigrateState(t *testing.T) {
	expected := testACMECertificateStateDataV4()
	actual, err := resourceACMECertificateMigrateState(0, testACMECertificateStateDataV0(), nil)
	if err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestMigrateACMECertificateStateV4(t *testing.T) {
	expected := testACMECertificateStateDataV4()
	actual := testACMECertificateStateDataV3()
	if err := migrateACMECertificateStateV4(actual, nil); err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestMigrateACMECertificateStateV3(t *testing.T) {
	expected := testACMECertificateStateDataV3()
	actual := testACMECertificateStateDataV2()
	if err := migrateACMECertificateStateV3(actual, nil); err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestMigrateACMECertificateStateV2(t *testing.T) {
	expected := testACMECertificateStateDataV2()
	actual := testACMECertificateStateDataV1()
	if err := migrateACMECertificateStateV2(actual, nil); err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}

func TestMigrateACMECertificateStateV1(t *testing.T) {
	expected := testACMECertificateStateDataV1()
	actual := testACMECertificateStateDataV0()
	if err := migrateACMECertificateStateV1(actual, nil); err != nil {
		t.Fatalf("error migrating state: %s", err)
	}

	if !reflect.DeepEqual(expected, actual) {
		t.Fatalf("\n\nexpected:\n\n%s\n\ngot:\n\n%s\n\n", spew.Sdump(expected), spew.Sdump(actual))
	}
}
