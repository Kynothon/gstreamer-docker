# gstreamer-docker


## gstreamer:1.18.1-aws

Example to run Minio and sending data after processing

```
$ docker run -d -p 9000:9000 \                                                                                                           
  -e "MINIO_ACCESS_KEY=AKIAIOSFODNN7EXAMPLE" \
  -e "MINIO_SECRET_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY" \
  minio/minio server /data

$ docker run -it --rm \
    --add-host host.docker.internal:172.17.0.1 \
    -v $PWD:/data -w /data  \
    ggoussard/gstreamer:1.18.1-aws \
    gst-launch-1.0 filesrc location=bbb_sunflower_1080p_30fps_normal.mp4 ! queue ! s3sink aws-sdk-use-http=true \
                                                                                          aws-sdk-endpoint=host.docker.internal:9000 \
                                                                                          region=us-east-1 \
                                                                                          aws-credentials='access-key-id=AKIAIOSFODNN7EXAMPLE|secret-access-key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY' \
                                                                                          aws-sdk-s3-sign-payload=false \
                                                                                          bucket=mybucket \
                                                                                          key=video.mp4
```

* Docker parameters:
    `--add-host host.docker.internal:172.17.0.1` trick to allow the `host.docker.internal` DNS name to be available on linux host.(Do not use with Docker for Mac or Windows)

* s3sink parameters:
    `aws-sdk-use-http:true`:    In the example Minio doesn't run with TLS. (Default: `false`)
    `aws-sdk-endpoint=host.docker.internal:9000`:   To access the Minio server
    `region=us-east-1`: Per Minio documentation
    `aws-credentials='access-key-id=AKIA...|secret-access-key=...EXAMPLEKEY'`: AWS Credentials if not in config file
    `aws-sdk-s3-sign-payload=false`: Set signature version to V4