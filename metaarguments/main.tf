resource "local_file" "res1" {

  filename = "abc"
  content  = "this is res 1"
}
resource "local_file" "res2" {
  filename = local_file.res1.id
  content  = "this is res 2"
  lifecycle {
    create_before_destroy = true
  }
}

resource "local_file" "res3" {
  filename   = "abc"
  content    = "this is res 1"
  depends_on = [local_file.res4, local_file.res5]
  lifecycle {
    create_before_destroy = true
  }
}
resource "local_file" "res5" {
  filename = "txt"
  content  = "this is res 5"
}
resource "local_file" "res4" {
  filename = local_file.res2.id
  content  = "this is res 2"
  lifecycle {
    prevent_destroy = true
  }
}
