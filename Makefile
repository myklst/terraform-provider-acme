SUBMODULE_VERSION ?= v2.21.0
PATCH_APPLY_VERSION ?= v2.21.0
SUBMODULE_PATH ?= submodule/acme
ORI_SUBMODULE_NAME ?= submodule/acme_copy
RM_SUBMODULE_NAME ?= submodule/acme
CUSTOM_PROVIDER_NAME ?= terraform-provider-acme
CUSTOM_PROVIDER_URL ?= example.local/myklst/acme

.PHONY: git-submodule-update
git-submodule-update:
	git submodule update --init --recursive

.PHONY: copy-submodule
copy-submodule:
	cp -r submodule/acme submodule/acme_copy

.PHONY: create-patch
create-patch:
	diff -u $(ORI_SUBMODULE_NAME)/acme/acme_structure.go $(SUBMODULE_PATH)/acme/acme_structure.go > ./patch/$(SUBMODULE_VERSION)/acme_structure.go.patch  || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/certificate_challenges.go $(SUBMODULE_PATH)/acme/certificate_challenges.go > ./patch/$(SUBMODULE_VERSION)/certificate_challenges.go.patch  || exit 0
	diff -N $(ORI_SUBMODULE_NAME)/acme/errorlist.go $(SUBMODULE_PATH)/acme/errorlist.go > ./patch/$(SUBMODULE_VERSION)/errorlist.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/resource_acme_certificate.go $(SUBMODULE_PATH)/acme/resource_acme_certificate.go > ./patch/$(SUBMODULE_VERSION)/resource_acme_certificate.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/resource_acme_registration.go $(SUBMODULE_PATH)/acme/resource_acme_registration.go > ./patch/$(SUBMODULE_VERSION)/resource_acme_registration.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/docs/index.md $(SUBMODULE_PATH)/docs/index.md > ./patch/$(SUBMODULE_VERSION)/index.md.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/.gitignore $(SUBMODULE_PATH)/.gitignore > ./patch/$(SUBMODULE_VERSION)/.gitignore.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/go.mod $(SUBMODULE_PATH)/go.mod > ./patch/$(SUBMODULE_VERSION)/go.mod.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/.goreleaser.yml $(SUBMODULE_PATH)/.goreleaser.yml > ./patch/$(SUBMODULE_VERSION)/.goreleaser.yml.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/go.sum $(SUBMODULE_PATH)/go.sum > ./patch/$(SUBMODULE_VERSION)/go.sum.patch || exit 0
	diff -N $(ORI_SUBMODULE_NAME)/terraform-registry-manifest.json $(SUBMODULE_PATH)/terraform-registry-manifest.json > ./patch/$(SUBMODULE_VERSION)/terraform-registry-manifest.json.patch || exit 0

.PHONY: patch-file
patch-file:
	-patch -p0 $(SUBMODULE_PATH)/acme/acme_structure.go < ./patch/$(PATCH_APPLY_VERSION)/acme_structure.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/certificate_challenges.go < ./patch/$(PATCH_APPLY_VERSION)/certificate_challenges.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/errorlist.go < ./patch/$(PATCH_APPLY_VERSION)/errorlist.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/resource_acme_certificate.go < ./patch/$(PATCH_APPLY_VERSION)/resource_acme_certificate.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/resource_acme_registration.go < ./patch/$(PATCH_APPLY_VERSION)/resource_acme_registration.go.patch
	-patch -p0 $(SUBMODULE_PATH)/docs/index.md < ./patch/$(PATCH_APPLY_VERSION)/index.md.patch
	-patch -p0 $(SUBMODULE_PATH)/.gitignore < ./patch/$(PATCH_APPLY_VERSION)/.gitignore.patch
	-patch -p0 $(SUBMODULE_PATH)/go.mod < ./patch/$(PATCH_APPLY_VERSION)/go.mod.patch
	-patch -p0 $(SUBMODULE_PATH)/.goreleaser.yml < ./patch/$(PATCH_APPLY_VERSION)/.goreleaser.yml.patch
	-patch -p0 $(SUBMODULE_PATH)/go.sum < ./patch/$(PATCH_APPLY_VERSION)/go.sum.patch
	-patch -p0 $(SUBMODULE_PATH)/terraform-registry-manifest.json < ./patch/$(PATCH_APPLY_VERSION)/terraform-registry-manifest.json.patch

.PHONY: install-local-custom-provider
install-local-custom-provider:
	export PROVIDER_LOCAL_PATH='$(CUSTOM_PROVIDER_URL)'
	cd submodule/acme && go install .
	GO_INSTALL_PATH="$$(go env GOPATH)/bin"; \
	HOME_DIR="$$(ls -d ~)"; \
	mkdir -p  $$HOME_DIR/.terraform.d/plugins/$(CUSTOM_PROVIDER_URL)/0.1.0/linux_amd64/; \
	cp $$GO_INSTALL_PATH/$(CUSTOM_PROVIDER_NAME) $$HOME_DIR/.terraform.d/plugins/$(CUSTOM_PROVIDER_URL)/0.1.0/linux_amd64/$(CUSTOM_PROVIDER_NAME)
	unset PROVIDER_LOCAL_PATH

# copy the new docs to the main to have docs on terraform registry.
.PHONY: copy-docs-main
copy-docs-main:
	cp -r submodule/acme/docs .

.PHONY: copy-readme-main
copy-readme-main:
	cp -r submodule/acme/README.md .

# Remove submodule
.PHONY: rm-submodule-acme
rm-submodule-acme:
	git submodule deinit -f $(RM_SUBMODULE_NAME)
	git rm -f $(RM_SUBMODULE_NAME)
	rm -rf .git/modules/$(RM_SUBMODULE_NAME)
	rm -rf ./submoduleACME
