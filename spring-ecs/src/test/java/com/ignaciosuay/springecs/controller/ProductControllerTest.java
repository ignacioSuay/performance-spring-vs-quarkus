package com.ignaciosuay.springecs.controller;

import com.ignaciosuay.springecs.controller.dto.ProductDto;
import com.ignaciosuay.springecs.model.Product;
import com.ignaciosuay.springecs.repository.ProductRepository;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.junit4.SpringRunner;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@RunWith(SpringRunner.class)
public class ProductControllerTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private ProductRepository productRepository;

    @Test
    public void saveNewProduct() {
        //Given
        String productId = UUID.randomUUID().toString();
        String productName = "newProduct";
        ProductDto productDto = ProductDto.builder().id(productId).name(productName).build();

        //When
        String url = "http://localhost:" + port + "/products";
        ResponseEntity<Product> result = restTemplate.postForEntity(url, productDto, Product.class);

        //Then
        assertThat(result.getBody().getId()).isEqualTo(UUID.fromString(productId));
        assertThat(result.getBody().getName()).isEqualTo(productName);

        //And
        assertThat(productRepository.findById(result.getBody().getId())).isNotEmpty();
    }

    @Test
    public void getProductById() {
        //Given
        UUID productId = UUID.randomUUID();
        String productName = "newProduct";
        Product product = Product.builder().id(productId).name(productName).build();
        productRepository.save(product);

        //When
        String url = "http://localhost:" + port + "/products/" + productId;
        ResponseEntity<Product> result = restTemplate.getForEntity(url, Product.class);

        //Then
        assertThat(result.getBody().getId()).isEqualTo(productId);
        assertThat(result.getBody().getName()).isEqualTo(productName);
    }

    @Test
    public void getAllProducts() {
        //Given
        UUID productId = UUID.randomUUID();
        String productName = "newProduct";
        Product product = Product.builder().id(productId).name(productName).build();
        productRepository.save(product);

        //When
        String url = "http://localhost:" + port + "/products/";
        ResponseEntity<Product[]> result = restTemplate.getForEntity(url, Product[].class);

        //Then
        List<Product> products = Arrays.asList(result.getBody());
        assertThat(products.size()).isEqualTo(productRepository.count());
        assertThat(products).contains(product);
    }
}