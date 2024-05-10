SUBMODULE_VERSION ?= v2.21.0
PATCH_APPLY_VERSION ?= v2.21.0
PATCH_APPLY_DIRECTORY ?= submodule/acme
ORI_SUBMODULE_NAME ?= submodule/acme_copy
RM_SUBMODULE_NAME ?= submoduleACME

.PHONY: git-submodule-update
update-submodule:
	git submodule update --init --recursive

.PHONY: patch-file
patching:
	-patch --directory=$(PATCH_APPLY_DIRECTORY) -p2 < ./patch/subModule-$(PATCH_APPLY_VERSION).patch

.PHONY: create-patch
create-patch:
	diff -ruN --exclude=.git/ --exclude=.git  --exclude=.git. ./$(ORI_SUBMODULE_NAME) ./submodule/acme > ./patch/subModule-$(SUBMODULE_VERSION).patch || exit 0

# copy the new docs to the main to have docs on terraform registry.
.PHONY: copy-docs-main
cp-docs-main:
	cp -r submoduleACME/docs .

.PHONY: copy-readme-main
cp-readme-main:
	cp -r submoduleACME/README.md .

# Remove submodule
.PHONY: rm-submoduleACME
rm-submoduleACME:
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
	rsync -av --progress ./submoduleACME/ . --exclude .git --exclude .gitignore --exclude GNUmakefile --exclude .github/ --exclude *.md
