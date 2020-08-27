# quarkus-ecs project

This project uses Quarkus, the Supersonic Subatomic Java Framework.

If you want to learn more about Quarkus, please visit its website: https://quarkus.io/ .

## Running the application in dev mode

You can run your application in dev mode that enables live coding using:
```
./mvnw quarkus:dev
```

## Packaging and running the application

The application can be packaged using `./mvnw package`.
It produces the `quarkus-ecs-1.0.0-SNAPSHOT-runner.jar` file in the `/target` directory.
Be aware that it’s not an _über-jar_ as the dependencies are copied into the `target/lib` directory.

The application is now runnable using `java -jar target/quarkus-ecs-1.0.0-SNAPSHOT-runner.jar`.

## Creating a native executable

You can create a native executable using: `./mvnw package -Pnative`.

Or, if you don't have GraalVM installed, you can run the native executable build in a container using: `./mvnw package -Pnative -Dquarkus.native.container-build=true`.

You can then execute your native executable with: `./target/quarkus-ecs-1.0.0-SNAPSHOT-runner`

If you want to learn more about building native executables, please consult https://quarkus.io/guides/building-native-image.

# Create a docker image

./mvnw clean package -Dquarkus.container-image.build=true -DskipTests

# Create a docker navtive image

./mvnw package -Pnative -Dquarkus.native.container-build=true -Dquarkus.container-image.build=true

# Export Datasource Environment variables
export QUARKUS_DATASOURCE_JDBC_URL=jdbc:mysql://localhost:3306/db
export QUARKUS_DATASOURCE_USERNAME=user
export QUARKUS_DATASOURCE_PASSWORD=password

# Docker command
docker run -p 8080:8080 -e QUARKUS_DATASOURCE_JDBC_URL="jdbc:mysql://mysql:3306/db" \
-e QUARKUS_DATASOURCE_USERNAME=user \
-e QUARKUS_DATASOURCE_PASSWORD=password \
quarkus-ecs:0.0.4-RELEASE
