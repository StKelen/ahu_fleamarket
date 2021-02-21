package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetProfile(c *gin.Context) {
	token := c.Request.Header.Get("Token")
	if len(token) == 0 {
		logging.Logger.Errorf("Failed to get nil token.")
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	claim, err := jwt.ParseToken(token)
	if err != nil {
		logging.Logger.Errorf("Failed to parse token: %s", token)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	err, user := models.GetUserBySidFull(claim.Uid)
	if err != nil {
		logging.Logger.Errorf("Failed to get full user data: %s", err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetList, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, user))
	return
}
