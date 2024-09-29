# Containerize a Java application

Dockerfile to create a Docker image for a Spring Boot application. 

The application is packaged to an uber jar file using Gradle. 
The resulted jar file is extracted and copied into the image.

## Build

Command to build the Docker image
```shell
docker compose build
```

## Run

Command to run the application
```shell
docker compose up
```

## References

- [Containerize a Java application - Docker Docs Guide](https://docs.docker.com/guides/language/java/containerize/)
- [Dockerfiles - Packaging Spring Boot Applications](https://docs.spring.io/spring-boot/reference/packaging/container-images/dockerfiles.html)
- [Spring Boot with Docker - Spring Guides](https://spring.io/guides/gs/spring-boot-docker)
