terraform {
    required_providers {
        openstack = {
            source = "terraform-provider-openstack/openstack"
            version = "1.33.0"
        }

    }
}
provider "openstack" {
    user_name = "${var.user_name}"
    password = "${var.password}"
    tenant_id = "${var.tenant_id}"
    user_domain_id = "${var.user_domain_id}"
    auth_url = "https://infra.mail.ru:35357/v3/"
    use_octavia = true
    region = "RegionOne"
}
