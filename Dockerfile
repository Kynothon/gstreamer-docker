# syntax = docker/dockerfile:experimental
ARG ALPINE_TAG=3.12

FROM alpine:${ALPINE_TAG} as buildbase

ARG GST_VERSION=1.18.1
#gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav

WORKDIR /usr/src

RUN apk add \
	build-base \
	git \
	cmake \
	meson \
	perl \
	flex \
	bison \ 
	orc-compiler \
	orc-dev \
	libxml2-dev \
	glib-dev \
	gobject-introspection-dev \
	libcap-dev \
	--

ENV PREFIX=/usr/local
RUN mkdir -p ${PREFIX}

FROM buildbase as gstreamer-base

ARG GST_MODULE=gstreamer 

# GStreamer
RUN \
	git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

ENV PKG_CONFIG_PATH=${PREFIX}/lib/pkgconfig

FROM gstreamer-base as gst-plugins-base

ARG GST_MODULE=gst-plugins-base

# GStreamer-Plugins-base
RUN apk add \
#			alsa-lib-dev \
			cdparanoia-dev \
			expat-dev \
#			gtk+3.0-dev \
			libice-dev \
			libogg-dev \
			libsm-dev \
			libtheora-dev \
			libvorbis-dev \
#			libxv-dev \
#			mesa-dev \
			opus-dev \
	&& git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

FROM gst-plugins-base as gst-plugins-good

ARG GST_MODULE=gst-plugins-good

RUN apk add \
#			cairo-dev \
			flac-dev \
#			gdk-pixbuf-dev \
#			gtk+3.0-dev \
#			jack-dev\
			lame-dev\
#			libavc1394-dev\
			libcaca-dev\
#			libdv-dev\
			libgudev-dev\
			libice-dev\
#			libiec61883-dev\
			libjpeg-turbo-dev\
			libogg-dev\
			libpng-dev\
			libshout-dev\
			libsm-dev\
			libsoup-dev\
			libvpx-dev\
			libxdamage-dev \
			libxext-dev \
			libxv-dev \
			mpg123-dev\
			taglib-dev \
#			v4l-utils-dev \
			wavpack-dev \
			zlib-dev \
#			pulseaudio-dev \
	&& git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

FROM gst-plugins-base as gst-plugins-bad

ARG GST_MODULE=gst-plugins-bad

RUN apk add \
#			alsa-lib-dev  \
#			bluez-dev \
			bzip2-dev \
			curl-dev \
#			directfb-dev \
			faac-dev \
			faad2-dev \
			flite-dev \
			glu-dev \
			gsm-dev \
			libass-dev \
			libdc1394-dev \
			libexif-dev \
			libmms-dev \
			libmodplug-dev \
			libsrtp-dev \
			libvdpau-dev \
			libwebp-dev \
			libnice-dev \
#			libx11-dev \
#			mesa-dev \
			neon-dev \
			openssl-dev \
			opus-dev \
			spandsp-dev \
			tiff-dev \
			x265-dev \
#			vulkan-loader-dev \
#			vulkan-headers \
#			wayland-dev \
#			wayland-protocols \
			libusrsctp-dev \
			lcms2-dev \
			pango-dev \
			chromaprint-dev \
			fdk-aac-dev \
			fluidsynth-dev \
			libde265-dev \
			openal-soft-dev \
			openexr-dev \
			openjpeg-dev \
#			libdvdnav-dev \
#			libdvdread-dev \
			sbc-dev \
			libsndfile-dev \
			soundtouch-dev \
#			libxkbcommon-dev \
			zbar-dev \
#			gtk+3.0-dev \
			rtmpdump-dev \
			vo-aacenc-dev \
			vo-amrwbenc-dev \
	&& git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

FROM gst-plugins-base as gst-plugins-ugly

ARG GST_MODULE=gst-plugins-ugly

RUN apk add \
			a52dec-dev \
#			libcdio-dev \
#			libdvdread-dev \
			libmpeg2-dev \
			x264-dev \
	&& git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

FROM gst-plugins-base as gst-libav

ARG GST_MODULE=gst-libav

RUN apk add \
		ffmpeg-dev \
	&& git clone -c advice.detachedHead=false --quiet --depth=1 --branch=${GST_VERSION} https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git \
	&& meson --prefix=${PREFIX} --buildtype=plain ${GST_MODULE} ${GST_MODULE}_build \
	&& meson --prefix=${PREFIX} --buildtype=plain -Dpackage-origin=https://gitlab.freedesktop.org/gstreamer/${GST_MODULE}.git ${GST_MODULE} ${GST_MODULE}_build \
	&& meson compile -C ${GST_MODULE}_build \
	&& meson install -C ${GST_MODULE}_build

FROM alpine:${ALPINE_TAG} as gstreamer

ENV PREFIX=/usr/local

RUN apk add \
#			alsa-lib \
			cdparanoia \
			expat \
#			gtk+3.0 \
			libice \
			libogg \
			libsm \
			libtheora \
			libvorbis \
#			libxv \
#			mesa \
			opus \
#			cairo \
			flac \
#			gdk-pixbuf \
#			gtk+3.0 \
#			jack\
			lame\
#			libavc1394\
			libcaca\
#			libdv\
			libgudev\
			libice\
#			libiec61883\
			libjpeg-turbo\
			libogg\
			libpng\
			libshout\
			libsm\
			libsoup\
			libvpx\
			libxdamage \
			libxext \
			libxv \
			mpg123\
			taglib \
#			v4l-utils \
			wavpack \
			zlib \
#			pulseaudio \
#			alsa-lib  \
#			bluez \
			bzip2 \
			curl \
#			directfb \
			faac \
			faad2 \
			flite \
			glu \
			gsm \
			libass \
			libdc1394 \
			libexif \
			libmms \
			libmodplug \
			libsrtp \
			libvdpau \
			libwebp \
			libnice \
#			libx11 \
#			mesa \
			neon \
			openssl \
			opus \
			spandsp \
			tiff \
			x265 \
#			vulkan-loader \
#			vulkan-headers \
#			wayland \
#			wayland-protocols \
			libusrsctp \
			lcms2 \
			pango \
			chromaprint \
			fdk-aac \
			fluidsynth \
			libde265 \
			openal-soft \
			openexr \
			openjpeg \
#			libdvdnav \
#			libdvdread \
			sbc \
			libsndfile \
			soundtouch \
#			libxkbcommon \
			zbar \
#			gtk+3.0 \
			rtmpdump \
			vo-aacenc \
			vo-amrwbenc \
			a52dec \
#			libcdio \
#			libdvdread \
			libmpeg2 \
			x264 \
			ffmpeg

COPY --from=gstreamer-base ${PREFIX}/bin/ /usr/local/bin
COPY --from=gstreamer-base ${PREFIX}/lib/ /usr//local/lib
COPY --from=gst-plugins-base ${PREFIX}/lib/ /usr/local/lib
COPY --from=gst-plugins-good ${PREFIX}/lib/ /usr/local/lib
COPY --from=gst-plugins-bad ${PREFIX}/lib/ /usr/local/lib
COPY --from=gst-plugins-ugly ${PREFIX}/lib/ /usr/local/lib
COPY --from=gst-libav ${PREFIX}/lib/ /usr/local/lib
