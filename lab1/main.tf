resource "local_file" "foo" {
  content  = "welcome terraform"
  filename = "testing.txt"
}