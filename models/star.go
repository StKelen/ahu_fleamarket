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
