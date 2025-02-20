// testPathFile.go file

package endpoint1Pkg

import (
	"fmt"
	"net/http"
)

// SEE IF BETTER WAY THAN REDEFINING THIS AGAIN
const keyServerAddr = "serverAddr" // const string used as key

func GetEndpoint1(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Start heartlinkServer endpoint1\n\n") // Write start message to response writer "w"

	ctx := r.Context() // r.Context used to access the context of the request

	// r.URL.Query used to access the query parameters in the URL
	hasFirst := r.URL.Query().Has("first") // the Has method checks if a query parameter exists (returns Bool)
	first := r.URL.Query().Get("first")    // the Get method retrieves the value of a query parameter (returns String)
	hasSecond := r.URL.Query().Has("second")
	second := r.URL.Query().Get("second")

	// Printf writes the arguments extracted from URL to the console
	fmt.Printf("%s: got / request. first(%t)=%s, second(%t)=%s\n",
		ctx.Value(keyServerAddr),
		hasFirst, first,
		hasSecond, second)

	// Fprintf writes the arguments extracted from URL to the response writer "w"
	fmt.Fprintf(w, "%s: got / request. first(%t)=%s, second(%t)=%s\n",
		ctx.Value(keyServerAddr),
		hasFirst, first,
		hasSecond, second)

	fmt.Fprint(w, "End heartlinkServer endpoint1\n") // Write end message to response writer "w"
}
