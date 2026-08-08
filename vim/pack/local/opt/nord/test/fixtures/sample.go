package main

func render(value string) int {
	return len(value) + 16
}

func main() {
	render("nord")
}
