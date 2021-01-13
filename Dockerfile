FROM clojure:openjdk-11-buster

WORKDIR /root/llvm
RUN apt-get update && \
    apt-get install -y maven cmake lsb-release wget gnupg2 software-properties-common freeglut3-dev libfontconfig1-dev && \
    apt-get clean all && \
    wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh && \
    rm -r ./*
ENV CC=/usr/lib/llvm-11/bin/clang
ENV CXX=/usr/lib/llvm-11/bin/clang++
WORKDIR /root/skija
ADD . .
RUN mv script/ninja /usr/local/bin
RUN /bin/bash -ic ./shared/script/install.sh
RUN /bin/bash -ic ./native/script/build.sh
RUN /bin/bash -ic ./native/script/install.sh
WORKDIR /root