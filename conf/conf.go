package conf

import (
	"gopkg.in/yaml.v2"
	"io/ioutil"
	"log"
)

type Conf struct {
	RunMode  string   `yaml:"RUN_MODE"`
	Database Database `yaml:"database"`
	Server   Server   `yaml:"server"`
}

type Database struct {
	User     string `yaml:"user"`
	Password string `yaml:"password"`
	Host     string `yaml:"host"`
	Port     int    `yaml:"port"`
	Name     string `yaml:"name"`
}

type Server struct {
	Port int `yaml:"port"`
}

var Setting = Conf{}

func init() {
	file, err := ioutil.ReadFile("conf/setting.yaml")
	if err != nil {
		log.Printf("Failed to read setting file: %s", err)
		return
	}
	err = yaml.Unmarshal(file, &Setting)
	if err!= nil {
		log.Printf("Failed to unmarshal yaml file: %s", err)
		return
	}
}
