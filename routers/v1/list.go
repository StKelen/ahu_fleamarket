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

func GetList(c *gin.Context) {
	pageStr := c.Query("page")
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse page: %s, err: %s", pageStr, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}
	search := c.Query("search")
	order := c.Query("order")
	orderBy := c.Query("by")
	var minPrice, maxPrice float64
	var cid,bid,uid int
	cidStr,hasCid := c.GetQuery("cid")
	if hasCid {
		cid, err = strconv.Atoi(cidStr)
		if err != nil {
			logging.Logger.Errorf("Failed to parse cid: %s, err: %s", cidStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
			return
		}
	}
	bidStr,hasBid := c.GetQuery("bid")
	if hasBid {
		bid, err = strconv.Atoi(bidStr)
		if err != nil {
			logging.Logger.Errorf("Failed to parse bid: %s, err: %s", bidStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
			return
		}
	}
	uidStr,hasUid := c.GetQuery("uid")
	if hasUid {
		uid, err = strconv.Atoi(uidStr)
		if err != nil {
			logging.Logger.Errorf("Failed to parse bid: %s, err: %s", uidStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
			return
		}
	}

	minPriceStr, hasMinPrice := c.GetQuery("minPrice")
	maxPriceStr, hasMaxPrice := c.GetQuery("maxPrice")
	if hasMinPrice {
		minPrice, err = strconv.ParseFloat(minPriceStr, 64)
		if err != nil {
			logging.Logger.Errorf("Failed to parse minPrice: %s, err: %s", minPriceStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
			return
		}
	}
	if hasMaxPrice {
		minPrice, err = strconv.ParseFloat(maxPriceStr, 64)
		if err != nil {
			logging.Logger.Errorf("Failed to parse maxPrice: %s, err: %s", maxPriceStr, err)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
			return
		}
	}
	err, data := models.GetListByPage(page, search, cid, bid,uid, order, orderBy, hasMinPrice, minPrice, hasMinPrice, maxPrice)
	if err != nil {
		logging.Logger.Errorf("Failed to get detail list: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetList, nil))
		return
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, data))
	return
}
