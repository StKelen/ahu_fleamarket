package userInfoCrawler

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/lib/DES"
	"ahu_fleamarket/models"
	"fmt"
	"github.com/zhshch2002/goreq"
	"regexp"
	"strconv"
)

var ltRegExp = regexp.MustCompile(`<input type="hidden" id="lt" name="lt" value="([^"]+)" />`)

func Login(sid string, password string) (error, *models.UserInfoData) {
	c := goreq.NewClient()
	req := goreq.Get(conf.WisdomAhuLoginUrl).AddParam("service", conf.WisdomAhuHomeBaseUrl)
	res := c.Do(req)
	if res.Err != nil {
		return fmt.Errorf("连接智慧安大错误"), nil
	}
	cookie := res.Cookies()
	body := res.Text
	lt := ltRegExp.FindStringSubmatch(body)[1]
	result := DES.StrEnc(sid+password+lt, "1", "2", "3")
	jSessionId := ""
	for _, c := range cookie {
		if c.Name == "JSESSIONID" {
			jSessionId = c.Value
		}
	}
	form := map[string]string{
		"rsa":       result,
		"ul":        strconv.Itoa(len(sid)),
		"pl":        strconv.Itoa(len(password)),
		"lt":        lt,
		"execution": "e1s1",
		"_eventId":  "submit",
	}
	req = goreq.Post(conf.WisdomAhuLoginUrl + ";jsessionid=" + jSessionId)
	req.AddParam("service", conf.WisdomAhuHomeBaseUrl)
	req.SetFormBody(form)
	res = c.Do(req)
	if res.Err != nil {
		return fmt.Errorf("连接智慧安大错误"), nil
	}
	req = goreq.Post(conf.WisdomAhuUserInfoUrl)
	req.SetJsonBody(map[string]string{
		"BE_OPT_ID": DES.StrEnc(sid, "tp", "des", "param"),
	})
	res = c.Do(req)
	if res.Err != nil {
		return fmt.Errorf("连接智慧安大错误"), nil
	}
	var userInfo models.UserInfoData
	err := res.BindJSON(&userInfo)
	if err != nil {
		return fmt.Errorf("用户名或密码错误"), nil
	}
	return nil, &userInfo
}
