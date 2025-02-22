// main.go file

package main

import (
	"context"                      // package is used to pass context between functions
	"errors"                       // package is used to handle errors
	"fmt"                          // package is used to print to console in a specific format
	"heartlinkServer/endpoint1Pkg" // import the endpoint1Pkg package from within the heartlinkServer project
	"heartlinkServer/endpoint2Pkg" // import the endpoint2Pkg package from within the heartlinkServer project
	"log"                          // "log" package is used to log errors

	// package is used to create/connect to a server
	"net/http" // "net/http" package provides HTTP client/server implementations
)

const keyServerAddr = "serverAddr" // const string used as key

func main() {

	log.Println("Begin main function") // log initial message to console

	mux := http.NewServeMux() // create custom multiplexer to handle incoming requests

	// each individual HandleFunc function is used to handle a specific endpoint (URL path)
	mux.HandleFunc("/endpoint1", endpoint1Pkg.GetEndpoint1)         // when a request is made to /endpoint1, call GetEndpoint1() function
	mux.HandleFunc("/endpoint2_1", endpoint2Pkg.Endpoint2Function1) // when a request is made to /endpoint2_1, call Endpoint2Function1() function
	mux.HandleFunc("/endpoint2_2", endpoint2Pkg.Endpoint2Function2) // when a request is made to /endpoint2_2, call Endpoint2Function2() function

	ctx := context.Background()

	server := &http.Server{
		Addr: ":8080",
		// Addr: "127.0.0.1:8080",
		Handler: mux,
		// BaseContext: func(l net.Listener) context.Context {
		// 	ctx = context.WithValue(ctx, keyServerAddr, l.Addr().String())
		// 	return ctx
		// },
		// BaseContext: ,
		// Add in a ReadTimeout, WriteTimeout, and IdleTimeout
	}

	error := server.ListenAndServe() // create and start server on localhost:8080 handling requests using "mux" multiplexer

	if errors.Is(error, http.ErrServerClosed) {
		fmt.Printf("server closed\n")
	} else if error != nil {
		fmt.Printf("error listening for server: %s\n", error)
	}

	<-ctx.Done() // wait for context to be done

	log.Println("End main function (should never make it here because kill file when running)") // log exit message to console

}
