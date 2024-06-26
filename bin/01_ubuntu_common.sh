#!/bin/bash

sudo apt-get clean -y
sudo apt-get update -q -y
sudo apt-get upgrade -y
sudo apt-get install wget -y

sudo groupadd vboxsf
sudo su -c "useradd qiime2 -s /bin/bash -m -G sudo,vboxsf"
echo qiime2:qiime2 | sudo chpasswd

sudo -E su -p -l qiime2 <<'EOF'
  unset SUDO_UID SUDO_GID SUDO_USER

  export HOME=/home/qiime2
  export MINICONDA_PREFIX="$HOME/miniconda"
  export MPLBACKEND=agg

  cd $HOME
  echo "export PATH=$MINICONDA_PREFIX/bin:$PATH" >> $HOME/.bashrc
  echo "export MPLBACKEND=agg" >> $HOME/.bashrc
  echo "export LC_ALL=C.UTF-8" >> $HOME/.bashrc
  echo "export LANG=C.UTF-8" >> $HOME/.bashrc
  echo "source activate qiime2-${QIIME2_RELEASE}" >> $HOME/.bashrc
  echo "source tab-qiime" >> $HOME/.bashrc

  wget -q https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
  bash miniconda.sh -b -p $MINICONDA_PREFIX
  export PATH="$MINICONDA_PREFIX/bin:$PATH"
  conda update -q -y -n base conda
  wget https://data.qiime2.org/distro/${DISTRIBUTION}/qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}-py38-linux-conda.yml
  conda env create -n qiime2-${DISTRIBUTION}-${QIIME2_RELEASE} --file qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}-py38-linux-conda.yml
  rm qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}-py38-linux-conda.yml
  source activate qiime2-${DISTRIBUTION}-${QIIME2_RELEASE}
  qiime dev refresh-cache
EOF
