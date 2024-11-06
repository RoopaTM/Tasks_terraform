resource "local_file" "file1" {
  filename = var.f1
  content  = "heyy"
}

resource "local_file" "file2" {
  filename = var.f1
  content  = "bye"
}


