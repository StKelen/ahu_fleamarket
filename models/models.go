package models

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/logging"
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

var db *gorm.DB

func init() {
	var (
		err                          error
		dbName, user, password, host string
		port                         int
	)
	dbName = conf.Setting.Database.Name
	user = conf.Setting.Database.User
	password = conf.Setting.Database.Password
	host = conf.Setting.Database.Host
	port = conf.Setting.Database.Port
	dsn := fmt.Sprintf("%s:%s@tcp(%s:%d)/%s?charset=utf8mb4&parseTime=True&loc=Local", user, password, host, port, dbName)
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{
		NamingStrategy: schema.NamingStrategy{
			SingularTable: true,
		},
	})
	if err != nil {
		logging.Logger.Errorf("Failed to connect SQL: %s", err)
	}
}
