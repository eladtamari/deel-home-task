variable "PROJECT_ID" {
  type    = string
  default = "deel-home-task-1"
}

variable "PROJECT_NAME" {
  type    = string
  default = "deel-home-task-1"
}

variable "REGION" {
  type    = string
  default = "us-east5"
}

variable "ZONE" {
  type    = string
  default = "us-east5-a"
}

variable "TOKEN" {
  type    = string
  default = "deel-home-task-1-8c9985d43a7f.json"
}

#CLUSTER
variable "CLUSTER_NAME" {
  type    = string
  default = "deel-cluster"
}

variable "PRIMARY_CLUSTER_CIDR_DISPLAY" {
  type    = string
  default = "net1"
}

#NODES
variable "NODE_COUNT" {
  type    = number
  default = 1
}

variable "MACHINE_TYPE" {
  type    = string
  default = "n2-standard-2"
}

variable "LABLES" {
  type    = string
  default = "dev"
}

#NETWORK

variable "VPC" {
  type    = string
  default = "deel-vpc"
}

variable "SUBNET_NAME" {
  type    = string
  default = "deel-subnet"
}

variable "SUBNET_BLOCK_PRIVATE" {
  type    = string
  default = "10.13.0.0/28"
}

variable "CLUSTER_CIDR" {
  type    = string
  default = "10.11.0.0/21"
}

variable "SERVICES_CIDR" {
  type    = string
  default = "10.12.0.0/21"
}

variable "CIDR_RANGE" {
  type    = string
  default = "10.0.0.0/24"
}

variable "ROUTER_NAME" {
  type    = string
  default = "nat-router"
}

variable "NAT" {
  type    = string
  default = "nat-config"
}

variable "FW_RULES_NAME" {
  type    = string
  default = "allow-ssh"
}

variable "PRIMARY_CLUSTER_CIDR_BLOCK" {
  type    = string
  default = "10.0.0.7/32"
}


#JUMP SERVER
variable "JUMP_SERVER_NAME" {
  type    = string
  default = "deel-jump-server"
}


variable "JUMP_MACHINE_TYPE" {
  type    = string
  default = "e2-medium"
}

variable "JUMP_MACHINE_NAME" {
  type    = string
  default = "jump-host"
}

variable "FW_SOURCE_RANGE" {
  type    = string
  default = "35.235.240.0/20"
}



















