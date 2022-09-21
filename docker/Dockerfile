FROM continuumio/miniconda3

ARG QIIME2_RELEASE

ENV PATH=/opt/conda/envs/qiime2-${QIIME2_RELEASE}/bin:$PATH \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    MPLBACKEND=agg \
    HOME=/home/qiime2 \
    XDG_CONFIG_HOME=/home/qiime2

WORKDIR $HOME

RUN conda update  -qy conda && \
    conda install -qy wget  && \
    apt-get install -y --no-install-recommends procps && \
    wget -nv https://data.qiime2.org/distro/core/qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml && \
    conda env create -n qiime2-${QIIME2_RELEASE} --file qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml && \
    rm qiime2-${QIIME2_RELEASE}-py38-linux-conda.yml && \
    /bin/bash -c "source activate qiime2-${QIIME2_RELEASE}" && \
    qiime dev refresh-cache && \
    echo "source activate qiime2-${QIIME2_RELEASE}" >> $HOME/.bashrc && \
    echo "source tab-qiime" >> $HOME/.bashrc && \
# Important: let any UID modify these directories so that
# `docker run -u UID:GID` works
    chmod -R a+rwx /home/qiime2 && \
    chmod -R a+rwx /opt/conda

# TODO: update this to point at the new homedir defined above. Keeping this
# for now because this will require an update to the user docs.
VOLUME ["/data"]

WORKDIR /data