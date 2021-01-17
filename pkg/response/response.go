package response

import (
	"ahu_fleamarket/lib/code"
	"github.com/gin-gonic/gin"
)

func GetResponse(c int, data interface{}) map[string]interface{} {
	if data == nil {
		return gin.H{
			"code": c,
			"msg":  code.GetMsg(c),
		}
	} else {
		return gin.H{
			"code": c,
			"msg":  code.GetMsg(c),
			"data": data,
		}
	}
}
