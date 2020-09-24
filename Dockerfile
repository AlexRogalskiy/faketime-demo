#Build maven project
FROM maven:3.5-jdk-8 as builder
WORKDIR /usr/src/faketime-demo-standalone
COPY . .
RUN mvn package

#Build Libfake
FROM gcc as libfaketime
WORKDIR /
RUN git clone https://github.com/wolfcw/libfaketime.git \
    && cd libfaketime \
    && make install

#Run app with faked time
FROM adoptopenjdk/openjdk8:ubi-minimal-jre
RUN mkdir /opt/app
COPY --from=builder /usr/src/faketime-demo-standalone/target/*-exec.jar /opt/app/faketime-demo.jar
COPY --from=libfaketime /usr/local/lib/faketime/libfaketime.so.* /usr/local/lib/faketime/libfaketime
CMD ["/bin/bash", "-c", "LD_PRELOAD=/usr/local/lib/faketime/libfaketime FAKETIME_NO_CACHE=1 FAKETIME=\"2017-04-19 23:59:50\" java -jar /opt/app/faketime-demo.jar"]


