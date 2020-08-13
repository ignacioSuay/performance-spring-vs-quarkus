package com.ignaciosuay;

import com.ignaciosuay.controller.dto.ProductDto;
import com.ignaciosuay.model.Product;
import com.ignaciosuay.repository.ProductRepository;
import io.quarkus.test.common.QuarkusTestResource;
import io.quarkus.test.h2.H2DatabaseTestResource;
import io.quarkus.test.junit.QuarkusTest;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.inject.Inject;
import javax.transaction.Transactional;
import java.util.UUID;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.hasItem;
import static org.hamcrest.Matchers.*;

@QuarkusTest
@QuarkusTestResource(H2DatabaseTestResource.class)
public class ProductControllerTest {

    @Inject
    ProductRepository productRepository;

    Product product;

    @BeforeEach
    @Transactional
    void setUp() {
        this.product = saveNewProduct();
    }

    @Test
    public void testGetLatestProducts() {
        given()
                .when()
                .get("/products")
                .then()
                .statusCode(200)
                .body("$", hasItem(anyOf(
                        hasEntry("id.toString()", product.getId().toString()),
                        hasEntry("name", product.getName()))));
    }

    @Test
    public void testGetProduct() {
        given()
                .when()
                .get("/products/" + product.getId())
                .then()
                .statusCode(200)
                .body("id.toString()", is(product.getId().toString()),
                        "name", is(product.getName()));
    }

    @Test
    public void postNewProduct() {
        ProductDto productDto = new ProductDto(UUID.randomUUID().toString(), "new product");

        given().contentType("application/json")
                .when()
                .body(productDto)
                .post("/products")
                .then()
                .statusCode(200)
                .body("id.toString()", is(productDto.getId()),
                        "name", is(productDto.getName()));
    }


    private Product saveNewProduct() {
        Product product = new Product(UUID.randomUUID(), "new product");
        productRepository.persist(product);
        return product;
    }

}