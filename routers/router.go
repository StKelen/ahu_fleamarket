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
		api.POST("/test/login", v1.TestLogin)
		api.POST("/first-login-update", v1.FirstLoginUpdate)
		api.GET("/building", v1.GetBuildingData)
		api.GET("/category", v1.GetCategory)

		api.GET("/detail", v1.GetDetail)
		api.POST("/detail", v1.PublishDetail)
		api.DELETE("/detail",v1.DeleteDetail)

		api.GET("/user", v1.GetUser)
		api.GET("/profile", v1.GetProfile)
		api.GET("/list", v1.GetList)

		api.GET("/avatar", v1.GetAvatar)

		api.GET("/star", v1.GetStaredInfo)
		api.PUT("/star", v1.UpdateStarInfo)

		api.GET("/exchange", v1.GetExchangeList)
		api.POST("/exchange", v1.HandleExchange)
		api.DELETE("/exchange", v1.DeleteExchange)

		brief := api.Group("/brief")
		{
			brief.GET("/user", v1.GetUserBrief)
			brief.GET("/detail", v1.GetDetailBrief)
		}
	}
	return r
}
