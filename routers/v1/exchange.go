package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"net/http"
	"strconv"
)

type ExchangeRequest struct {
	NewStatus int  `json:"new_status,omitempty"`
	Did       uint `json:"detail_id,omitempty"`
	Eid       uint `json:"exchange_id,omitempty"`
}

func GetExchangeList(c *gin.Context) {
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

	profileType, hasProfileType := c.GetQuery("type")
	if !hasProfileType {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetExchangeInfo, nil))
		return
	}

	pageStr := c.Query("page")
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse page: %s, err: %s", pageStr, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetExchangeInfo, nil))
		return
	}

	switch profileType {
	case "publish":
		err, data := models.GetPublishList(claim.Uid, page)
		if err != nil {
			logging.Logger.Errorf("Failed to get publish list: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetExchangeInfo, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, data))
		return
	case "bought":
		err, data := models.GetBoughtList(claim.Uid, page)
		if err != nil {
			logging.Logger.Errorf("Failed to get bought list: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetExchangeInfo, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, data))
		return
	case "star":
		err, data := models.GetStarList(claim.Uid, page)
		if err != nil {
			logging.Logger.Errorf("Failed to get star list: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetStarInfo, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, data))
		return
	default:
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetExchangeInfo, nil))
		return
	}
}

func DeleteExchange(c *gin.Context) {
	var data ExchangeRequest
	err := c.ShouldBindJSON(&data)
	if err != nil {
		logging.Logger.Errorf("Failed to parse data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
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

	err, exchange := models.GetExchangeStatus(claim.Uid, data.Did)
	if err != nil {
		logging.Logger.Errorf("Failed to get exchange status: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetExchangeInfo, nil))
		return
	}
	if exchange.SellerId == claim.Uid {
		err := models.SellerDeleteExchange(data.Eid)
		if err != nil {
			logging.Logger.Errorf("Failed to delete seller exchange: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorHandleExchangeRequest, nil))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
		return
	}

	err = models.BuyerDeleteExchange(data.Eid)
	if err != nil {
		logging.Logger.Errorf("Failed to delete buyer exchange: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorHandleExchangeRequest, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
	return
}

func HandleExchange(c *gin.Context) {
	var data ExchangeRequest
	err := c.ShouldBindJSON(&data)
	if err != nil {
		logging.Logger.Errorf("Failed to parse data: %s", err)
		body, _ := ioutil.ReadAll(c.Request.Body)
		logging.Logger.Debugf("data: %s", body)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorBindData, nil))
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

	err, exchange := models.GetExchangeStatus(claim.Uid, data.Did)
	if err != nil {
		logging.Logger.Errorf("Failed to get exchange status: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetExchangeInfo, nil))
		return
	}
	if exchange.Status != models.NoExchange && exchange.SellerId == claim.Uid {
		err, res := handleSellerExchange(claim.Uid, data.Did, data.Eid, exchange.Status, data.NewStatus)
		if err != nil {
			logging.Logger.Errorf("Failed to handle buyer exchange: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorHandleExchangeRequest, res))
			return
		}
		c.JSON(http.StatusOK, response.GetResponse(code.Success, res))
		return
	}

	err, res := handleBuyerExchange(claim.Uid, data.Did, data.Eid, exchange.Status, data.NewStatus)
	if err != nil {
		logging.Logger.Errorf("Failed to handle buyer exchange: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorHandleExchangeRequest, res))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, res))
	return
}

func handleBuyerExchange(uid uint, did uint, eid uint, currentStatus int, newStatus int) (error, gin.H) {
	switch newStatus {
	case models.BuyerStart:
		if currentStatus != models.NoExchange {
			return fmt.Errorf("can't create an existing exchange: %d", did), nil
		}
		err := models.CreateExchange(uid, did)
		return err, nil
	case models.Finished:
		if currentStatus != models.SellerConfirm {
			return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
		}
		err := models.UpdateExchangeStatus(eid, newStatus)
		return err, nil
	case models.BuyerWantCancel:
		if currentStatus < models.SellerStart {
			err := models.UpdateExchangeStatus(eid, models.Cancelled)
			return err, nil
		}
		if currentStatus <= models.SellerConfirm {
			err := models.UpdateExchangeStatus(eid, models.BuyerWantCancel)
			return err, nil
		}
		return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
	default:
		return fmt.Errorf("invalid status: %d", currentStatus), nil
	}
}

func handleSellerExchange(uid uint, did uint, eid uint, currentStatus int, newStatus int) (error, gin.H) {
	switch newStatus {
	case models.SellerStart:
		if currentStatus != models.BuyerStart {
			return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
		}
		err := models.UpdateExchangeStatus(eid, newStatus)
		return err, nil
	case models.SellerConfirm:
		if currentStatus != models.SellerStart {
			return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
		}
		err := models.UpdateExchangeStatus(eid, newStatus)
		return err, nil
	case models.Cancelled:
		if currentStatus != models.BuyerWantCancel {
			return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
		}
		err := models.UpdateExchangeStatus(eid, newStatus)
		return err, nil
	case models.SellerRefuse:
		if currentStatus != models.BuyerStart {
			return fmt.Errorf("bad status: %d, continue from: %d", newStatus, currentStatus), nil
		}
		err := models.UpdateExchangeStatus(eid, newStatus)
		return err, nil

	}
	return fmt.Errorf("bad request"), nil
}
