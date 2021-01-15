package routers

import (
	"ahu_fleamarket/routers/v1"
	"github.com/gin-gonic/gin"
)

func InitRouter() *gin.Engine {
	r := gin.New()
	api := r.Group("/v1")
	{
		api.POST("/login", v1.Login)
		api.POST("/first-login-update", v1.FirstLoginUpdate)
		api.GET("/building", v1.GetBuildingData)
		api.GET("/category", v1.GetCategory)
	}
	return r
}
