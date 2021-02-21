package models

import (
	"errors"
	"gorm.io/gorm"
)

const (
	NoExchange = iota
	BuyerStart
	SellerStart
	SellerConfirm
	Finished
	BuyerWantCancel
	Cancelled
	SellerRefuse
)

type Exchange struct {
	ID             uint   `gorm:"primaryKey;not null;autoIncrement;unique;column:exchange_id" json:"eid"`
	Did            uint   `gorm:"not null;column:detail_id"`
	BuyerId        uint   `gorm:"not null" json:"buyer_id"`
	Status         int    `gorm:"not null" json:"status"`
	IsBuyerDeleted bool   `gorm:"not null;default:false" json:"is_buyer_deleted"`
	SellerComment  string `json:"seller_comment"`
	BuyerComment   string `json:"buyer_comment"`
}

type ExchangeWithSeller struct {
	ID              uint   `gorm:"primaryKey;not null;autoIncrement;unique;column:exchange_id" json:"eid"`
	Did             uint   `gorm:"not null;column:detail_id"`
	SellerId        uint   `gorm:"not null;column:seller_id"`
	BuyerId         uint   `gorm:"not null" json:"buyer_id"`
	Status          int    `gorm:"not null" json:"status"`
	IsBuyerDeleted  bool   `gorm:"not null;default:false" json:"is_buyer_deleted"`
	IsSellerDeleted bool   `gorm:"not null;default:false" json:"is_seller_deleted"`
	SellerComment   string `json:"seller_comment"`
	BuyerComment    string `json:"buyer_comment"`
}

func GetExchangeStatus(uid uint, did uint) (error, *ExchangeWithSeller) {
	var exchange ExchangeWithSeller
	sql := `SELECT exchange.exchange_id,
			       exchange.detail_id,
			       detail.user_id AS 'seller_id',
			       exchange.buyer_id,
			       exchange.status,
			       exchange.is_buyer_deleted,
 				   exchange.is_seller_deleted,
			       exchange.buyer_comment,
			       exchange.seller_comment
			FROM exchange, detail
			WHERE exchange.detail_id = ?
			  AND detail.is_deleted = false
			  AND exchange.detail_id = detail.detail_id
			  AND ((exchange.buyer_id = ? AND exchange.is_buyer_deleted = false)
			    OR (detail.user_id = ? AND exchange.is_seller_deleted = false  AND exchange.status < ?));`
	err := db.Raw(sql, did, uid, uid, Cancelled).Scan(&exchange).Error
	if errors.Is(err, gorm.ErrRecordNotFound) {
		exchange = ExchangeWithSeller{
			Status: NoExchange,
		}
		return nil, &exchange
	}
	if err != nil {
		exchange.Status = NoExchange
		return err, nil
	}
	return nil, &exchange
}

func CreateExchange(buyerId uint, did uint) error {
	var e = Exchange{
		Did:     did,
		BuyerId: buyerId,
		Status:  BuyerStart,
	}
	err := db.Create(&e).Error
	return err
}

func UpdateExchangeStatus(eid uint, newStatus int) error {
	err := db.Model(Exchange{}).Where("exchange_id = ?", eid).Update("status", newStatus).Error
	return err
}

func SellerDeleteExchange(eid uint) error {
	err := db.Model(Exchange{}).Where("exchange_id = ?", eid).Update("is_seller_deleted", true).Error
	return err
}
func BuyerDeleteExchange(eid uint) error {
	err := db.Model(Exchange{}).Where("exchange_id = ?", eid).Update("is_buyer_deleted", true).Error
	return err
}
