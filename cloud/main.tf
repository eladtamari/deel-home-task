terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.8.0"
    }
  }
}


provider "google" {
  region      = var.REGION
  project     = "deel-home-task-1"
  credentials = file("deel-home-task-1-8c9985d43a7f.json")
  zone        = var.ZONE

}

# create VPC
resource "google_compute_network" "vpc" {
  name                    = var.VPC
  auto_create_subnetworks = false

}

# Create Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = var.SUBNET_NAME
  region        = var.REGION
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.CIDR_RANGE
}

# # Create Service Account
# resource "google_service_account" "mysa" {
#   account_id   = "mysa"
#   display_name = "Service Account for GKE nodes"
# }


# Create GKE cluster with 2 nodes in our custom VPC/Subnet
resource "google_container_cluster" "primary" {
  name                     = var.CLUSTER_NAME
  location                 = var.ZONE
  network                  = google_compute_network.vpc.name
  subnetwork               = google_compute_subnetwork.subnet.name
  remove_default_node_pool = true ## create the smallest possible default node pool and immediately delete it.
  # networking_mode          = "VPC_NATIVE" 
  initial_node_count = 1

  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.SUBNET_BLOCK_PRIVATE
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.11.0.0/21"
    services_ipv4_cidr_block = "10.12.0.0/21"

    #cluster_ipv4_cidr_block  = var.CLUSTER_CIDR
    #services_ipv4_cidr_block = var.SERVICES_CIDR
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.PRIMARY_CLUSTER_CIDR_BLOCK
      display_name = var.PRIMARY_CLUSTER_CIDR_DISPLAY
    }

  }
}

# Create managed node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = var.ZONE
  cluster    = google_container_cluster.primary.name
  node_count = var.NODE_COUNT

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.LABLES
    }

    machine_type = var.MACHINE_TYPE
    preemptible  = true
    #service_account = google_service_account.mysa.email

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}



## Create jump host . We will allow this jump host to access GKE cluster. the ip of this jump host is already authorized to allowin the GKE cluster

resource "google_compute_address" "my_internal_ip_addr" {
  project      = var.PROJECT_NAME
  address_type = "INTERNAL"
  region       = var.REGION
  subnetwork   = var.SUBNET_NAME
  name         = var.JUMP_SERVER_NAME
  address      = "10.0.0.7"
  description  = "An internal IP address for my jump host"
}


resource "google_compute_image" "default" {
  name = var.JUMP_SERVER_NAME
  project = var.PROJECT_NAME
  #family = null  # Specify if the image is part of an image family

  # Specify the source image from GCS
  # raw_disk {
  #   source = "https://storage.cloud.google.com/images_saips/jumpserver_1.tar.gz"
  # }
  #source_image = "https://storage.cloud.google.com/images_saips/jumpserver_1.tar.gz"
  source_image = "images/jumpserver-image"
}
resource "google_compute_instance" "default" {
  project      = var.PROJECT_NAME
  zone         = var.ZONE
  name         = var.JUMP_SERVER_NAME
  machine_type = var.JUMP_MACHINE_TYPE
   
  
  boot_disk {
    initialize_params {
      #image = "ubuntu-os-cloud/ubuntu-2204-lts"
       #image = google_compute_image.default.source_image
       image = google_compute_image.default.name
       
      
    }
  }
  network_interface {
    network    = var.VPC
    subnetwork = var.SUBNET_NAME # Replace with a reference or self link to your subnet, in quotes
    network_ip = google_compute_address.my_internal_ip_addr.address
  }

}


## Creare Firewall to access jump hist via iap


resource "google_compute_firewall" "rules" {
  project = var.PROJECT_NAME
  name    = var.FW_RULES_NAME
  network = var.VPC # Replace with a reference or self link to your network, in quotes

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = [var.FW_SOURCE_RANGE]
}



## Create IAP SSH permissions for your test instance

resource "google_project_iam_member" "project" {
  project = var.PROJECT_NAME
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:gke-service@gke-saips.iam.gserviceaccount.com"
}

# create cloud router for nat gateway
resource "google_compute_router" "router" {
  project = var.PROJECT_NAME
  name    = var.ROUTER_NAME
  network = var.VPC
  region  = var.REGION
}

## Create Nat Gateway with module

module "cloud-nat" {
  source     = "terraform-google-modules/cloud-nat/google"
  version    = "~> 1.2"
  project_id = var.PROJECT_NAME
  region     = var.REGION
  router     = google_compute_router.router.name
  name       = var.NAT

}


############Output############################################
output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}



