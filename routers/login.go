package routers

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/response"
	"ahu_fleamarket/lib/userInfoCrawler"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

func Login(c *gin.Context) {
	var loginData models.LoginData
	err := c.ShouldBindJSON(&loginData)
	if err != nil {
		logging.Logger.Errorf("Failed to bind login data: %s", err)
		logging.Logger.Debugf("Login data: %s", loginData)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData))
		return
	}
	err, userInfo := userInfoCrawler.Login(loginData.Uid, loginData.Password)
	if err != nil {
		logging.Logger.Errorf("Failed to login: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetLoginInfo))
		return
	}
	logging.Logger.Infof("Uid: %s, name: %s login.", userInfo.IdNumber, userInfo.UserName)
}
