package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	message := os.Getenv("MESSAGE")
	if len(message) == 0 {
		log.Fatalln("No message provided!")
	}

	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte(fmt.Sprintf("Hello %s!", message)))
	})

	addr := "0.0.0.0"
	addrEnv := os.Getenv("SERVER_HOST_IP")
	if len(addrEnv) == 0 {
		addr = "0.0.0.0"
	}

	port := "8000"
	portEnv := os.Getenv("SERVER_PORT")
	if len(portEnv) > 0 {
		port = portEnv
	}

	host := fmt.Sprintf("%s:%s", addr, port)

	log.Printf("server started: http://%s", host)

	err := http.ListenAndServe(host, mux)
	if err != nil {
		log.Println(err)
	}
}
