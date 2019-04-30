package main
// Go http server (I) 源码阅读: https://www.jianshu.com/p/8bf9a78635ba
/**
git remote set-url origin git://new.url.here
git push -f origin master
 */
import (
	"fmt"
	"github.com/leeeboo/wechat/wx"
	"log"
	"net/http"
	"time"
)

const (
	logLevel = "dev"
	port     = 80
	token    = "bargamevzqbgoqmlq0txwifywrazaaa"
)

func get(w http.ResponseWriter, r *http.Request) {

	client, err := wx.NewClient(r, w, token)

	if err != nil {
		log.Println(err)
		w.WriteHeader(403)
		return
	}

	if len(client.Query.Echostr) > 0 {
		w.Write([]byte(client.Query.Echostr))
		return
	}

	w.WriteHeader(403)
	return
}

func post(w http.ResponseWriter, r *http.Request) {

	client, err := wx.NewClient(r, w, token)

	if err != nil {
		log.Println(err)
		w.WriteHeader(403)
		return
	}
	client.Run()
	return
}

func main() {
	server := http.Server{
		Addr:           fmt.Sprintf(":%d", port),
		Handler:        &httpHandler{},
		ReadTimeout:    5 * time.Second,
		WriteTimeout:   5 * time.Second,
		MaxHeaderBytes: 0,
	}

	//http.HandleFunc();
	log.Println(fmt.Sprintf("Listen: %d", port))
	log.Fatal(server.ListenAndServe())
}
