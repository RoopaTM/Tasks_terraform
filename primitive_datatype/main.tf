variable "string_val" {
  type = string
}

variable "number_val" {
  type = number
}

variable "boolean_val" {
  type = bool
}

variable "list_val" {
  type = list(string)
}

variable "map_val" {
  type = map(any)
}

variable "tuple_val" {
  type = tuple([string, number, bool])
}

variable "object_val" {
  type = object({
  hobbies  = list(string)
})
}


output "string_val_output" {
  value = var.string_val
}

output "number_val_output" {
  value = var.number_val
}

output "boolean_val_output" {
  value = var.boolean_val
}

output "list_val_output" {
  value = var.list_val[1]
}

output "map_val_output" {
  value = var.map_val["age"]
}

output "tuple_val_output" {
  value = var.tuple_val[1]
}

output "object_val_output" {
  value = var.object_val.hobbies
}
