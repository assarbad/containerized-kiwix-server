CONTNAME:=kiwix-serve
DEFAULT=docker
DRIVER:=$(DEFAULT)
BUILDER=$(DRIVER)
RUNNER=$(DRIVER)
BUILDCMD=build
ZIMDIR=/srv/zims

.DEFAULT: $(DEFAULT)

docker: container

# Overrides for podman
podman: BUILDER=buildah
podman: BUILDCMD=bud
podman: DRIVER=podman

podman: container

container:
	-@echo Creating image, if it does not already exist
	test -z "$(shell $(DRIVER) images -q $(CONTNAME))" && $(BUILDER) $(BUILDCMD) -t $(CONTNAME) .; true
	-@echo Running container from image
	if ! $(DRIVER) container exists $(CONTNAME); then $(DRIVER) run --detach --name $(CONTNAME) --publish 8080:8080 --volume $(abspath $(ZIMDIR)):/zims:ro $$($(DRIVER) images -q $(CONTNAME)); fi

clean:
	-@echo Removing container
	if $(DRIVER) container exists $(CONTNAME); then $(DRIVER) stop $(CONTNAME); $(DRIVER) rm $(CONTNAME); fi
	-@echo Removing image
	test -n "$(shell $(DRIVER) images -q $(CONTNAME))" && $(DRIVER) rmi $(shell $(DRIVER) images -q $(CONTNAME)); true

rebuild: clean $(DEFAULT)

.PHONY: container docker podman clean rebuild
