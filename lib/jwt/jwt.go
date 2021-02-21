package jwt

import (
	"ahu_fleamarket/conf"
	"github.com/dgrijalva/jwt-go"
	"time"
)

var jwtSecret = []byte(conf.Setting.App.JwtSecret)

type Claims struct {
	Uid  uint
	Sid  string
	Name string
	Time int64
	jwt.StandardClaims
}

func GenerateToken(uid uint, sid string, name string) (string, error) {
	claims := Claims{
		Uid:  uid,
		Sid:  sid,
		Name: name,
		Time: time.Now().UnixNano(),
		StandardClaims: jwt.StandardClaims{
			Issuer: "ahu_flea_market",
		},
	}
	tokenClaims := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	token, err := tokenClaims.SignedString(jwtSecret)
	return token, err
}

func ParseToken(token string) (*Claims, error) {
	tokenClaims, err := jwt.ParseWithClaims(token, &Claims{}, func(token *jwt.Token) (interface{}, error) {
		return jwtSecret, nil
	})
	if tokenClaims != nil {
		claims, ok := tokenClaims.Claims.(*Claims)
		if ok {
			return claims, nil
		}
	}
	return nil, err
}
