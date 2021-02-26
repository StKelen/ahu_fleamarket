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

type ProfileList struct {
	ID         uint    `gorm:"column:detail_id" json:"detail_id"`
	Title      string  `json:"title"`
	Price      float64 `json:"price"`
	Avatar     string  `json:"avatar"`
	Nickname   string  `json:"nickname"`
	Eid        uint    `gorm:"column:exchange_id" json:"exchange_id"`
	Status     int     `json:"status"`
	TargetId   int     `json:"target_id"`
	Cover      string  `gorm:"column:path" json:"cover"`
	HasComment bool    `gorm:"column:has_comment" json:"has_comment"`
}

func GetListByPage(page int, search string, cid int, bid int, uid int, order string, orderBy string, hasMinPrice bool, minPrice float64, hasMaxPrice bool, maxPrice float64) (error, []List) {
	var data []List
	sql := `SELECT detail.detail_id, detail.title, detail.price, user.avatar, user.nickname, building.name, image.path
			FROM detail, user, building, image
			WHERE detail.detail_id NOT IN (SELECT exchange.detail_id FROM exchange WHERE exchange.status < 7)
			  AND detail.user_id = user.user_id
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
	if uid != 0 {
		sql += " AND detail.user_id = " + fmt.Sprintf("%d", uid)
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

func GetPublishList(uid uint, page int) (error, []ProfileList) {
	var data []ProfileList
	sql := `SELECT detail.detail_id, detail.title, detail.price, user.avatar, user.nickname, image.path, exchange.exchange_id, exchange.status, exchange.buyer_id AS target_id,exchange.seller_comment IS NOT NULL AS has_comment
			FROM detail
			         LEFT JOIN exchange ON detail.detail_id = exchange.detail_id AND exchange.status < ?
			         LEFT JOIN user ON exchange.buyer_id = user.user_id
			         LEFT JOIN image ON detail.detail_id = image.detail_id
			WHERE detail.user_id = ?
			  AND detail.is_deleted = false
			  AND detail.detail_id NOT IN (SELECT detail.detail_id
                               FROM exchange, detail
                               WHERE exchange.detail_id = detail.detail_id AND exchange.is_seller_deleted = true)
			GROUP BY detail.detail_id ORDER BY detail.detail_id DESC
			LIMIT 10 OFFSET ?;`
	err := db.Raw(sql, Cancelled, uid, (page-1)*10).Scan(&data).Error
	return err, data
}

func GetBoughtList(uid uint, page int) (error, []ProfileList) {
	var data []ProfileList
	sql := `SELECT detail.detail_id, detail.title, detail.price, user.avatar, user.nickname, image.path, exchange.exchange_id, exchange.status, detail.user_id AS target_id, exchange.buyer_comment IS NOT NULL AS has_comment
			FROM exchange, user, detail
			         LEFT JOIN image ON detail.detail_id = image.detail_id
			WHERE exchange.buyer_id = ?
			  AND exchange.detail_id = detail.detail_id
			  AND detail.user_id = user.user_id
			  AND exchange.is_buyer_deleted = false
			  AND detail.is_deleted = false
			GROUP BY exchange.exchange_id ORDER BY exchange.exchange_id DESC
			LIMIT 10 OFFSET ?;`
	err := db.Raw(sql, uid, (page-1)*10).Scan(&data).Error
	return err, data
}
