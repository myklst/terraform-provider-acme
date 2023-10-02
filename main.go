package main

import (
	"os"

	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
	"github.com/vancluever/terraform-provider-acme/v2/acme"
	"github.com/vancluever/terraform-provider-acme/v2/acme/dnsplugin"
)

func main() {
	if len(os.Args) == 2 && os.Args[1] == dnsplugin.PluginArg {
		// Start the plugin here
		dnsplugin.Serve()
	} else {
		initLegoLogger()
		plugin.Serve(&plugin.ServeOpts{
			ProviderFunc: acme.Provider,
		})
	}
}
