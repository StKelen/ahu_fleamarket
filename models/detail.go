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
	IsDeleted  bool              `gorm:"not null;default:false" json:"is_deleted"`
}

type BriefDetail struct {
	ID         uint              `gorm:"primaryKey;not null;autoIncrement;unique;column:detail_id" json:"did"`
	Eid        uint              `gorm:"not null;column:exchange_id" json:"exchange_id"`
	Title      string            `gorm:"not null" json:"title"`
	Price      float32           `gorm:"not null" json:"price"`
	BuyPrice   float32           `gorm:"not null" json:"buy_price"`
	UploadTime jsonTime.JSONTime `gorm:"not null" json:"upload_time"`
	Uid        uint              `gorm:"not null;column:user_id" json:"uid"`
	Nickname   string            `gorm:"not null" json:"nickname"`
	Avatar     string            `gorm:"not null" json:"avatar"`
	Path       string            `gorm:"not null" json:"path"`
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

func GetDetailByIdBrief(eid uint) (error, *BriefDetail) {
	var data BriefDetail
	sql := `SELECT exchange.exchange_id, detail.detail_id, detail.title, detail.price, detail.buy_price, detail.upload_time, detail.user_id, user.nickname, user.avatar, image.path
					FROM user, exchange, detail
         		LEFT JOIN image ON image.detail_id = detail.detail_id
				WHERE exchange.exchange_id = ? AND exchange.detail_id = detail.detail_id AND detail.is_deleted = false AND detail.user_id = user.user_id
				LIMIT 1;`
	err := db.Raw(sql, eid).Scan(&data).Error
	return err, &data
}

func DeleteDetail(uid uint, did uint) error {
	err := db.Model(Detail{}).Where("detail_id = ? AND user_id = ?", did, uid).Update("is_deleted", true).Error
	return err
}
