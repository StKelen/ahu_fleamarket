package code

var MsgFlags = map[int]string{
	Success:            "ok",
	ErrorBindData:      "请求数据错误",
	ErrorDataBase:      "系统错误",
	ErrorGetLoginInfo:  "智慧安大系统故障",
	ErrorGenerateToken: "Token生成错误",
	UpdateUserInfo:     "请完善用户信息",
	UserExist:          "用户已存在",
	ErrorUserToken:     "用户验权错误",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}
	return MsgFlags[Error]
}
