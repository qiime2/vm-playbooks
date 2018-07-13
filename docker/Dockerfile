FROM continuumio/miniconda3

ARG QIIME2_RELEASE

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg
ENV XDG_CONFIG_HOME /qiime2_cache

RUN conda update -q -y conda
RUN conda install -q -y wget
RUN wget https://data.qiime2.org/distro/core/qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN conda env create -n qiime2-${QIIME2_RELEASE} --file qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN rm qiime2-${QIIME2_RELEASE}-py35-linux-conda.yml
RUN /bin/bash -c "source activate qiime2-${QIIME2_RELEASE}"
ENV PATH /opt/conda/envs/qiime2-${QIIME2_RELEASE}/bin:$PATH
RUN qiime dev refresh-cache
RUN echo "source activate qiime2-${QIIME2_RELEASE}" >> $HOME/.bashrc
RUN echo "source tab-qiime" >> $HOME/.bashrc

VOLUME ["/data"]
WORKDIR /data
