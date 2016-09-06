FROM phusion/baseimage:0.9.19
ENV GOPATH /golang
RUN apt update && \
    apt install -y golang git && \
    mkdir /golang && \
    go get github.com/tools/godep

COPY build.sh /bin/build.sh
CMD /bin/build.sh
