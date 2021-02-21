package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
)

func GetStaredInfo(c *gin.Context) {
	didStr, hasDid := c.GetQuery("did")
	if hasDid {
		did, err := strconv.Atoi(didStr)
		if err != nil {
			logging.Logger.Errorf("Failed to parse detail_id: %s, err: %s", didStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetStarInfo, nil))
			return
		}

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
		err, isStared := models.CheckIsStaredById(uint(did), claim.Uid)
		if err != nil {
			logging.Logger.Errorf("Failed to check user is stared； %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetStarInfo, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
			"is_stared": isStared,
		}))
	}
}

func UpdateStarInfo(c *gin.Context) {
	didStr, hasDid := c.GetQuery("did")
	if !hasDid {
		logging.Logger.Errorf("Failed to get did")
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetStarInfo, nil))
		return
	}
	did, err := strconv.Atoi(didStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse detail_id: %s, err: %s", didStr, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetStarInfo, nil))
		return
	}
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
	err, isStared := models.CheckIsStaredById(uint(did), claim.Uid)
	if err != nil {
		logging.Logger.Errorf("Failed to check user is stared； %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetStarInfo, nil))
		return
	}
	if isStared {
		err := models.RemoveStar(uint(did), claim.Uid)
		if err != nil {
			logging.Logger.Errorf("Failed to check user is stared； %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetStarInfo, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
		return
	}
	err = models.CreateStarInfo(uint(did), claim.Uid)
	if err != nil {
		logging.Logger.Errorf("Failed to create star info: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetStarInfo, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
}
