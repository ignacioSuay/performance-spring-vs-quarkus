package com.ignaciosuay.springecs.controller;

import com.ignaciosuay.springecs.controller.dto.ProductDto;
import com.ignaciosuay.springecs.model.Product;
import com.ignaciosuay.springecs.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Slf4j
public class ProductController {

    private final ProductRepository productRepository;

    @GetMapping("/products/{id}")
    public ResponseEntity<Product> getProduct(@PathVariable UUID id) {
        log.info("Find product with id: {}", id);
        return productRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/products")
    public List<Product> getLatest() {
        log.info("Find latest 20 products");
        return productRepository.findAll(PageRequest.of(0, 20, Sort.by("instant").descending())).toList();
    }

    @PostMapping("/products")
    public Product saveProduct(@RequestBody ProductDto product) {
        log.info("Save product witn name: {}", product);
        return productRepository.save(product.toProduct());
    }
}
