package md5

import (
	"ahu_fleamarket/conf"
	"bytes"
	"crypto/md5"
	"encoding/hex"
	"io"
	"mime/multipart"
)

func EncodeMD5(file multipart.File) (error, string) {
	m := md5.New()
	var copyFile bytes.Buffer
	_, err := io.Copy(&copyFile, file)
	if err != nil {
		return err, ""
	}
	m.Write(copyFile.Bytes())
	salt := []byte(conf.Setting.App.JwtSecret)
	m.Write(salt)
	fileName := hex.EncodeToString(m.Sum(nil))
	return nil, fileName
}
