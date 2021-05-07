package controllers

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/ignacioSuay/go-ecs/models"
)

type ProductInput struct {
	Id   string `json:"id" binding:"required"`
	Name string `json:"name" binding:"required"`
}

func FindProducts(c *gin.Context) {
	var products []models.Product

	models.DB.Order("created_at desc").Limit(20).Find(&products)

	c.JSON(http.StatusOK, products)
}

func FindProduct(c *gin.Context) {
	var product models.Product

	if err := models.DB.Where("id = ?", c.Param("id")).First(&product).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}
	c.JSON(http.StatusOK, product)
}

func CreateProduct(c *gin.Context) {
	var input ProductInput

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	product := models.Product{Id: input.Id, Name: input.Name, CreatedAt: time.Now()}

	models.DB.Create(&product)
	c.JSON(http.StatusOK, product)
}

func Health(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"status": "OK"})
}
