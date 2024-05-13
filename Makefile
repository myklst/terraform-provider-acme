SUBMODULE_VERSION ?= v2.21.0
PATCH_APPLY_VERSION ?= v2.21.0
SUBMODULE_PATH ?= submodule/acme
ORI_SUBMODULE_NAME ?= submodule/acme_copy
RM_SUBMODULE_NAME ?= submodule/acme

.PHONY: git-submodule-update
update-submodule:
	git submodule update --init --recursive

.PHONY: copy-submodule
cp-submodule:
	cp -r submodule/acme submodule/acme_copy

.PHONY: create-patch
create-patch:
	diff -u $(ORI_SUBMODULE_NAME)/acme/acme_structure.go $(SUBMODULE_PATH)/acme/acme_structure.go > ./patch/$(SUBMODULE_VERSION)/acme_structure.go.patch  || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/certificate_challenges.go $(SUBMODULE_PATH)/acme/certificate_challenges.go > ./patch/$(SUBMODULE_VERSION)/certificate_challenges.go.patch  || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/dnsplugin/client.go $(SUBMODULE_PATH)/acme/dnsplugin/client.go > ./patch/$(SUBMODULE_VERSION)/client.go.patch  || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/dnsplugin/plugin.go $(SUBMODULE_PATH)/acme/dnsplugin/plugin.go > ./patch/$(SUBMODULE_VERSION)/plugin.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/dnsplugin/plugin_test.go $(SUBMODULE_PATH)/acme/dnsplugin/plugin_test.go > ./patch/$(SUBMODULE_VERSION)/plugin_test.go.patch || exit 0
	diff -N $(ORI_SUBMODULE_NAME)/acme/errorlist.go $(SUBMODULE_PATH)/acme/errorlist.go > ./patch/$(SUBMODULE_VERSION)/errorlist.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/provider_test.go $(SUBMODULE_PATH)/acme/provider_test.go > ./patch/$(SUBMODULE_VERSION)/provider_test.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/resource_acme_certificate.go $(SUBMODULE_PATH)/acme/resource_acme_certificate.go > ./patch/$(SUBMODULE_VERSION)/resource_acme_certificate.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/acme/resource_acme_registration.go $(SUBMODULE_PATH)/acme/resource_acme_registration.go > ./patch/$(SUBMODULE_VERSION)/resource_acme_registration.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/docs/index.md $(SUBMODULE_PATH)/docs/index.md > ./patch/$(SUBMODULE_VERSION)/index.md.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/docs/resources/certificate.md $(SUBMODULE_PATH)/docs/resources/certificate.md > ./patch/$(SUBMODULE_VERSION)/certificate.md.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/.gitignore $(SUBMODULE_PATH)/.gitignore > ./patch/$(SUBMODULE_VERSION)/.gitignore.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/go.mod $(SUBMODULE_PATH)/go.mod > ./patch/$(SUBMODULE_VERSION)/go.mod.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/.goreleaser.yml $(SUBMODULE_PATH)/.goreleaser.yml > ./patch/$(SUBMODULE_VERSION)/.goreleaser.yml.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/go.sum $(SUBMODULE_PATH)/go.sum > ./patch/$(SUBMODULE_VERSION)/go.sum.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/main.go $(SUBMODULE_PATH)/main.go > ./patch/$(SUBMODULE_VERSION)/main.go.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/proto/dnsplugin/v1/dnsplugin.proto $(SUBMODULE_PATH)/proto/dnsplugin/v1/dnsplugin.proto > ./patch/$(SUBMODULE_VERSION)/dnsplugin.proto.patch || exit 0
	diff -u $(ORI_SUBMODULE_NAME)/README.md $(SUBMODULE_PATH)/README.md > ./patch/$(SUBMODULE_VERSION)/README.md.patch || exit 0

.PHONY: patch-file
patching:
	-patch -p0 $(SUBMODULE_PATH)/acme/acme_structure.go < ./patch/$(PATCH_APPLY_VERSION)/acme_structure.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/certificate_challenges.go < ./patch/$(PATCH_APPLY_VERSION)/certificate_challenges.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/dnsplugin/client.go < ./patch/$(PATCH_APPLY_VERSION)/client.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/dnsplugin/plugin.go < ./patch/$(PATCH_APPLY_VERSION)/plugin.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/dnsplugin/plugin_test.go < ./patch/$(PATCH_APPLY_VERSION)/plugin_test.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/errorlist.go < ./patch/$(PATCH_APPLY_VERSION)/errorlist.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/provider_test.go < ./patch/$(PATCH_APPLY_VERSION)/provider_test.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/resource_acme_certificate.go < ./patch/$(PATCH_APPLY_VERSION)/resource_acme_certificate.go.patch
	-patch -p0 $(SUBMODULE_PATH)/acme/resource_acme_registration.go < ./patch/$(PATCH_APPLY_VERSION)/resource_acme_registration.go.patch
	-patch -p0 $(SUBMODULE_PATH)/docs/index.md < ./patch/$(PATCH_APPLY_VERSION)/index.md.patch
	-patch -p0 $(SUBMODULE_PATH)/docs/resources/certificate.md < ./patch/$(PATCH_APPLY_VERSION)/certificate.md.patch
	-patch -p0 $(SUBMODULE_PATH)/.gitignore < ./patch/$(PATCH_APPLY_VERSION)/.gitignore.patch
	-patch -p0 $(SUBMODULE_PATH)/go.mod < ./patch/$(PATCH_APPLY_VERSION)/go.mod.patch
	-patch -p0 $(SUBMODULE_PATH)/.goreleaser.yml < ./patch/$(PATCH_APPLY_VERSION)/.goreleaser.yml.patch
	-patch -p0 $(SUBMODULE_PATH)/go.sum < ./patch/$(PATCH_APPLY_VERSION)/go.sum.patch
	-patch -p0 $(SUBMODULE_PATH)/main.go < ./patch/$(PATCH_APPLY_VERSION)/main.go.patch
	-patch -p0 $(SUBMODULE_PATH)/proto/dnsplugin/v1/dnsplugin.proto < ./patch/$(PATCH_APPLY_VERSION)/dnsplugin.proto.patch
	-patch -p0 $(SUBMODULE_PATH)/README.md < ./patch/$(PATCH_APPLY_VERSION)/README.md.patch

# copy the new docs to the main to have docs on terraform registry.
.PHONY: copy-docs-main
cp-docs-main:
	cp -r submodule/acme/docs .

.PHONY: copy-readme-main
cp-readme-main:
	cp -r submodule/acme/README.md .

# Remove submodule
.PHONY: rm-submodule-acme
rm-submodule-acme:
	git submodule deinit -f $(RM_SUBMODULE_NAME)
	git rm -f $(RM_SUBMODULE_NAME)
	rm -rf .git/modules/$(RM_SUBMODULE_NAME)
	rm -rf ./submoduleACME

#########################################################
# Use in github action to move the submodule to the main
# for running the gorelease
#########################################################
.PHONY: move-sub-module-to-main
move-sub-to-main:
	rsync -av --progress ./submodule/acme/ . --exclude .git --exclude .gitignore --exclude GNUmakefile --exclude .github/ --exclude *.md
