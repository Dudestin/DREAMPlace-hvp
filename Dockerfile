# DREAMPlace Dockerfile for RTX 5090 (Blackwell, sm_120)
# CUDA 12.8 devel (required for sm_120 native compilation)
FROM nvidia/cuda:12.8.0-devel-ubuntu22.04
LABEL maintainer="Masaru Nishimura"

ENV DEBIAN_FRONTEND=noninteractive

# System dependencies
RUN apt-get update && apt-get install -y \
        flex \
        libcairo2-dev \
        libboost-all-dev \
        bison \
        git \
        wget \
        python3 \
        python3-pip \
        python3-dev \
        libgmp-dev \
    && rm -rf /var/lib/apt/lists/*

# CMake (3.28+)
ARG CMAKE_VERSION=3.28.3
RUN wget -q https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
    && mkdir /opt/cmake \
    && sh cmake-${CMAKE_VERSION}-linux-x86_64.sh --prefix=/opt/cmake --skip-license \
    && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake \
    && rm cmake-${CMAKE_VERSION}-linux-x86_64.sh

# PyTorch 2.5 + CUDA 12.4
RUN pip3 install --no-cache-dir \
        torch==2.5.1 \
        --index-url https://download.pytorch.org/whl/cu124

# Python dependencies for DREAMPlace
RUN pip3 install --no-cache-dir \
        pyunpack>=0.1.2 \
        patool>=1.12 \
        matplotlib>=3.0 \
        cairocffi>=0.9.0 \
        pkgconfig>=1.4.0 \
        setuptools>=39.1.0 \
        scipy>=1.10.0 \
        numpy>=1.24.0 \
        shapely>=2.0.0 \
        hdf5storage

# CUDA architecture for RTX 5090 (sm_120) + backward compat
ENV TORCH_CUDA_ARCH_LIST="8.0;8.9;12.0"
ENV CMAKE_CUDA_ARCHITECTURES="80;89;120"

WORKDIR /DREAMPlace
