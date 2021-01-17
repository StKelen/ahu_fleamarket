package models

type Detail struct {
	Did      uint    `gorm:"primaryKey;not null;autoIncrement;unique;column:detail_id" json:"cid"`
	Desc     string  `gorm:"not null"`
	Price    float32 `gorm:"not null"`
	BuyPrice float32 `gorm:"not null"`
	Cid      uint    `gorm:"not null;column:category_id"`
	Uid      uint    `gorm:"not null;column:user_id"`
}

func AddDetail(sid string, desc string, price float32, buyPrice float32, cid uint) (error, *Detail) {
	err, user := GetUserBySid(sid)
	if err != nil {
		return err, nil
	}
	data := Detail{
		Desc:     desc,
		Price:    price,
		BuyPrice: buyPrice,
		Cid:      cid,
		Uid:      user.Uid,
	}
	err = db.Create(&data).Error
	return err, &data
}
