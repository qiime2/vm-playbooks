FROM continuumio/miniconda3

ARG QIIME2_RELEASE

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg

RUN conda install python=3.5
RUN conda update -q -y conda
RUN conda install --file https://data.qiime2.org/distro/core/qiime2-${QIIME2_RELEASE}-conda-linux-64.txt
RUN qiime dev refresh-cache
RUN ["/bin/bash", "-c", "source tab-qiime"]

VOLUME ["/data"]
WORKDIR /data
