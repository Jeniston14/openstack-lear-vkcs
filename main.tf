resource "openstack_compute_keypair_v2" "ssh-key" {
  name = "terraform_msc_key"
  public_key = file("${path.module}/terraform_msc.pub")

}

resource "openstack_networking_network_v2" "terraform_net_test" {
  name = "terraform-net-test"
  admin_state_up = "true"

}

resource "openstack_networking_subnet_v2" "terraform_subnet_test" {
  name = "subnet_test"
  network_id = openstack_networking_network_v2.terraform_net_test.id
  cidr = "10.0.0.0/24"
  ip_version = 4
  enable_dhcp = true

}

resource "openstack_networking_router_v2" "terraform_router_test" {
  name = "terraform_router_test"
  admin_state_up = "true"
  external_network_id = "${var.external_network_id}"

}

resource "openstack_networking_router_interface_v2" "terraform_router_inteface" {
  router_id = openstack_networking_router_v2.terraform_router_test.id
  subnet_id = openstack_networking_subnet_v2.terraform_subnet_test.id

}

resource "openstack_blockstorage_volume_v2" "volume" {
  name = "disk"
  volume_type = "dp1"
  size = "20"
  image_id = "cd733849-4922-4104-a280-9ea2c3145417"

}

resource "openstack_compute_instance_v2" "instance" {
  name = "test-update-vm"
  image_name = "Ubuntu-20.04"
  image_id = "cd733849-4922-4104-a280-9ea2c3145417"
  flavor_name = "Basic-1-1-10"
  availability_zone = "DP1"
  key_pair = openstack_compute_keypair_v2.ssh-key.name
  config_drive = true
  security_groups = ["terraform_security_group"]
  network {
    name = openstack_networking_network_v2.terraform_net_test.name

  }

  block_device {
    uuid = openstack_blockstorage_volume_v2.volume.id
    boot_index = 0
    source_type = "volume"
    destination_type = "volume"
    delete_on_termination = true

  }

}
