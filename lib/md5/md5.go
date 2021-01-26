package md5

import (
	"ahu_fleamarket/conf"
	"crypto/md5"
	"encoding/hex"
	"io/ioutil"
	"mime/multipart"
)

func EncodeMD5(file *multipart.File) (error, string) {
	m := md5.New()

	body, err := ioutil.ReadAll(*file)
	if err != nil {
		return err, ""
	}
	m.Write(body)
	salt := []byte(conf.Setting.App.JwtSecret)
	m.Write(salt)
	fileName := hex.EncodeToString(m.Sum(nil))
	return nil, fileName
}
