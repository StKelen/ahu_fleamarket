package models

import "fmt"

type List struct {
	Did      uint    `gorm:"column:detail_id" json:"did"`
	Title    string  `json:"title"`
	Price    float64 `json:"price"`
	Avatar   string  `json:"avatar"`
	Nickname string  `json:"nickname"`
	Building string  `gorm:"column:name" json:"building"`
	Cover    string  `gorm:"column:path" json:"cover"`
}

func GetListByPage(page int, search string, cid int, bid int, order string, orderBy string, hasMinPrice bool, minPrice float64, hasMaxPrice bool, maxPrice float64) (error, []List) {
	var data []List
	var sql = `SELECT detail.detail_id, detail.title, detail.price, user.avatar, user.nickname, building.name, image.path
			FROM detail, user, building, image
			WHERE detail.user_id = user.user_id
  			AND user.building_id = building.building_id
  			AND image.detail_id = detail.detail_id`
	if search != "" {
		sql += " AND detail.desc LIKE '%" + search + "%'"
	}
	if cid != 0 {
		sql += " AND detail.category_id = " + fmt.Sprintf("%d", cid)
	}
	if bid != 0 {
		sql += " AND user.building_id = " + fmt.Sprintf("%d", bid)
	}
	if hasMinPrice {
		sql += " AND detail.price >= " + fmt.Sprintf("%.2f", minPrice)
	}
	if hasMaxPrice {
		sql += " AND detail.price <= " + fmt.Sprintf("%.2f", maxPrice)
	}
	sql += " GROUP BY detail.detail_id ORDER BY "
	switch orderBy {
	case "price":
		sql += "detail.price"
	default:
		sql += "detail.detail_id"
	}
	if order != "asc" {
		sql += " DESC"
	}
	sql += " LIMIT 10 OFFSET ?;"
	err := db.Raw(sql, (page-1)*10).Scan(&data).Error
	return err, data
}
