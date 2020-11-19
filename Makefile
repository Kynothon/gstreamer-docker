GSTREAMER_TAG?=1.18.1
GSTREAMER_BASE?=ggoussard/gstreamer
GSTREAMER_REPO?=$(GSTREAMER_BASE):$(GSTREAMER_TAG)
GSTREAMER_DOCKERFILE?=Dockerfile
CLOUD_REPO?=$(GSTREAMER_REPO)-aws
CLOUD_DOCKERFILE?=Dockerfile.cloud
DEV_REPO?=$(GSTREAMER_REPO)-dev
DOCKER_CLI_EXPERIMENTAL=enabled

amd64:=linux/amd64
arm64:=linux/arm64
armv7:=linux/arm/v7

comma:= ,
empty:=
space:=$(empty) $(empty)
param = $(lastword $(subst -, ,$1))

gstreamer: gstreamer-amd64 gstreamer-arm64 gstreamer-armv7
	$(eval arch_list=$(foreach prereq,$^,$($(call param, $(prereq)))))
	$(eval platforms=$(subst $(space),$(comma),$(arch_list)))	
	@docker buildx build --platform $(platforms) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --push .

gstreamer-dev: gstreamer-dev-amd64 gstreamer-dev-arm64 gstreamer-dev-armv7
	$(eval arch_list=$(foreach prereq,$^,$($(call param, $(prereq)))))
	$(eval platforms=$(subst $(space),$(comma),$(arch_list)))	
	@docker buildx build --platform $(platforms) -t $(DEV_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --target=gst-plugins-base --push .

gstreamer-aws: gstreamer-aws-amd64 gstreamer-aws-arm64 gstreamer-aws-armv7
	$(eval arch_list=$(foreach prereq,$^,$($(call param, $(prereq)))))
	$(eval platforms=$(subst $(space),$(comma),$(arch_list)))	
	@docker buildx build --platform $(platforms) -t $(CLOUD_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(CLOUD_DOCKERFILE)  --push .

gstreamer-dev-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --target=gst-plugins-base --load .

gstreamer-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) .

gstreamer-aws-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(CLOUD_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(CLOUD_DOCKERFILE) .
