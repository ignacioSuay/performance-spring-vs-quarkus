package models

import "time"

type Product struct {
	Id        string    `json:"id" gorm:"primary_key"`
	Name      string    `json:"name"`
	CreatedAt time.Time `json:"createdAt"`
}
