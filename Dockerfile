FROM clojure:openjdk-11-tools-deps-buster

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
RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && \
    unzip ninja-linux.zip && rm ninja-linux.zip && mv ninja /usr/local/bin && chmod +x /usr/local/bin/ninja
RUN /bin/bash -ic ./shared/script/install.sh
RUN /bin/bash -ic ./native/script/build.sh
RUN /bin/bash -ic ./native/script/install.sh
WORKDIR /root
