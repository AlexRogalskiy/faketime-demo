#Build maven project
FROM maven:3.5-jdk-8 as builder
WORKDIR faketime-demo
COPY . .
RUN mvn package

#Run application with libfake
FROM registry.fedoraproject.org/fedora-minimal:32
RUN mkdir /opt/app
COPY --from=builder /faketime-demo/target/*-exec.jar /opt/app/faketime-demo.jar
WORKDIR /
RUN microdnf install libfaketime \
 && microdnf install java-1.8.0-openjdk-headless --nodocs \
 && microdnf install shadow-utils && microdnf clean all \
 && mkdir /deployments
# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /etc/alternatives/jre
CMD ["/bin/bash", "-c", "faketime '1990-08-02 00:00:00' java -jar /opt/app/faketime-demo.jar"]




#How to install java on fedora here?


#FROM maven:3.5-jdk-8
#WORKDIR hello-world
#COPY . .
#RUN mvn package
#ENTRYPOINT ["java", "-jar", "/hello-world/target/hello-world-1.0-SNAPSHOT.jar"]

