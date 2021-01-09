package routers

import (
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()
	v1 := r.Group("/v1")
	{
		v1.POST("/login", Login)
	}
	return r
}
