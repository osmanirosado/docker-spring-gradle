# Containerize a Java application

Dockerfile to create a Docker image for a Spring Boot application. 

The application is packaged to an uber jar file using Gradle. 
The resulted jar file is extracted and copied into the image.

## Build

Build the Docker image
```shell
docker compose build
```

## Run

Run the application
```shell
docker compose up
```

## Test

HTTP Get request to `/greeting` route 
```shell
curl http://localhost:8080/greeting
```
```
{"id":1,"content":"Hello, World!"}
```

Customizing the greeting with an optional name parameter in the query string
```shell
curl http://localhost:8080/greeting?name=Rocio
```
```
{"id":2,"content":"Hello, Rocio!"}
```

## References

- [Building a RESTful Web Service](https://spring.io/guides/gs/rest-service)
- [Containerize a Java application - Docker Docs Guide](https://docs.docker.com/guides/language/java/containerize/)
- [Dockerfiles - Spring Boot Reference](https://docs.spring.io/spring-boot/reference/packaging/container-images/dockerfiles.html)
- [Spring Boot with Docker - Spring Boot Guide](https://spring.io/guides/gs/spring-boot-docker)
