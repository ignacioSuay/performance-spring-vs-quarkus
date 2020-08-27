# performance-spring-vs-quarkus
A Spring vs Quarkus performance comparison

The idea of this project is to build a simple API using Spring and Quarkus and compare their performance.

#Infrastructure
This project uses terraform for creating and deploying resources to AWS. 
Both applications will be using exactly the same infrastructure:
- 1 Application Load Balancer (ALB)
- 1 AWS ECS cluster
- 2 tasks running in each cluster 
- A mysql 8.0.17 engine managed by AWS RDS

For more information, please check the terraform folder which contains all the modules and resources used. 

#Performance tests



#Spring-ecs

1. Build the docker image with the following command:
 mvn spring-boot:build-image 

2. Tag and push the image to your aws repository:
<check your push commands in AWS ECR>
