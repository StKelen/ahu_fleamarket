package main

import (
	"ahu_fleamarket/conf"
	"ahu_fleamarket/logging"
	"ahu_fleamarket/routers"
	"fmt"
	"net/http"
)

func main() {
	r := routers.InitRouter()
	s := &http.Server{
		Addr:    fmt.Sprintf(":%d", conf.Setting.Server.Port),
		Handler: r,
	}
	err := s.ListenAndServe()
	if err != nil {
		logging.Logger.Fatalf("Failed to start server: %s", err)
	}
}
