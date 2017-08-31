package server

import (
	"flag"
)

type Options struct {
	httpAddr   string
	httpsAddr  string
	tunnelAddr string
	userManageAddr string
	userDBPath string
	domain     string
	pass       string
	tlsCrt     string
	tlsKey     string
	logto      string
	loglevel   string
}

func parseArgs() *Options {
	httpAddr := flag.String("httpAddr", ":80", "Public address for HTTP connections, empty string to disable")
	httpsAddr := flag.String("httpsAddr", ":443", "Public address listening for HTTPS connections, emptry string to disable")
	tunnelAddr := flag.String("tunnelAddr", ":4443", "Public address listening for ngrok client")
	userManageAddr := flag.String("userManageAddr", ":4446", "manage users")
	userDBPath := flag.String("userDBPath", "/tmp/db-diskv", "manage users db path")
	domain := flag.String("domain", "ngrok.com", "Domain where the tunnels are hosted")
	pass := flag.String("pass", "xxxx", "Set password hear")
	tlsCrt := flag.String("tlsCrt", "", "Path to a TLS certificate file")
	tlsKey := flag.String("tlsKey", "", "Path to a TLS key file")
	logto := flag.String("log", "stdout", "Write log messages to this file. 'stdout' and 'none' have special meanings")
	loglevel := flag.String("log-level", "DEBUG", "The level of messages to log. One of: DEBUG, INFO, WARNING, ERROR")
	flag.Parse()

	return &Options{
		httpAddr:   *httpAddr,
		httpsAddr:  *httpsAddr,
		tunnelAddr: *tunnelAddr,
		userManageAddr: *userManageAddr,
		userDBPath: *userDBPath,
		domain:     *domain,
		pass:       *pass,
		tlsCrt:     *tlsCrt,
		tlsKey:     *tlsKey,
		logto:      *logto,
		loglevel:   *loglevel,
	}
}
