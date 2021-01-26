package models

type Category struct {
	ID  uint    `gorm:"primaryKey;not null;autoIncrement;unique;column:category_id" json:"cid"`
	Icon string `gorm:"not null" json:"icon"`
	Name string `gorm:"not null" json:"name"`
}

func GetCategoryList() (error, *[]Category) {
	var categories []Category
	err := db.Select("category_id", "icon", "name").Find(&categories).Error
	if err != nil {
		return err, nil
	}
	return nil, &categories
}
