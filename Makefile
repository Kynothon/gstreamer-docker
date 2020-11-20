GSTREAMER_TAG?=1.18.1
GSTREAMER_BASE?=ggoussard/gstreamer
GSTREAMER_REPO?=$(GSTREAMER_BASE):$(GSTREAMER_TAG)
GSTREAMER_DOCKERFILE?=Dockerfile
CLOUD_REPO?=$(GSTREAMER_REPO)-aws
CLOUD_DOCKERFILE?=Dockerfile.cloud
DEV_REPO?=$(GSTREAMER_REPO)-dev

include utils.mk

gstreamer: gstreamer-amd64 gstreamer-arm64 gstreamer-armv7
	$(eval platform=$(call platforms,$^))
	@docker buildx build --platform $(platform) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --push .

gstreamer-dev: gstreamer-dev-amd64 gstreamer-dev-arm64 gstreamer-dev-armv7
	$(eval platform=$(call platforms,$^))
	@docker buildx build --platform $(platform) -t $(DEV_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --target=gst-plugins-base --push .

gstreamer-aws: gstreamer-aws-amd64 gstreamer-aws-arm64 gstreamer-aws-armv7
	$(eval platform=$(call platforms,$^))
	@docker buildx build --platform $(platform) -t $(CLOUD_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(CLOUD_DOCKERFILE) --push .

gstreamer-dev-%:
	$(eval arch=$(call param,$@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --target=gst-plugins-base --load .

gstreamer-%:
	$(eval arch=$(call param,$@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(GSTREAMER_DOCKERFILE) --load .

gstreamer-aws-%:
	$(eval arch=$(call param,$@))
	@docker buildx build --platform $($(arch)) -t $(CLOUD_REPO) --build-arg GST_VERSION=$(GSTREAMER_TAG) -f $(CLOUD_DOCKERFILE) --load .
