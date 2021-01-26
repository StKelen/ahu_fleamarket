package models

type Image struct {
	ID   uint   `gorm:"primaryKey;not null;autoIncrement;unique;column:image_id"`
	Path string `gorm:"not null"`
	Did  uint   `gorm:"not null;column:detail_id"`
}

func AddImages(images []*Image) error {
	err := db.Create(images).Error
	return err
}

func GetImagesByDid(did uint) (error, *[]Image) {
	var images []Image
	err := db.Where("detail_id= ?", did).Find(&images).Error
	return err, &images
}
