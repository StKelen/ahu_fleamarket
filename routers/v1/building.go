package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"github.com/gin-gonic/gin"
	"net/http"
)

func GetBuildingData(c *gin.Context) {
	err, building := models.GetBuildingList()
	if err != nil {
		logging.Logger.Errorf("Failed to get building list: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorDataBase, nil))
		return
	}
	logging.Logger.Infof("Get building list.")
	c.JSON(http.StatusOK, response.GetResponse(code.Success, building))
	return
}
