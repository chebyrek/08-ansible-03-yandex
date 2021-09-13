# попытка создавать машины для тестов не руками
# не добавляется ssh ключ почему-то
# и после создания машины не могу попасть на нее по ssh
# полежит тут пока не найду еще времени разобраться в чем дело
variable "token" {}
variable "cloud_id" {}
variable "folder_id" {}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~>0.61.0"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "vm2" {
  name               = "vm2"
  platform_id        = "standard-v1"
  zone               = "ru-central1-a"
  hostname           = "vm2"
  service_account_id = "aje9vc1j0lnu9um46s13"

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      size     = 10
      type     = "network-ssd"
      image_id = data.yandex_compute_image.ubuntu2004.id
    }

  }

  network_interface {
    subnet_id = "e9bjglrhvitgdvbri25l"
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
}

data "yandex_compute_image" "ubuntu2004" {
  family = "ubuntu-2004-lts"
}
