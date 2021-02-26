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
	"strconv"
)

type CommentData struct {
	Eid     uint   `json:"exchange_id"`
	Comment string `json:"comment"`
}

func GetCommentList(c *gin.Context) {
	uidStr := c.Query("uid")
	uid, err := strconv.Atoi(uidStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse user_id: %s", uidStr)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetComment, nil))
		return
	}

	pageStr := c.Query("page")
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse page: %s, err: %s", pageStr, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}

	err, data := models.GetCommentsByUid(uint(uid), page)
	if err != nil {
		logging.Logger.Errorf("Failed to get comments data: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetComment, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, data))
	return
}

func UploadComment(c *gin.Context) {
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

	var data CommentData
	err = c.ShouldBindJSON(&data)
	if err != nil {
		logging.Logger.Errorf("Failed to bind data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
		return
	}

	err, exchange := models.GetExchangeById(data.Eid)
	if err != nil {
		logging.Logger.Errorf("Failed to get exchange status: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}

	if exchange.SellerId == claim.Uid {
		err = models.UploadSellerComment(data.Eid, data.Comment)
	}
	if exchange.BuyerId == claim.Uid {
		err = models.UploadBuyerComment(data.Eid, data.Comment)
	}
	if err != nil {
		logging.Logger.Errorf("Failed to upload comment: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
	return
}
