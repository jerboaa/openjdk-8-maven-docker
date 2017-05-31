# OpenJDK 8 Docker Image with Maven

## Build with Docker

    $ sudo docker build -t openjdk-8-64bit-maven .

## Build on OpenShift

    $ oc new-build --name openjdk-8-64bit-maven https://github.com/jerboaa/openjdk-8-maven-docker

## Run OpenShift deployment of OSIO sample apps

In order to build and run OSIO sample apps on OpenJDK 8 images as provided in this repository do the following:

    $ oc new-project openjdk8-ex
    $ oc create -f openshift-io-samples-template.json
    $ oc process openshift-io-samples SECRET=$(oc get secrets | grep builder-dockercfg | cut -d' ' -f1) | oc create -f -

