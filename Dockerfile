## {{{
ARG GAP_VERSION="4.14.0"
ARG DOCKER_BASE_IMAGE_URL="ghcr.io/gap-system/gap:${GAP_VERSION}-full"
## }}}

FROM ${DOCKER_BASE_IMAGE_URL} AS base

MAINTAINER Olexandr Konovalov <obk1@st-andrews.ac.uk>

ARG GAP_VERSION

USER root

RUN apt-get clean        && \
    apt-get update --yes && \
    apt-get install --no-install-recommends --quiet --yes python3 python3-pip

# TODO(reiniscirpons): Another hack
ENV PATH="/opt/gap/.local/bin:${PATH}"

USER gap

RUN python3 -m pip install --no-cache-dir notebook jupyterlab

# Remove previous JupyterKernel installation, copy this repository and make new install
RUN cd ${HOME}/gap-${GAP_VERSION}/pkg/ \
    && rm -rf JupyterKernel \
    && git clone https://github.com/reiniscirpons/JupyterKernel \
    && cd JupyterKernel \
    && python3 -m pip install . --user

WORKDIR ${HOME}/gap-${GAP_VERSION}/pkg/JupyterKernel/demos

ENTRYPOINT []
