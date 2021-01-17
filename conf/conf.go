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
	App      App      `yaml:"app"`
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

type App struct {
	PageSize int `yaml:"page_size"`

	JwtSecret string `yaml:"jwt_secret"`

	RuntimeRootPath string `yaml:"runtime_root_path"`

	UploadImagePath string   `yaml:"upload_image_path"`
	ImageMaxSize    int64      `yaml:"image_max_size"`
	ImageAllowExts  []string `yaml:"image_allow_exts"`
}

var Setting = Conf{}

func init() {
	file, err := ioutil.ReadFile("conf/setting.yaml")
	if err != nil {
		log.Printf("Failed to read setting file: %s", err)
		return
	}
	err = yaml.Unmarshal(file, &Setting)
	if err != nil {
		log.Printf("Failed to unmarshal yaml file: %s", err)
		return
	}
}
