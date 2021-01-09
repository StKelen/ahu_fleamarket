package logging

import (
	"fmt"
	"time"
)

var (
	LogSavePath = "logs/"
	LogSaveName = "log"
	LogFileExt = "log"
	TimeFormat = "2006-01-02"
)
func getLogFilePath() string {
	return fmt.Sprintf("%s", LogSavePath)
}
func getLogFileFullPath() string {
	prefixPath := getLogFilePath()
	suffixPath := fmt.Sprintf("%s-%s.%s", LogSaveName, time.Now().Format(TimeFormat), LogFileExt)
	return fmt.Sprintf("%s%s", prefixPath, suffixPath)
}

