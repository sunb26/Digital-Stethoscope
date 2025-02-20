// endpoint2File.go file

package endpoint2Pkg

import (
	"fmt"
	"io"
	"net/http"
)

func Endpoint2Function1(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "heartlinkServer endpoint2 (function 1)\n")
	io.WriteString(w, "Written via io.WriteString function\n")
}

func Endpoint2Function2(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "heartlinkServer endpoint2 (function 2)")
}
