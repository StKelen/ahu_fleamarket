package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/pkg/response"
	"ahu_fleamarket/pkg/upload"
	"github.com/gin-gonic/gin"
	"net/http"
)

func UploadImage(c *gin.Context) {
	logging.Logger.Infof("/upload called.")
	form, err := c.MultipartForm()
	if err != nil {
		logging.Logger.Errorf("Failed to upload image: %s", err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadImage, nil))
		return
	}
	files := form.File["images"]
	for _, fh := range files {
		if fh == nil {
			logging.Logger.Errorf("Failed to get image with request: %s", c.Request.Body)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
		if !upload.CheckImageExt(fh.Filename) {
			logging.Logger.Errorf("Failed to check image extension: %s", fh.Filename)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadImageExtension, nil))
			return
		}
		if !upload.CheckImageSize(fh.Size) {
			logging.Logger.Errorf("Failed to check image size: %d", fh.Size)
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadImageSize, nil))
			return
		}

		fullPath := upload.GetImageFullPath()
		if err := upload.CheckImage(fullPath); err != nil {
			logging.Logger.Errorf("Failed to check upload image path: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
		file, err := fh.Open()
		if err != nil {
			logging.Logger.Errorf("Failed to open FileHeader: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
		err, imageName := upload.GetImageName(file, fh.Filename)
		if err != nil {
			logging.Logger.Errorf("Failed to open get file name: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}

		path := fullPath + imageName
		err = c.SaveUploadedFile(fh, path)
		if err != nil {
			logging.Logger.Errorf("Failed to save image: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, nil))
	return
}
