package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/response"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetCategory(c *gin.Context) {
	err, category := models.GetCategoryList()
	if err != nil {
		logging.Logger.Errorf("Failed to get building list: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}
	logging.Logger.Infof("Get category list.")
	c.JSON(http.StatusOK, response.GetResponse(code.Success, category))
	return
}
