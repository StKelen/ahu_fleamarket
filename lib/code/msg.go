package code

var MsgFlags = map[int]string{
	Success:                   "ok",
	ErrorBindData:             "请求数据错误",
	ErrorDataBase:             "系统错误",
	ErrorGetLoginInfo:         "智慧安大系统故障",
	ErrorGenerateToken:        "Token生成错误",
	UpdateUserInfo:            "请完善用户信息",
	UserExist:                 "用户已存在",
	ErrorUserToken:            "用户验权错误",
	ErrorUploadAvatar:         "上传头像失败",
	ErrorGetUser:              "获取用户信息失败",
	ErrorUploadImage:          "图片上传错误",
	ErrorUploadImageExtension: "图片格式错误",
	ErrorUploadImageSize:      "图片太大",
	ErrorUploadDetail:         "发表内容失败",
	ErrorGetDetail:            "获取详情信息错误",
	ErrorGetList:              "获取列表信息错误",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}
	return MsgFlags[Error]
}
