package acme

import (
	"fmt"
	"testing"

	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/resource"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/terraform"
)

func TestAccACMERegistration_basic(t *testing.T) {
	resource.Test(t, resource.TestCase{
		ProviderFactories: testAccProviders,
		ExternalProviders: testAccExternalProviders,
		CheckDestroy:      testAccCheckACMERegistrationValid("acme_registration.reg", false, pebbleDirBasic),
		Steps: []resource.TestStep{
			{
				Config: testAccACMERegistrationConfig(),
				Check: resource.ComposeTestCheckFunc(
					resource.TestCheckResourceAttrPair(
						"acme_registration.reg", "id",
						"acme_registration.reg", "registration_url",
					),
					testAccCheckACMERegistrationValid("acme_registration.reg", true, pebbleDirBasic),
				),
			},
		},
	})
}

func TestAccACMERegistration_eab(t *testing.T) {
	resource.Test(t, resource.TestCase{
		ProviderFactories: testAccProviders,
		ExternalProviders: testAccExternalProviders,
		CheckDestroy:      testAccCheckACMERegistrationValid("acme_registration.reg", false, pebbleDirEAB),
		Steps: []resource.TestStep{
			{
				Config: testAccACMERegistrationConfigEAB(),
				Check: resource.ComposeTestCheckFunc(
					resource.TestCheckResourceAttrPair(
						"acme_registration.reg", "id",
						"acme_registration.reg", "registration_url",
					),
					testAccCheckACMERegistrationValid("acme_registration.reg", true, pebbleDirEAB),
				),
			},
		},
	})
}

func TestAccACMERegistration_refreshDeactivated(t *testing.T) {
	var state *terraform.State
	resource.Test(t, resource.TestCase{
		ProviderFactories: testAccProviders,
		ExternalProviders: testAccExternalProviders,
		Steps: []resource.TestStep{
			{
				Config: testAccACMERegistrationConfig(),
				Check: resource.ComposeTestCheckFunc(
					func(s *terraform.State) error {
						state = s
						return nil
					},
					resource.TestCheckResourceAttrPair(
						"acme_registration.reg", "id",
						"acme_registration.reg", "registration_url",
					),
					testAccCheckACMERegistrationValid("acme_registration.reg", true, pebbleDirBasic),
				),
			},
			{
				PreConfig: func() {
					rs := state.RootModule().Resources["acme_registration.reg"]
					d := testAccCheckACMERegistrationResourceData(rs)
					client, _, err := expandACMEClient(d, testAccProviderAcmeConfig(pebbleDirBasic), true)
					if err != nil {
						panic(err)
					}

					if err := client.Registration.DeleteRegistration(); err != nil {
						panic(err)
					}
				},
				Config:             testAccACMERegistrationConfig(),
				PlanOnly:           true,
				ExpectNonEmptyPlan: true,
			},
		},
	})
}

func testAccCheckACMERegistrationValid(n string, exists bool, acmeServerUrl string) resource.TestCheckFunc {
	return func(s *terraform.State) error {
		rs, ok := s.RootModule().Resources[n]
		if !ok {
			if !exists {
				// No state, but this is okay. The new TF SDK completely
				// removes state for deleted resources before the destroy
				// check runs, so we cannot do in-band verification of
				// resource deletion. Normal patterns loop through state
				// looking for resources, using a pattern like this:
				//
				// for _, rs := range s.RootModule().Resources {
				//   if rs.Type != "example_widget" {
				//     continue
				//   }
				//
				//   ...
				// }
				//
				// This pattern will completely miss the fact that the
				// resource state doesn't exist at all, and return no error.
				//
				// TODO: Maybe put in a bug report for this and see if the
				// SDK can be adjusted to allow for the passing in of
				// pre-destroy state to see if we can assert the deletion of
				// the resource from infrastructure, and not just TF state.
				//
				// Return nil to pass the test.
				return nil
			}

			return fmt.Errorf("Can't find ACME registration: %s", n)
		}

		if rs.Primary.ID == "" {
			return fmt.Errorf("ACME registration ID not set")
		}

		d := testAccCheckACMERegistrationResourceData(rs)

		client, _, err := expandACMEClient(d, testAccProviderAcmeConfig(acmeServerUrl), true)
		if err != nil {
			if regGone(err) && !exists {
				return nil
			}
			return fmt.Errorf("Could not build ACME client off reg: %s", err.Error())
		}

		reg, err := client.Registration.QueryRegistration()
		if err != nil {
			return fmt.Errorf("Error on reg query: %s", err.Error())
		}

		actual := reg.URI
		expected := rs.Primary.ID

		if actual != expected {
			return fmt.Errorf("Expected ID to be %s, got %s", expected, actual)
		}
		return nil
	}
}

// testAccCheckACMERegistrationResourceData returns a *schema.ResourceData that should match a
// acme_registration resource.
func testAccCheckACMERegistrationResourceData(rs *terraform.ResourceState) *schema.ResourceData {
	r := resourceACMERegistration()
	d := r.TestResourceData()

	d.SetId(rs.Primary.ID)
	d.Set("account_key_pem", rs.Primary.Attributes["account_key_pem"])
	d.Set("email_address", rs.Primary.Attributes["email_address"])

	return d
}

func testAccACMERegistrationConfig() string {
	return fmt.Sprintf(`
provider "acme" {
  server_url = "%s"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "nobody@example.test"
}
`, pebbleDirBasic)
}

func testAccACMERegistrationConfigEAB() string {
	return fmt.Sprintf(`
provider "acme" {
  server_url = "%s"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "nobody@example.test"
  external_account_binding {
    key_id      = "kid-1"
    hmac_base64 = "zWNDZM6eQGHWpSRTPal5eIUYFTu7EajVIoguysqZ9wG44nMEtx3MUAsUDkMTQ12W"
  }
}
`, pebbleDirEAB)
}
