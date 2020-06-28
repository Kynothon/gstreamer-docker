GSTREAMER_REPO?=ggoussard/gstreamer:1.16.2
GSTREAMER_DOCKERFILE?=Dockerfile
CLOUD_REPO?=$(GSTREAMER_REPO)-aws
CLOUD_DOCKERFILE?=Dockerfile.cloud

amd64:=linux/amd64
arm64:=linux/arm64
armv7:=linux/arm/v7

param = $(lastword $(subst -, ,$1))

gstreamer: gstreamer-amd64 gstreamer-arm64 gstreamer-armv7

aws: gstreamer-aws-amd64

gstreamer-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(GSTREAMER_REPO) -f $(GSTREAMER_DOCKERFILE) --push .

gstreamer-aws-%:
	$(eval arch=$(call param, $@))
	@docker buildx build --platform $($(arch)) -t $(CLOUD_REPO) -f $(CLOUD_DOCKERFILE) --push .
