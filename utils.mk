# Export Docker Experimental to use buildx plugin
export DOCKER_CLI_EXPERIMENTAL=enabled
# Silence warning if not set
export BUILDX_NO_DEFAULT_LOAD=false

# Docker Platforms
amd64:=linux/amd64
arm64:=linux/arm64
armv7:=linux/arm/v7

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

# $call(buildxx,PLATFORMS,DOCKER_REPO,DOCKER_FILE,EXTRAS,ACTION)
# ACTION = load | push
define buildxx
	$(eval platform=$(call platforms,$1))
	@docker buildx build --platform $(platform) -t $2 -f $3 $4 --$(5) .
endef

