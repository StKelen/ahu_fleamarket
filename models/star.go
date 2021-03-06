package models

import (
	"errors"
	"gorm.io/gorm"
)

type Star struct {
	ID  uint `gorm:"primaryKey;not null;autoIncrement;unique;column:star_id"`
	Uid uint `gorm:"not null;column:user_id"`
	Did uint `gorm:"not null;column:detail_id"`
}

type StarList struct {
	Id       uint `gorm:"primaryKey;not null;autoIncrement;unique;column:star_id" json:"star_id"`
	Uid      uint `gorm:"not null;column:user_id" json:"user_id"`
	Did      uint `gorm:"not null;column:detail_id" json:"detail_id"`
	Nickname string `json:"nickname"`
	Avatar   string	`json:"avatar"`
	Title    string `json:"title"`
	Price    float32 `json:"price"`
	Image    string `gorm:"column:path" json:"cover"`
}

func CheckIsStaredById(did uint, uid uint) (error, bool) {
	result := db.Where("detail_id = ? AND user_id = ?", did, uid).First(&Star{})
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, false
		} else {
			return result.Error, false
		}
	}
	return nil, true
}

func CreateStarInfo(did uint, uid uint) error {
	var star = Star{Did: did, Uid: uid}
	err := db.Create(&star).Error
	return err

}

func RemoveStar(did uint, uid uint) error {
	err := db.Where("detail_id = ? AND user_id = ?", did, uid).Delete(&Star{}).Error
	return err
}

func GetStarList(uid uint, page int) (error, []StarList) {
	var data []StarList
	sql := `SELECT star.star_id, user.user_id, user.nickname, user.avatar, detail.detail_id, detail.title, detail.price, image.path
			FROM user, star
			         LEFT JOIN detail ON star.detail_id = detail.detail_id AND detail.is_deleted = false
			         LEFt JOIN image ON image.detail_id = detail.detail_id
			WHERE star.user_id = ?
			GROUP BY star.star_id ORDER BY star.star_id DESC
			LIMIT 10 OFFSET ?;`
	err := db.Raw(sql, uid, (page-1)*10).Scan(&data).Error
	return err, data
}
