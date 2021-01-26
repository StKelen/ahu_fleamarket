package jsonTime

import (
	"database/sql/driver"
	"errors"
	"time"
)

var timeTemplate = `2006-01-02 15:04:05`

type JSONTime time.Time

func (t JSONTime) MarshalJSON() ([]byte, error) {
	s := time.Time(t).Format(timeTemplate)
	return []byte(s), nil
}

func (t *JSONTime) UnmarshalJSON(data []byte) error {
	tempTime, err := time.Parse(timeTemplate, string(data))
	*t = JSONTime(tempTime)
	return err
}

func (t JSONTime) Value() (driver.Value, error) {
	tempTime := time.Time(t)
	return tempTime.Format(timeTemplate), nil
}

func (t *JSONTime) Scan(v interface{}) error {
	switch vt := v.(type) {
	case time.Time:
		*t = JSONTime(vt)
	default:
		return errors.New("scan time err")
	}
	return nil
}

func (t *JSONTime) String() string {
	return time.Time(*t).Format(timeTemplate)
}
