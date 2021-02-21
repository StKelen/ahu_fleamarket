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
	Nickname string `json:"nickname"`
	Avatar   string `json:"avatar"`
	Name     string `json:"building_name"`
}

type FullUser struct {
	ID           uint   `gorm:"column:user_id" json:"id"`
	Sex          string `json:"sex"`
	Nickname     string `json:"nickname"`
	Building     string `gorm:"column:name" json:"building"`
	Avatar       string `json:"avatar"`
	PublishCount int    `json:"publish_count"`
	BoughtCount  int    `json:"bought_count"`
	StarCount    int    `json:"star_count"`
}

func CheckUserRegistered(sid string) (error, bool, uint) {
	var user User
	result := db.Where("student_id = ?", sid).First(&user)
	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, false, 0
		} else {
			return result.Error, false, 0
		}
	}
	return nil, true, user.ID
}

func UpdateUserToken(uid uint, sid string, name string) (error, string, *User) {
	token, err := jwt.GenerateToken(uid, sid, name)
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

func Register(sid string, token string, name string, nickname string, avatar string, sex string, mobile string, bid uint) (User, error) {
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
	err := db.Create(&user).Error
	return user, err
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
						WHERE user_id = ? AND user.building_id =building.building_id;`, uid).Scan(&user).Error
	return err, user
}

func GetUserBySidFull(uid uint) (error, FullUser) {
	var user FullUser
	sql := `SELECT user.user_id, user.sex, user.nickname, building.name, user.avatar, COUNT(detail.detail_id)     AS 'publish_count', COUNT(exchange.exchange_id) AS 'bought_count', COUNT(star.star_id)         AS 'star_count'
			FROM building, user
			         LEFT JOIN detail ON user.user_id = detail.user_id AND detail.is_deleted = false
			         LEFT JOIN exchange ON user.user_id = exchange.buyer_id AND exchange.is_buyer_deleted = false AND exchange.status < ?
			         LEFT JOIN star ON user.user_id = star.user_id
			WHERE user.user_id = ? AND user.building_id = building.building_id;`
	err := db.Raw(sql, Cancelled, uid).Scan(&user).Error
	return err, user
}

func GetAvatarPathByUid(uid int) (User, error) {
	var user User
	err := db.First(&user, uid).Error
	return user, err
}
