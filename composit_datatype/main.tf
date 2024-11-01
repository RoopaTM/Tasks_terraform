resource "local_file" "numbertype" {
  filename = "file1.txt"
  content  = var.number_type
}

resource "local_file" "listdataType" {
  filename = "file2.txt"
  content  = var.list_datatype[0]
}

resource "local_file" "listofString" {
  filename = "file4.txt"
  content  = var.list_of_string[2]
}

resource "local_file" "listoflist" {
  filename = "file5.txt"
  content  = var.list_of_list_ofType_Num[1][2]
}


resource "local_file" "mapdataType" {
  filename = "file3.txt"
  content  = var.map_datatype.name
}

resource "local_file" "tupleType" {
  filename = "file6.txt"
  content  = var.tupleDatatype[2][0]
}

resource "local_file" "objecttype" {
  filename = "file7.txt"
  content  = var.objecttype.address[0]
}

