package upload

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/lib/code"
	"ahu_fleamarket/lib/md5"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/pkg/file"
	"errors"
	"fmt"
	"io"
	"mime/multipart"
	"os"
	"path"
	"strings"
)

func GetImageName(file *multipart.File, fileName string) (error, string) {
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

func GetAvatarFullPathh() string{
	return conf.Setting.App.RuntimeRootPath + "/avatar"
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

func ImagesHandler(files []*multipart.FileHeader) (error, []string) {
	var result = make([]string, len(files))
	for i, fh := range files {
		if fh == nil {
			logging.Logger.Errorf("Failed to get upload image.")
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}
		if !CheckImageExt(fh.Filename) {
			logging.Logger.Errorf("Failed to check image extension: %s.", fh.Filename)
			return errors.New(code.GetMsg(code.ErrorUploadImageExtension)), nil
		}
		if !CheckImageSize(fh.Size) {
			logging.Logger.Errorf("Failed to check image size: %d.", fh.Size)
			return errors.New(code.GetMsg(code.ErrorUploadImageSize)), nil
		}

		fullPath := GetImageFullPath()
		if err := CheckImage(fullPath); err != nil {
			logging.Logger.Errorf("Failed to check upload image path: %s", err)
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}
		image, err := fh.Open()
		if err != nil {
			logging.Logger.Errorf("Failed to open FileHeader: %s", err)
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}

		err, imageName := GetImageName(&image, fh.Filename)
		if err != nil {
			logging.Logger.Errorf("Failed to open get file name: %s", err)
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}

		pathWithName := fullPath + imageName
		out, err := os.Create(pathWithName)
		if err != nil {
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}

		image, err = fh.Open()
		if err != nil {
			logging.Logger.Errorf("Failed to open FileHeader: %s", err)
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}
		_, err = io.Copy(out, image)
		if err != nil {
			logging.Logger.Errorf("Failed to save image: %s", err)
			return errors.New(code.GetMsg(code.ErrorUploadImage)), nil
		}

		result[i] = imageName
		image.Close()
		_ = out.Close()
	}
	return nil, result
}
