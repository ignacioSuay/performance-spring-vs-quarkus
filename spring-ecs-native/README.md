# Spring-ecs

This project is a sample spring project which will be deployed to AWS fargate. 

## Spring Native

This project has been configured to let you generate a lightweight container running a native executable.
Docker should be installed and configured on your machine prior to creating the image, see [the Getting Started section of the reference guide](https://docs.spring.io/spring-native/docs/0.9.2/reference/htmlsingle/#getting-started-buildpacks).

To create the image, run the following goal:

```
$ ./mvnw spring-boot:build-image
```

Then, you can run the app like any other container:

```
$ docker run --rm -p 8080:8080 demo:0.0.1-SNAPSHOT
```

# Local profile
To run local profile:
 
 ```
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

#Spring-ecs

1. Build the docker image with the following command:
 mvn spring-boot:build-image 

2. Tag and push the image to your aws repository:
<check your push commands in AWS ECR> 