BASENAME?=gstreamer
GSTREAMER_TAG?=1.18.1
GSTREAMER_BASE?=ggoussard/gstreamer
DO?=load 

override BUILD_ARGS+=GST_VERSION=$(GSTREAMER_TAG)
REPOSITORY?=$(GSTREAMER_BASE):$(GSTREAMER_TAG)
DOCKERFILE?=Dockerfile

include utils.mk

# Main target (Dockefile)
$(BASENAME): 
	$(call buildxxx,$@)

# Sub targets (Dockerfile.*)
$(BASENAME)-%: 
	$(call buildxxx,$@)
