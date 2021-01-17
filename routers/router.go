package routers

import (
	"ahu_fleamarket/pkg/upload"
	"ahu_fleamarket/routers/v1"
	"github.com/gin-gonic/gin"
	"net/http"
)

func InitRouter() *gin.Engine {
	r := gin.New()
	api := r.Group("/v1")
	{
		api.StaticFS("/image", http.Dir(upload.GetImageFullPath()))

		api.POST("/login", v1.Login)
		api.POST("/first-login-update", v1.FirstLoginUpdate)
		api.GET("/building", v1.GetBuildingData)
		api.GET("/category", v1.GetCategory)
		api.POST("/image", v1.UploadImage)
		api.POST("/detail", v1.PublishDetail)
	}
	return r
}
