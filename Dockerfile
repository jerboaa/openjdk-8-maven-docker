# This image provides an OpenJDK 8 environment with maven
FROM centos/s2i-base-centos7

EXPOSE 8080

ENV JAVA_TOOL_OPTIONS="" \
    PATH=$HOME/.local/bin/:$PATH \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH.
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

ADD contrib /opt/app-root

ADD container-scripts /usr/share/container-scripts

# Get prefix path and path to scripts rather than hard-code them in scripts
ENV CONTAINER_SCRIPTS_PATH=/usr/share/container-scripts/openjdk-8-maven \
    ENABLED_COLLECTIONS=rh-maven33

# When bash is started non-interactively, to run a shell script, for example it
# looks for this variable and source the content of this file. This will enable
# the SCL for all scripts without need to do 'scl enable'.
ENV BASH_ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    ENV=${CONTAINER_SCRIPTS_PATH}/scl_enable \
    PROMPT_COMMAND=". ${CONTAINER_SCRIPTS_PATH}/scl_enable"

# In order to drop the root user, we have to make some directories world
# writable as OpenShift default security model is to run the container under
# random UID.
RUN chown -R 1001:0 /opt/app-root && chmod -R og+rwx /opt/app-root

RUN yum install -y centos-release-scl-rh && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="rh-maven33 nss_wrapper git" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus java-1.8.0-openjdk.i686 java-1.8.0-openjdk-devel.i686 && \
    rpm -V $INSTALL_PKGS && \
    rpm -e java-1.8.0-openjdk.x86_64 --nodeps && \
    rpm -e java-1.8.0-openjdk-devel.x86_64 --nodeps && \
    rpm -e java-1.8.0-openjdk-headless.x86_64 --nodeps && \
    yum clean all -y

USER 1001

# Set the default CMD to print the usage of the language image.
CMD $STI_SCRIPTS_PATH/usage
