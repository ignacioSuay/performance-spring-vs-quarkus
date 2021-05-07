package main

import (
	"github.com/gin-gonic/gin"
	"github.com/ignacioSuay/go-ecs/controllers"
	"github.com/ignacioSuay/go-ecs/models"
)

func main() {
	r := gin.Default()

	// Connect to database
	models.ConnectDatabase()

	// Routes
	r.GET("/products", controllers.FindProducts)
	r.GET("/products/:id", controllers.FindProduct)
	r.POST("/products", controllers.CreateProduct)

	r.GET("/health", controllers.Health)

	// Run the server
	r.Run()
}
