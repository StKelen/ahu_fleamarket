package upload

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/lib/md5"
	"ahu_fleamarket/pkg/file"
	"fmt"
	"mime/multipart"
	"os"
	"path"
	"strings"
)

func GetImageName(file multipart.File, fileName string) (error, string) {
	ext := path.Ext(fileName)
	err, filename := md5.EncodeMD5(file)
	return err, filename + ext
}

func GetImagePath() string {
	return conf.Setting.App.UploadImagePath
}

func GetImageFullPath() string {
	return conf.Setting.App.RuntimeRootPath + GetImagePath()
}

func CheckImageExt(fileName string) bool {
	ext := file.GetExt(fileName)
	for _, allowExt := range conf.Setting.App.ImageAllowExts {
		if strings.ToUpper(allowExt) == strings.ToUpper(ext) {
			return true
		}
	}
	return false
}

func CheckImageSize(size int64) bool {
	return size/(1024*1024) <= conf.Setting.App.ImageMaxSize
}

func CheckImage(src string) error {
	dir, err := os.Getwd()
	if err != nil {
		return fmt.Errorf("os.Getwd err: %v", err)
	}
	err = file.IsNotExistMkDir(dir + "/" + src)
	if err != nil {
		return fmt.Errorf("file.IsNotExistMkDir err: %v", err)
	}
	perm := file.CheckPermission(src)
	if perm == true {
		return fmt.Errorf("file.CheckPermission Permission denied src: %s", src)
	}
	return nil
}
