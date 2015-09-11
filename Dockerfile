# Based on Ubuntu 14
FROM ubuntu:14.04
# apt-get installations
RUN apt-get update
RUN apt-get install python wget build-essential python-dev git curl libffi-dev libssl-dev --yes

# Install some python packages via pip
RUN wget https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py
RUN pip install requests[security]
RUN pip install synapseclient pandas

# Setup working directories
RUN mkdir /workflows && mkdir /workflows/gitroot
WORKDIR /workflows/gitroot

# Get repos for pcawg_tools and nebula
RUN git clone https://github.com/ucscCancer/pcawg_tools.git && \
    cd pcawg_tools && \
    git checkout 1.0.0
RUN git clone https://github.com/kellrott/nebula.git

# Set up environment variables
ENV PCAWG_DIR /workflows/gitroot/pcawg_tools
ENV NEBULA /workflows/gitroot/nebula
ENV PYTHONPATH $PYTHONPATH:$NEBULA

# Install docker into this container so that it can call other containers.
RUN curl -sSL https://get.docker.com/ | sh
#RUN service docker start
# SeqWare Whitestare Pancancer includes docker 1.6.2
#RUN wget -qO- https://get.docker.com/ | sed 's/lxc-docker/lxc-docker-1.6.2/' | sh

# Set up ubuntu user
# RUN groupadd ubuntu && \
#     useradd ubuntu -m -g ubuntu && \
#     usermod -a -G sudo,ubuntu ubuntu && \
#     passwd -d ubuntu
#
# RUN usermod -aG docker ubuntu

#USER ubuntu
#ENV HOME /home/ubuntu
#ENV USER ubuntu
#WORKDIR /home/ubuntu

#CMD ["service", "docker", "start"]
RUN mv /workflows/gitroot/pcawg_tools/images /workflows/gitroot/pcawg_tools/old_images
WORKDIR /workflows/gitroot/pcawg_tools
RUN ln -s ../nebula nebula

# TODO: Include the workflow inside this container?
# RUN apt-get install maven --yes
# RUN mkdir /workflow-src
# You can't do this: the files you want to copy/add need to be in the same directory (or child) as this Dockerfile
# COPY ../src /workflow-src/src
# COPY ../workflow /workflow-src/workflow
# COPY ../pom.xml /workflow-src/pom.xml
# WORKDIR /workflow-src
# RUN mvn clean package
