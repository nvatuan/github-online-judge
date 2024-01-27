package main

import (
	"fmt"
	"os"
)

func main() {
	var n int
	_, err := fmt.Scan(&n)

	if err != nil {
		os.Exit(1)
	}

	for i := 0; i < n; i++ {
		fmt.Println("Hello, SRE!")
	}
}
