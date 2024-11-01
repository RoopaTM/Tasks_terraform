variable "number_type" {
  default = 6
  type    = number
}

#list datatype  whuch is of list(any)
variable "list_datatype" {
  type    = list(any)
  default = ["hey", true, 123]
}


#list Datatype which is of list(string)
variable "list_of_string" {
  type    = list(string)
  default = ["213", "okay", "test1"]
}

#list Datatype which is of list of list(number)
variable "list_of_list_ofType_Num" {
  type    = list(list(number))
  default = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
}


# map data type which is of map(string)
#map datatype
variable "map_datatype" {
  type = map(string)
  default = {
    name = "roopa"
    id   = "123"
    num  = "12345678"
  }
}

# tuple dataType
variable "tupleDatatype" {
  type    = tuple([string, number, list(any)])
  default = ["sample", 123, ["rtm", 2]]
}


# object dataType

variable "objecttype" {
  type = object({
    id      = number
    name    = string
    address = list(string)
  })

  default = {
    id      = 1
    name    = "rooa"
    address = ["vijaynagar", "bangalore"]
  }
}

