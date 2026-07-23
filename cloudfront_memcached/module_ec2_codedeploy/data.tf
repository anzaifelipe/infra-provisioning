data "template_file" "script" {
  template = file("file.sh")

  vars = {
    PLAT       = "${var.PLAT}",
    REGION     = "${var.REGION}",
    AUTOUPDATE = "${var.AUTOUPDATE}"
  }
}