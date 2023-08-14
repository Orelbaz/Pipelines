provider "google" {
  credentials = file("/home/or/Desktop/PrivateKeys/gke-Key.json")
  project     = "gke-first-393008"
  region      = "us-central1"
}

resource "google_container_cluster" "eks_prod" {
  name     = "eks-prod"
  location = "us-central1-c"
  initial_node_count = 1
}

resource "google_container_node_pool" "prod_node_pool" {
  name       = "prod-node-pool"
  location   = google_container_cluster.eks_prod.location
  cluster    = google_container_cluster.eks_prod.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 24
    disk_type    = "pd-standard"
  }
}


resource "google_container_cluster" "eks_test" {
  name     = "eks-test"
  location = "us-central1-c"
  initial_node_count = 1
}

resource "google_container_node_pool" "test_node_pool" {
  name       = "prod-node-pool"
  location   = google_container_cluster.eks_test.location
  cluster    = google_container_cluster.eks_test.name
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 5
  }

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 24
    disk_type    = "pd-standard"
  }
}
