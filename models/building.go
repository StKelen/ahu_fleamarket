package models

type Building struct {
	Bid  int    `gorm:"primaryKey;not null;autoIncrement;unique;column:building_id" json:"bid"`
	Name string `gorm:"not null" json:"name"`
}

func GetBuildingList() (error, *[]Building) {
	var buildings []Building
	err := db.Select("building_id", "name").Find(&buildings).Error
	if err != nil {
		return err, nil
	}
	return nil, &buildings
}
