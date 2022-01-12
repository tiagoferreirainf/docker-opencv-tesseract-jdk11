FROM ubuntu:18.04
#Cant use 20.04 because of tzdata issue

RUN export DEBIAN_FRONTEND noninteractive && export TZ=Europe/London

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
build-essential \
        cmake \
        make \
        gcc \
        git \
        wget \
        libglib2.0-0 \
        libgtk2.0-dev \
        libsm6 \
        libxext6 \
        libfontconfig1 \
        libxrender1 \
        libeigen3-dev \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        pkg-config \
        libavformat-dev \
        libswscale-dev \
        libavcodec-dev \
        libavformat-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libtesseract-dev \
        tesseract-ocr-eng \
        libzbar-dev \
        qt5-default \
        coreutils \
        openjdk-11-jdk \
        maven \
        ant \
        && \
    apt-get clean

# Download opencv 4.5.5
RUN wget -q -O /tmp/opencv.tar.gz https://codeload.github.com/opencv/opencv/tar.gz/4.5.5 && \
    cd /tmp/ && tar -xf /tmp/opencv.tar.gz

# Download contrib packages
RUN wget -q -O /tmp/opencv_contrib.tar.gz https://codeload.github.com/opencv/opencv_contrib/tar.gz/4.5.5 && \
    cd /tmp/ && tar -xf /tmp/opencv_contrib.tar.gz

RUN mkdir -p /tmp/build 

# Export java_home so that it builds opencv jars
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$PATH:/usr/lib/jvm/java-11-openjdk-amd64/bin

RUN export JAVA_HOME && \
    export PATH

RUN cd /tmp/build && cmake -DBUILD_TESTS=OFF -DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-4.5.5/modules /tmp/opencv-4.5.5

RUN cd /tmp/build && make -j4 && make install

RUN rm -rf /tmp/build && rm -rf /tmp/opencv*

RUN mvn install:install-file -Dfile=/usr/local/share/java/opencv4/opencv-455.jar -DgroupId=tf.libs -DartifactId=opencv -Dversion=4.5.5 -Dpackaging=jar

CMD tail -f /dev/null
