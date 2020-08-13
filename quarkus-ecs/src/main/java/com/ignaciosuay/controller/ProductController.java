package com.ignaciosuay.controller;

import com.ignaciosuay.controller.dto.ProductDto;
import com.ignaciosuay.model.Product;
import com.ignaciosuay.repository.ProductRepository;
import io.quarkus.panache.common.Page;
import io.quarkus.panache.common.Sort;

import javax.inject.Inject;
import javax.transaction.Transactional;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;
import java.util.UUID;

@Path("/products")
public class ProductController {

    @Inject
    ProductRepository productRepository;

    @GET
    @Path("/{id}")
    @Produces(MediaType.APPLICATION_JSON)
    public Product getProduct(@PathParam("id") UUID id) {
        return productRepository.findById(id);
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public List<Product> getLatestProducts() {
        return productRepository.findAll(Sort.descending("instant"))
                .page(Page.ofSize(20))
                .list();
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public ProductDto saveProduct(ProductDto productDto) {
        productRepository.persist(productDto.toProduct());
        return productDto;
    }
}