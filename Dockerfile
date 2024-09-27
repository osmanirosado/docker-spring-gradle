# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

################################################################################

# Create a stage for building the application
FROM eclipse-temurin:17-jdk-jammy AS package

WORKDIR /builder

# Copy the gradle wrapper with executable permissions.
COPY --chmod=0755 gradle gradle

COPY build.gradle gradlew settings.gradle ./
COPY ./src src/

RUN  --mount=type=cache,target=/root/.gradle ./gradlew build --no-daemon --refresh-dependencies -x test && \
     mv build/libs/$(./gradlew properties -q -Dorg.gradle.logging.level=quiet | grep "^name: " | awk '{print $2}')-$(./gradlew properties -q -Dorg.gradle.logging.level=quiet | grep "^version: " | awk '{print $2}').jar build/libs/app.jar

################################################################################

# Create a stage for extracting the application into separate layers.
# Take advantage of Spring Boot's layer tools and Docker's caching by extracting
# the packaged application into separate layers that can be copied into the final stage.
# See Spring's docs for reference:
# https://docs.spring.io/spring-boot/docs/current/reference/html/container-images.html
FROM package AS extract

WORKDIR /builder

RUN java -Djarmode=tools -jar build/libs/app.jar extract --layers --launcher --destination build/libs/extracted

################################################################################

# Create a new stage for running the application that contains the minimal
# runtime dependencies for the application. This often uses a different base
# image from the install or build stage where the necessary files are copied
# from the install stage.
#
# The example below uses eclipse-turmin's JRE image as the foundation for running the app.
# By specifying the "17-jre-jammy" tag, it will also use whatever happens to be the
# most recent version of that tag when you build your Dockerfile.
# If reproducability is important, consider using a specific digest SHA, like
# eclipse-temurin@sha256:99cede493dfd88720b610eb8077c8688d3cca50003d76d1d539b0efc8cca72b4.
FROM eclipse-temurin:17-jre-jammy AS final

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser
USER appuser

# Copy the executable from the "package" stage.
COPY --from=extract builder/build/libs/extracted/dependencies/ ./
COPY --from=extract builder/build/libs/extracted/spring-boot-loader/ ./
COPY --from=extract builder/build/libs/extracted/snapshot-dependencies/ ./
COPY --from=extract builder/build/libs/extracted/application/ ./

EXPOSE 8080

ENTRYPOINT [ "java", "org.springframework.boot.loader.launch.JarLauncher" ]
