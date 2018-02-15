FROM continuumio/miniconda3

ARG QIIME2_RELEASE

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg

RUN conda install -q -y python=3.5 wget
RUN conda update -q -y conda
RUN wget https://data.qiime2.org/distro/core/qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN conda env update -n root --file qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN rm qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN qiime dev refresh-cache
RUN echo "source tab-qiime" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
