# Export Docker Experimental to use buildx plugin
export DOCKER_CLI_EXPERIMENTAL=enabled
# Silence warning if not set
export BUILDX_NO_DEFAULT_LOAD=false

# Docker Platforms
amd64:=linux/amd64
arm64:=linux/arm64
armv7:=linux/arm/v7

architectures:=amd64 arm64 armv7

# $(call list,a b c) => a,b,c
comma_:= ,
empty_:=
space_:=$(empty_) $(empty_)
list_ = $(subst $(space_),$(comma_),$(1))

# $(call arch,x-a y-b z-c) => a b c
arch_ = $(foreach prereq,$1,$($(call param, $(prereq))))

# $(call param,x..-z) => z
param = $(lastword $(subst -, ,$1))

# $(call platforms,x-a y-b z-c) => a,b,c
platforms = $(call list_,$(call arch_,$1))

# $(call is_in, a b c, b) => b
is_in=$(strip $(foreach target, $(1),$(findstring $(target),$(2))))

# $call(buildxx,rule)
define buildxxx
	$(eval args := $(subst -, ,$1))
	$(eval variant := $(word 2,$(args)))
	$(eval repository := $(if $(variant),$(REPOSITORY)-$(variant),$(REPOSITORY)))
	$(eval dockerfile := $(if $(variant),$(DOCKERFILE).$(variant),$(DOCKERFILE)))
	$(eval platform := $(call platforms, $(if $(call is_in,$(architectures),$(args)),$1,$(architectures))))
	$(eval build_args := $(foreach build_arg,$(BUILD_ARGS),--build-arg $(build_arg)))

	@echo docker buildx build --platform $(platform) -t $(repository) -f $(dockerfile) $(build_args) --$(DO) .
endef

