# luc_infra
Terraform code to create a simple Web application with ALB, ASG, Few EC2 Instances and an RDS 

Modules can be used instead of using resources to reuse the code. 

Assumptions made :  
 a)ASG has min size of 2 and max size of 4 .        
 b)Considered ALB is only listening to HTTP and not HTTPS traffic .  
 c)Considered mysql is used for RDS Instance .    
 d)Added user data section while creating ec2 Instance, which installs httpd on each instance being created .     
 e)In few cases, used count method just as to be able to increase the number of resources being created .     
 f)Attached IGW to the VPC so as to have a route for outgoing traffic . 
 
