package models

import (
	"ahu_fleamarket/lib/jwt"
	"errors"
	"gorm.io/gorm"
)

type User struct {
	ID       uint   `gorm:"primaryKey;not null;autoIncrement;unique;column:user_id"`
	Sid      string `gorm:"not null;unique;column:student_id"`
	Token    string
	Name     string `gorm:"not null"`
	Nickname string `gorm:"not null"`
	Avatar   string `gorm:"not null;default:default.png"`
	Sex      string `gorm:"type:enum('男','女')"`
	Mobile   string `gorm:"not null"`
	Bid      uint   `gorm:"not null;column:building_id"`
}

type BriefUser struct {
	Nickname string`json:"nickname"`
	Avatar string `json:"avatar"`
	Name string `json:"building_name"`
}

func CheckUserRegistered(sid string) (error, bool) {
	result := db.Where("student_id = ?", sid).First(&User{})
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, false
		} else {
			return result.Error, false
		}
	}
	return nil, true
}

func UpdateUserToken(sid string, name string) (error, string, *User) {
	token, err := jwt.GenerateToken(sid, name)
	user := User{}
	if err != nil {
		return err, "", nil
	}
	result := db.Model(&user).Where("student_id = ?", sid).Update("token", token).First(&user)
	if result.Error != nil {
		return result.Error, "", nil
	}
	return nil, token, &user
}

func Register(sid string, token string, name string, nickname string, avatar string, sex string, mobile string, bid uint) error {
	var user = User{
		Sid:      sid,
		Token:    token,
		Name:     name,
		Nickname: nickname,
		Avatar:   avatar,
		Sex:      sex,
		Mobile:   mobile,
		Bid:      bid,
	}
	return db.Create(&user).Error
}

func GetUserBySid(sid string) (error, User) {
	var user User
	err := db.Where("student_id = ?", sid).First(&user).Error
	return err, user
}

func GetUserByIdBrief(uid uint) (error, BriefUser) {
	var user BriefUser
	err := db.Raw(`SELECT user.nickname,user.avatar,building.name 
						FROM user,building 
						WHERE user_id = ? AND user.building_id =building.building_id;`,uid).Scan(&user).Error
	return err, user
}
