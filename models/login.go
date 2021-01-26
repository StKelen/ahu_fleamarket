package models

import "mime/multipart"

type LoginData struct {
	Sid      string `json:"sid"`
	Password string `json:"password"`
}

type FirstLoginUpdateData struct {
	Sid      string                `json:"sid" form:"sid"`
	Avatar   *multipart.FileHeader `json:"avatar" form:"avatar"`
	Name     string                `json:"name" form:"name"`
	Sex      string                `json:"sex" form:"sex"`
	Mobile   string                `json:"mobile" form:"mobile"`
	Nickname string                `json:"nickname" form:"nickname"`
	Bid      uint                  `json:"bid" form:"bid"`
}

type UserInfoData struct {
	IsMain       string `json:"IS_MAIN"`
	AvatarSid    string `json:"AVATAR_S_ID"`
	UnitName     string `json:"UNIT_NAME"`
	PostName     string `json:"POST_NAME"`
	IdType       string `json:"ID_TYPE"`
	UserNamePYFL string `json:"USER_NAME_PINYIN_FL"`
	UnitUid      string `json:"UNIT_UID"`
	Nickname     string `json:"NICKNAME"`
	IdNumber     string `json:"ID_NUMBER"`
	GivenName    string `json:"GIVEN_NAME"`
	BeginTime    int    `json:"BEGIN_TIME"`
	AvatarMid    string `json:"AVATAR_M_ID"`
	CardAvatar   string `json:"CARD_AVATAR"`
	Email        string `json:"EMAIL"`
	AvatarPid    string `json:"AVATAR_P_ID"`
	OfficePlace  string `json:"OFFICE_PLACE"`
	FamilyName   string `json:"FAMILY_NAME"`
	AvatarLid    string `json:"AVATAR_L_ID"`
	UserNamePY   string `json:"USER_NAME_PINYIN"`
	UserType     string `json:"USER_TYPE"`
	NativePlace  string `json:"NATIVE_PLACE"`
	ResourceId   string `json:"RESOURCE_ID"`
	OfficePhone  string `json:"OFFICE_PHONE"`
	Sex          string `json:"USER_SEX"`
	IsActive     string `json:"IS_ACTIVE"`
	PassportImg  string `json:"PASSPORT_IMG"`
	UserAlias    string `json:"USER_ALIAS"`
	Mobile       string `json:"MOBILE"`
	Name     string `json:"USER_NAME"`
	CardAvatarS  string `json:"CARD_AVATAR_S"`
	Nation       string `json:"NATION"`
	EndTime      int `json:"END_TIME"`
}
