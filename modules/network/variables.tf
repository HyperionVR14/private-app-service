variable "rg_name"     { type = string }
variable "location"    { type = string }
variable "name_prefix" { type = string }

variable "address_space"  { type = string }
variable "snet_app_cidr"  { type = string }
variable "snet_pe_cidr"   { type = string }
variable "snet_test_cidr" { type = string } # за временна VM за вътрешни тестове
