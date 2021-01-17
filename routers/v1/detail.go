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

type PostDetailData struct {
	Desc     string  `json:"desc"`
	Cid      uint    `json:"cid"`
	Price    float32 `json:"price"`
	BuyPrice float32 `json:"buy_price"`
}

func PublishDetail(c *gin.Context) {
	var data PostDetailData
	err := c.BindJSON(&data)
	if err != nil {
		logging.Logger.Errorf("Failed to bind detail data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
		return
	}
	token := c.Request.Header.Get("Token")
	claims, err := jwt.ParseToken(token)
	if err != nil {
		logging.Logger.Warnf("Failed to parse user token: %s, err: %s", token, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	err, detail := models.AddDetail(claims.Sid, data.Desc, data.Price, data.BuyPrice, data.Cid)
	if err != nil {
		logging.Logger.Errorf("Failed to create detail: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadDetail, nil))
		return
	}
	logging.Logger.Infof("Success create detail with did: %d", detail.Did)
	c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
		"did": detail.Did,
	}))
	return
}
