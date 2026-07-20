module "test_env" {
    source = "./modules/env"
    user_instance_type= "t3.micro"
    env_name = "test"
    vpc_cidr = "10.200.0.0/16"
    private_subnet_cidr = "10.200.10.0/24"
    public_subnet_cidr = "10.200.20.0/24"
    user_ami = "ami-0bc7aabcf58d1e02a"
    
}

module "dev_env" {
    source = "./modules/env"
    user_instance_type= "t3.micro"
    env_name = "dev"
    vpc_cidr = "10.201.0.0/16"
    private_subnet_cidr = "10.201.10.0/24"
    public_subnet_cidr = "10.201.20.0/24"
    user_ami = "ami-0bc7aabcf58d1e02a"
    
}

module "prod_env" {
    source = "./modules/env"
    user_instance_type= "t3.micro"
    env_name = "prod"
    vpc_cidr = "10.202.0.0/16"
    private_subnet_cidr = "10.202.10.0/24"
    public_subnet_cidr = "10.202.20.0/24"
    user_ami = "ami-0bc7aabcf58d1e02a"
    
}