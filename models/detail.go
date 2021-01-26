package models

import (
	"ahu_fleamarket/lib/jsonTime"
	"time"
)

type Detail struct {
	ID         uint              `gorm:"primaryKey;not null;autoIncrement;unique;column:detail_id" json:"did"`
	Title      string            `gorm:"not null" json:"title"`
	Desc       string            `gorm:"not null" json:"desc"`
	Price      float32           `gorm:"not null" json:"price"`
	BuyPrice   float32           `gorm:"not null" json:"buy_price"`
	UploadTime jsonTime.JSONTime `gorm:"not null" json:"upload_time"`
	Cid        uint              `gorm:"not null;column:category_id" json:"cid"`
	Uid        uint              `gorm:"not null;column:user_id" json:"uid"`
}

func AddDetail(sid string, desc string, title string, price float32, buyPrice float32, cid uint) (error, *Detail) {
	err, user := GetUserBySid(sid)
	if err != nil {
		return err, nil
	}
	data := Detail{
		Desc:       desc,
		Title:      title,
		Price:      price,
		BuyPrice:   buyPrice,
		UploadTime: jsonTime.JSONTime(time.Now()),
		Cid:        cid,
		Uid:        user.ID,
	}
	err = db.Create(&data).Error
	return err, &data
}

func GetDetailById(did uint) (error, *Detail) {
	var detail Detail
	err := db.Where("detail_id = ?", did).First(&detail).Error
	return err, &detail
}
