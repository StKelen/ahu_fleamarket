package v1

import (
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/jwt"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/models"
	"ahu_fleamarket/pkg/response"
	"ahu_fleamarket/pkg/upload"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
	"strconv"
	"strings"
	"time"
	"unicode/utf8"
)

type PostDetailData struct {
	Desc     string  `json:"desc"`
	Cid      uint    `json:"cid"`
	Price    float32 `json:"price"`
	BuyPrice float32 `json:"buy_price"`
}

func PublishDetail(c *gin.Context) {
	token := c.Request.Header.Get("Token")
	claims, err := jwt.ParseToken(token)
	if err != nil {
		logging.Logger.Warnf("Failed to parse user token: %s, err: %s", token, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUserToken, nil))
		return
	}
	form, err := c.MultipartForm()
	if err != nil {
		logging.Logger.Errorf("Failed to parse form: %s", err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadDetail, nil))
		return
	}
	files := form.File["images[]"]
	desc := form.Value["desc"][0]
	price, err1 := strconv.ParseFloat(form.Value["price"][0], 32)
	buyPrice, err2 := strconv.ParseFloat(form.Value["buy_price"][0], 32)
	cid, err3 := strconv.Atoi(form.Value["cid"][0])
	if err1 != nil || err2 != nil || err3 != nil {
		logging.Logger.Errorf("Failed  parse form: %s", err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadDetail, nil))
		return
	}
	title := strings.Split(desc,"\n")[0]
	if utf8.RuneCountInString(title) > 20 {
		title = string([]rune(desc)[:20])
	}
	err, detail := models.AddDetail(claims.Sid, desc, title, float32(price), float32(buyPrice), uint(cid))
	if err != nil {
		logging.Logger.Errorf("Failed to create detail: %s", err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadDetail, nil))
		return
	}
	logging.Logger.Infof("Success create detail with did: %d", detail.ID)

	if len(files) > 0 {
		var images = make([]*models.Image, len(files))
		err, paths := upload.ImagesHandler(files)
		if err != nil {
			c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
		for i, path := range paths {
			images[i] = &models.Image{
				Path: path,
				Did:  detail.ID,
			}
		}
		err = models.AddImages(images)
		if err != nil {
			logging.Logger.Errorf("Failed to create images record: %s", err)
			c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorUploadImage, nil))
			return
		}
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
		"did": detail.ID,
	}))
	return
}

func GetDetail(c *gin.Context) {
	didStr := c.Query("did")
	if didStr == "" {
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}
	did, err := strconv.Atoi(didStr)
	if err != nil {
		logging.Logger.Errorf("Failed to parse detail_id: %s", didStr)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}

	err, detail := models.GetDetailById(uint(did))
	if err != nil {
		logging.Logger.Errorf("Failed to get detail by id: %d, err: %s", did, err)
		c.JSON(http.StatusBadRequest, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}
	err, images := models.GetImagesByDid(uint(did))
	if err != nil {
		logging.Logger.Errorf("Faileed to get detail images by did: %d,err: %s", did, err)
		c.JSON(http.StatusInternalServerError, response.GetResponse(code.ErrorGetDetail, nil))
		return
	}
	var imagesPath = make([]string, len(*images))
	for i, image := range *images {
		imagesPath[i] = image.Path
	}

	var publishTimeStr string
	publishTimeStr = "发布于x年前"
	uploadTime := time.Time(detail.UploadTime)
	if uploadTime.AddDate(1, 0, 0).Before(time.Now()) {
		publishTimeStr = fmt.Sprintf("发布于%d年前", time.Now().Year()-uploadTime.Year())
	} else if uploadTime.AddDate(0, 1, 0).Before(time.Now()) {
		publishTimeStr = fmt.Sprintf("发布于%1.0f个月前", time.Now().Sub(uploadTime).Hours()/24/30)
	} else if uploadTime.AddDate(0, 0, 1).Before(time.Now()) {
		publishTimeStr = fmt.Sprintf("发布于%1.0f天前", time.Now().Sub(uploadTime).Hours()/24)
	} else if uploadTime.Add(time.Hour).Before(time.Now()) {
		publishTimeStr = fmt.Sprintf("发布于%1.0f小时前", time.Now().Sub(uploadTime).Hours())
	} else {
		publishTimeStr = fmt.Sprintf("发布于%1.0f分钟前", time.Now().Sub(uploadTime).Minutes())
	}
	c.JSON(http.StatusOK, response.GetResponse(code.Success, gin.H{
		"did":          detail.ID,
		"desc":         detail.Desc,
		"price":        detail.Price,
		"buy_price":    detail.BuyPrice,
		"publish_date": publishTimeStr,
		"cid":          detail.Cid,
		"uid":          detail.Uid,
		"images":       imagesPath,
	}))
	return
}
