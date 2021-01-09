package userInfoCrawler

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/lib/DES"
	"ahu_fleamarket/models"
	"github.com/zhshch2002/goreq"
	"regexp"
	"strconv"
)

var ltRegExp = regexp.MustCompile(`<input type="hidden" id="lt" name="lt" value="([^"]+)" />`)

func Login(uid string, password string) (error, *models.UserInfoData) {
	c := goreq.NewClient()
	req := goreq.Get(conf.WisdomAhuLoginUrl).AddParam("service", conf.WisdomAhuHomeBaseUrl)
	res := c.Do(req)
	if res.Err != nil {
		return res.Err, nil
	}
	cookie := res.Cookies()
	body := res.Text
	lt := ltRegExp.FindStringSubmatch(body)[1]
	result := DES.StrEnc(uid+password+lt, "1", "2", "3")
	jSessionId := ""
	for _, c := range cookie {
		if c.Name == "JSESSIONID" {
			jSessionId = c.Value
		}
	}
	form := map[string]string{
		"rsa":       result,
		"ul":        strconv.Itoa(len(uid)),
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
		return res.Err, nil
	}
	req = goreq.Post(conf.WisdomAhuUserInfoUrl)
	req.SetJsonBody(map[string]string{
		"BE_OPT_ID": DES.StrEnc(uid, "tp", "des", "param"),
	})
	res = c.Do(req)
	var userInfo models.UserInfoData
	err := res.BindJSON(&userInfo)
	if err != nil {
		return err, nil
	}
	return nil, &userInfo
}
