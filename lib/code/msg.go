package code

var MsgFlags = map[int]string{
	Success:           "ok",
	ErrorBindData:     "请求数据错误",
	ErrorGetLoginInfo: "智慧安大系统故障",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}
	return MsgFlags[Error]
}
