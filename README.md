# performance-spring-vs-quarkus
A Spring vs Quarkus performance comparison

The idea of this project is to build a simple API using Spring and Quarkus and compare their performance.

#Infrastructure
This project uses terraform for creating and deploying resources to AWS. 
Both applications will be using exactly the same infrastructure:
- 1 Application Load Balancer (ALB)
- 1 AWS ECS cluster
- 2 tasks running in the cluster with memory=512MiB and cpu=256. 
- A mysql 8.0.17 engine managed by AWS RDS

For more information, please check the terraform folder which contains all the modules and resources used. 

# Rest Controller

Both applications have implemented the following endpoints:
- GET /products: Returns the last 20 products
- GET /products/{id}: Returns one single product with the given Id
- POST /products: Saves a new product.

#Load tests
 
Load testing has been done with Gatling (https://gatling.io). 
The load test performs the following actions:
1) Gets all the latest products
2) Saves a new product
3) Retrieves the product saved

Each user will perform this action. 
The test ramps up 200 users during the first minute and then keeps constant 200 users during 2 hours.
