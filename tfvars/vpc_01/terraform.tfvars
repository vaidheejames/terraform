location = {
    region = "ap-south-1"
    az1    = "ap-south-1a"
    az2    = "ap-south-1b"
    az3    = "ap-south-1c"
}

name = "my-vpc"

common_tags = {
    "author"   = "Vaidhee"
    "creation" = "Terraform"
    "type"     = "VPC"
}

network = {
    cidr = "10.0.0.0/16"
    sub_pri_1a = "10.0.1.0/24"
    sub_pri_1b = "10.0.2.0/24"
    sub_pri_1c = "10.0.3.0/24"
    sub_pri_2a = "10.0.4.0/24"
    sub_pri_2b = "10.0.5.0/24"
    sub_pri_2c = "10.0.6.0/24"
    sub_pub_1a = "10.0.7.0/24"
    sub_pub_1b = "10.0.8.0/24"
    sub_pub_1c = "10.0.9.0/24"
    sub_pub_2a = "10.0.10.0/24"
    sub_pub_2b = "10.0.11.0/24"
    sub_pub_2c = "10.0.12.0/24"
}
