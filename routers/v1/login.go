package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/lib/response"
	"ahu_fleamarket/lib/userInfoCrawler"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
)

func Login(c *gin.Context) {
	var loginData models.LoginData
	err := c.BindJSON(&loginData)
	if err != nil {
		logging.Logger.Errorf("Failed to bind login data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
		return
	}
	err, userInfo := userInfoCrawler.Login(loginData.Sid, loginData.Password)
	if err != nil {
		logging.Logger.Errorf("Failed to login: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetLoginInfo, nil))
		return
	}
	logging.Logger.Infof("Sid: %s, name: %s login Wisdom AHU.", userInfo.IdNumber, userInfo.Name)
	err, isRegistered := models.CheckUserRegistered(userInfo.IdNumber)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		logging.Logger.Errorf("Failed to check user is registered: %s", err)
		return
	}
	if isRegistered {
		err, token, user := models.UpdateUserToken(userInfo.IdNumber, userInfo.Name)
		if err != nil {
			logging.Logger.Errorf("Failed to update user token: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
			return
		}
		logging.Logger.Infof("Sid: %s, name: %s login.", userInfo.IdNumber, userInfo.Name)
		c.Header("Token", token)
		c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
			"sid":      user.Sid,
			"name":     user.Name,
			"sex":      user.Sex,
			"mobile":   user.Mobile,
			"nickname": user.Nickname,
			"building": user.Bid,
		}))
		return
	}
	token, err := jwt.GenerateToken(userInfo.IdNumber, userInfo.Name)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGenerateToken, nil))
		logging.Logger.Errorf("Failed to generate token: %s", err)
		return
	}
	c.Header("Token", token)
	c.JSON(http.StatusOK, response.GetResponse(code.UpdateUserInfo, gin.H{
		"sid":    userInfo.IdNumber,
		"name":   userInfo.Name,
		"mobile": userInfo.Mobile,
		"sex":    userInfo.Sex,
	}))
	return
}

func FirstLoginUpdate(c *gin.Context) {
	var data models.FirstLoginUpdateData
	err := c.BindJSON(&data)
	if err != nil {
		logging.Logger.Errorf("Failed to bind first_login_update data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
		return
	}
	err, registered := models.CheckUserRegistered(data.Sid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}
	if registered {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.UserExist, nil))
		return
	}
	token := c.Request.Header.Get("Token")
	if len(token) == 0 {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	claim, err := jwt.ParseToken(token)
	if err != nil {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	if claim.Sid != data.Sid {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	err = models.Register(data.Sid, token, data.Name, data.Nickname, data.Sex, data.Mobile, data.Building)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
	logging.Logger.Infof("User: %s registered.", data.Sid)
	return
}
