package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"ahu_fleamarket/pkg/upload"
	"github.com/gin-gonic/gin"
	"net/http"
	"os"
	"path"
	"strconv"
)

func GetAvatar(c *gin.Context) {
	uidStr, hasId := c.GetQuery("id")
	if !hasId {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetAvatar, nil))
		return
	}
	uid, err := strconv.Atoi(uidStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse user id: %s", err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetAvatar, nil))
		return
	}
	user, err := models.GetAvatarPathByUid(uid)
	if err != nil {
		logging.Logger.Errorf("Failed to get user avatar by id: %d, err: %s", uid, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetAvatar, nil))
		return
	}
	imagePath := upload.GetImageFullPath() + "/" + user.Avatar
	file, err := os.Open(imagePath)
	if err != nil {
		logging.Logger.Errorf("Failed to open file: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.Error, nil))
		return
	}
	fileInfo, err := os.Lstat(imagePath)
	if err != nil {
		logging.Logger.Errorf("Failed to get file info: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.Error, nil))
		return
	}
	c.DataFromReader(http.StatusOK, fileInfo.Size(), "image/"+path.Ext(fileInfo.Name())[1:], file, nil)
	return
}
