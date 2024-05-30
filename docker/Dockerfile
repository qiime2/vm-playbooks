FROM continuumio/miniconda3

ARG QIIME2_RELEASE
ARG DISTRIBUTION

ENV PATH /opt/conda/envs/qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}/bin:$PATH
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV MPLBACKEND agg
ENV HOME /home/qiime2
ENV XDG_CONFIG_HOME /home/qiime2

RUN mkdir /home/qiime2
WORKDIR /home/qiime2

RUN conda update -q -y conda
RUN conda install -q -y wget
RUN apt-get install -y procps
RUN wget https://raw.githubusercontent.com/qiime2/distributions/dev/${QIIME2_RELEASE}/${DISTRIBUTION}/released/qiime2-${DISTRIBUTION}-ubuntu-latest-conda.yml
RUN conda env create -n qiime2-${DISTRIBUTION}-${QIIME2_RELEASE} --file qiime2-${DISTRIBUTION}-ubuntu-latest-conda.yml \
 && conda clean -a -y \
 && chmod -R a+rwx /opt/conda
RUN rm qiime2-${DISTRIBUTION}-ubuntu-latest-conda.yml
RUN /bin/bash -c "source activate qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}"
ENV CONDA_PREFIX /home/qiime2/.conda/qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}/
RUN qiime dev refresh-cache
RUN echo "source activate qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}" >> $HOME/.bashrc
RUN echo "source tab-qiime" >> $HOME/.bashrc

# Important: let any UID modify these directories so that
# `docker run -u UID:GID` works
RUN chmod -R a+rwx /home/qiime2

# TODO: update this to point at the new homedir defined above. Keeping this
# for now because this will require an update to the user docs.
VOLUME ["/data"]
WORKDIR /data
