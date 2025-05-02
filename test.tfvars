vpc_cidrblock= "10.1.0.0/16"
vpc_enablednshostname= true
vpc_enablednssupport= true
vpc_name= "Project-1"

subnets_availabilityzones=[
    "us-east-1a",
]

subnets_cidrblocks=[
    "10.1.1.0/24",
]
subnet_mappubliciponlaunch=true

aws_instance={
    "us-east-1"="ami-084568db4383264d4"
    "us-west-1"="ami-04f7a54071e74f488"
}
aws_region="us-east-1"
