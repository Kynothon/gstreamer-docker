GSTREAMER_REPO?=ggoussard/gstreamer:1.18.1
GSTREAMER_DOCKERFILE?=Dockerfile
CLOUD_REPO?=$(GSTREAMER_REPO)-aws
CLOUD_DOCKERFILE?=Dockerfile.cloud
DOCKER_CLI_EXPERIMENTAL=enabled

amd64:=linux/amd64
arm64:=linux/arm64
armv7:=linux/arm/v7

param = $(lastword $(subst -, ,$1))


gstreamer: gstreamer-amd64 gstreamer-arm64 gstreamer-armv7
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) -f $(GSTREAMER_DOCKERFILE) --push .

aws: aws-amd64 aws-arm64 aws-armv7
	@docker buildx build --platform $($(arch)) -t $(CLOUD_REPO) -f $(CLOUD_DOCKERFILE) --push .

gstreamer-builder-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) -f $(GSTREAMER_DOCKERFILE) --target=gst-plugins-base --load .

gstreamer-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) -f $(GSTREAMER_DOCKERFILE) .

aws-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(CLOUD_REPO) -f $(CLOUD_DOCKERFILE) .
