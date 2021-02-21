package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
)

func TestLogin(c *gin.Context) {
	var loginData models.LoginData
	err := c.BindJSON(&loginData)
	if err != nil {
		logging.Logger.Errorf("Failed to bind login data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
		return
	}
	err, isRegistered, uid := models.CheckUserRegistered(loginData.Sid)
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		logging.Logger.Errorf("Failed to check user is registered: %s", err)
		return
	}
	if isRegistered {
		err, token, user := models.UpdateUserToken(uid, loginData.Sid, "cxk")
		if err != nil {
			logging.Logger.Errorf("Failed to update user token: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
			return
		}
		logging.Logger.Infof("Sid: %s, name: %s login.", loginData.Sid, "cxk")
		c.Header("Token", token)
		c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
			"uid": user.ID,
		}))
		return
	}
	token, err := jwt.GenerateToken(0, loginData.Sid, "cxk")
	if err != nil {
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGenerateToken, nil))
		logging.Logger.Errorf("Failed to generate token: %s", err)
		return
	}
	c.Header("Token", token)
	c.JSON(http.StatusOK, response.GetResponse(code.UpdateUserInfo, gin.H{
		"sid":    loginData.Sid,
		"name":   "cxk",
		"mobile": "17733556623",
		"sex":    "男",
	}))
	return
}
