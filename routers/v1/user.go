package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

func GetUser(c *gin.Context) {
	uidStr := c.Query("uid")
	uid, err := strconv.Atoi(uidStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse uid: %s, err: %s", uidStr, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetUser, nil))
		return
	}
	switch c.Query("type") {
	case "brief":
		err, user := models.GetUserByIdBrief(uint(uid))
		if err != nil {
			logging.Logger.Errorf("Failed to get user by id: %d, err: %s", uid, err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetUser, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, user))
		return
	default:
		logging.Logger.Errorf("Failed to get user by type: %s",c.Query("type"))
		c.JSON(http.StatusBadRequest,response.GetResponse(code.ErrorGetUser,nil))
		return
	}
}
