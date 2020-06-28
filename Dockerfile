FROM alpine:edge as base

RUN head -n 1 /etc/apk/repositories | \
	sed -e 's/main/testing/' >> /etc/apk/repositories

RUN apk add --no-cache --force-broken-world \
	    gst-libav  \
	    gst-plugins-base  \
	    gst-plugins-good  \
#	    gst-plugins-good-gtk  \
#	    gst-plugins-good-qt  \
	    gst-plugins-bad  \
	    gst-plugins-ugly  \
	    gst-rtsp-server  \
	    gst-editing-services  \
	    gstreamer \
	    gstreamermm \
	    gstreamer-vaapi \
	    gstreamer-tools \
            libcrypto1.1 \
	    libssl1.1 \
	    libcurl \
	    --
