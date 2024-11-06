terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  # Configuration options
}

# Create Ubuntu image
resource "docker_image" "ubuntu_image" {
  name = "ubuntu"
}

# Create Tomcat image
resource "docker_image" "tomcat_image" {
  name = "tomcat"
}

# Create Nginx image
resource "docker_image" "nginx_image" {
  name = "nginx"
}

# Create Tomcat container
resource "docker_container" "tomcat_container" {
  name  = "tomcat"
  image = docker_image.tomcat_image.name
  ports {
    internal = 8080
    external = 8081
  }
  command = ["catalina.sh", "run"]
}

# Create Nginx container
resource "docker_container" "nginx_container" {
  name  = "nginx"
  image = docker_image.nginx_image.name
  ports {
    internal = 8082
    external = 8082
  }
depends_on = [docker_container.tomcat_container]
}

