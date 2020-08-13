package com.ignaciosuay.controller.dto;

import com.ignaciosuay.model.Product;

import java.util.UUID;

public class ProductDto {

    private String id;
    private String name;

    public ProductDto(){}
    
    public ProductDto(String id, String name) {
        this.id = id;
        this.name = name;
    }
    
    public Product toProduct() {
        return new Product(UUID.fromString(id), name);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
