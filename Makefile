GSTREAMER_TAG?=1.18.1
GSTREAMER_BASE?=ggoussard/gstreamer
GSTREAMER_REPO?=$(GSTREAMER_BASE):$(GSTREAMER_TAG)
GSTREAMER_DOCKERFILE?=Dockerfile
CLOUD_REPO?=$(GSTREAMER_REPO)-aws
CLOUD_DOCKERFILE?=Dockerfile.cloud
DEV_REPO?=$(GSTREAMER_REPO)-dev

include utils.mk

gstreamer: gstreamer-amd64 gstreamer-arm64 gstreamer-armv7
	$(call buildxx,$@,$(GSTREAMER_REPO),$(GSTREAMER_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG),push)

gstreamer-%:
	$(call buildxx,$@,$(GSTREAMER_REPO),$(GSTREAMER_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG),load)

gstreamer-dev: gstreamer-dev-amd64 gstreamer-dev-arm64 gstreamer-dev-armv7
	$(call buildxx,$@,$(GSTREAMER_REPO),$(GSTREAMER_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG) --target=gst-plugins-base,push)

gstreamer-dev-%:
	$(call buildxx,$@,$(GSTREAMER_REPO),$(GSTREAMER_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG) --target=gst-plugins-base,load)

gstreamer-aws: gstreamer-aws-amd64 gstreamer-aws-arm64 gstreamer-aws-armv7
	$(call buildxx,$^,$(CLOUD_REPO),$(CLOUD_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG),push)

gstreamer-aws-%:
	$(call buildxx,$@,$(CLOUD_REPO),$(CLOUD_DOCKERFILE),--build-arg GST_VERSION=$(GSTREAMER_TAG),load)

