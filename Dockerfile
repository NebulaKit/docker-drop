# base image
FROM continuumio/miniconda3

# update and setup system
RUN apt-get update -y \
    && apt-get install -y bc less wget vim git \
    && apt-get clean 

# Copy environment file to the working directory
COPY DROP_1.4.0.yaml .

# Install mamba
RUN conda install mamba -c conda-forge

# Copy environment file to the working directory
COPY DROP_1.4.0.yaml .

RUN mamba env create -f DROP_1.4.0.yaml \
    && conda clean --all --yes

# create user
RUN useradd -d /drop -ms /bin/bash drop \
    && chmod -R ugo+rwX /drop \
    && chmod ugo+rwX /opt/conda/envs/DROP_1.4.0

# setup bash with conda and locals (language pack)
USER drop:drop
SHELL ["/bin/bash", "-c"]
RUN conda init bash \
    && echo -e "\n# activate drop environemnt\nconda activate DROP_1.4.0\n" >> ~/.bashrc \
    && echo -e "\n# read/write for group\numask 002\n" >> ~/.bashrc \
    && mkdir /drop/analysis \
    && chmod -R ugo+rwX /drop
WORKDIR /drop/analysis

CMD [ "bash" ]
