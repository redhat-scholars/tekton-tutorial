FROM quay.io/rhdevelopers/ubi8-java-8

COPY target/greeter.jar /deployments/greeter.jar

EXPOSE 8080
USER 1001

ENTRYPOINT [ "/deployments/run-java.sh" ]
