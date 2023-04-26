ARG base=frolvlad/alpine-glibc:latest
ARG os=linux
ARG arch=amd64

#-- Download mamba

FROM ${base} AS mamba-downloader

ARG os
ARG arch

RUN apk add --no-cache curl

RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

#-- Main image

FROM ${base}

LABEL maintainer="lumiknit <aasr4r4@gmail.com>"
LABEL version="1.0.0"

RUN apk add --no-cache \
      bzip2 \
      curl \
      git \
      gzip \
      luajit \
      mruby \
      nano \
      unzip \
      zip

COPY --from=mamba-downloader /bin/micromamba /usr/bin/micromamba

RUN mkdir -p /opt/mamba \
    && echo "$(micromamba shell hook --shell posix --prefix=/opt/mamba)" >> /etc/micromamba-init.sh \
    && echo "" >> /etc/profile \
    && echo "export MAMBA_ROOT_PREFIX=/opt/mamba" >> /etc/profile \
    && echo ". /etc/micromamba-init.sh" >> /etc/profile

CMD ["/bin/ash", "-l"]