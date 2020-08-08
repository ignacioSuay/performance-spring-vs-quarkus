package com.ignaciosuay.springecs.controller.dto;

import com.ignaciosuay.springecs.model.Product;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductDto {
    private String id;
    private String name;

    public Product toProduct() {
        return Product.builder()
                .id(UUID.fromString(id))
                .name(name)
                .build();
    }
}
