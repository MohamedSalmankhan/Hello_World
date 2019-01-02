output "ec2-instance-id" {
  value = "${aws_instance.EC2_instance.id}"
}
output "ec2-SG-id" {
  value = "${aws_security_group.SG_EC2.id}"
}
output "elb-SG-id" {
  value = "${aws_security_group.SG_ELB.id}"
}
output "elb-dns" {
  value = "${aws_elb.ELB.dns_name}"
}