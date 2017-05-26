# OpenJDK 8 Docker Image with Maven

## Build with Docker

    $ sudo docker build -t openjdk-8-64bit-maven .

## Build on OpenShift

    $ oc new-build --name openjdk-8-64bit-maven https://github.com/jerboaa/openjdk-8-maven-docker

