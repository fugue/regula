# Rules List

To view the Rego code for the rules below, see our [GitHub repo](https://github.com/fugue/regula/tree/master/rego/rules).

!!! tip
    Click on a column to sort alphabetically by that category, and click it again to reverse the sort order.

## AWS (Terraform)
|                                                               Summary                                                                |      Resource Types       |Severity| Rule ID |
|--------------------------------------------------------------------------------------------------------------------------------------|---------------------------|--------|---------|
|IAM password policies should prevent reuse of previously used passwords                                                               |MULTIPLE                   |Medium  |FG_R00002|
|IAM password policies should expire passwords within 90 days                                                                          |MULTIPLE                   |Medium  |FG_R00003|
|IAM policies should not be attached to users                                                                                          |MULTIPLE                   |Low     |FG_R00007|
|CloudFront distribution origin should be set to S3 or origin protocol policy should be set to https-only                              |MULTIPLE                   |Medium  |FG_R00010|
|CloudFront viewer protocol policy should be set to https-only or redirect-to-https                                                    |aws_cloudfront_distribution|Medium  |FG_R00011|
|ELBv1 listener protocol should not be set to http                                                                                     |MULTIPLE                   |High    |FG_R00013|
|Auto Scaling groups should span two or more availability zones                                                                        |MULTIPLE                   |Medium  |FG_R00014|
|EBS volume encryption should be enabled                                                                                               |MULTIPLE                   |High    |FG_R00016|
|CloudFront distributions should have geo-restrictions specified                                                                       |MULTIPLE                   |Medium  |FG_R00018|
|IAM password policies should require at least one uppercase character                                                                 |MULTIPLE                   |Medium  |FG_R00021|
|IAM password policies should require at least one lowercase character                                                                 |MULTIPLE                   |Medium  |FG_R00022|
|IAM password policies should require at least one symbol                                                                              |MULTIPLE                   |Medium  |FG_R00023|
|IAM password policies should require at least one number                                                                              |MULTIPLE                   |Medium  |FG_R00024|
|IAM password policies should require a minimum length of 14                                                                           |MULTIPLE                   |Medium  |FG_R00025|
|CloudTrail log file validation should be enabled                                                                                      |aws_cloudtrail             |Medium  |FG_R00027|
|S3 bucket ACLs should not have public access on S3 buckets that store CloudTrail log files                                            |MULTIPLE                   |Critical|FG_R00028|
|CloudTrail trails should have CloudWatch log integration enabled                                                                      |MULTIPLE                   |Medium  |FG_R00029|
|S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files                                              |MULTIPLE                   |Medium  |FG_R00031|
|CloudTrail log files should be encrypted with customer managed KMS keys                                                               |MULTIPLE                   |High    |FG_R00035|
|KMS CMK rotation should be enabled                                                                                                    |aws_kms_key                |Medium  |FG_R00036|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5900 (Virtual Network Computing)                  |MULTIPLE                   |High    |FG_R00037|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5800 (Virtual Network Computing), unless from ELBs|MULTIPLE                   |High    |FG_R00038|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5500 (Virtual Network Computing)                  |MULTIPLE                   |High    |FG_R00039|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 23 (Telnet)                                       |MULTIPLE                   |High    |FG_R00040|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 80 (HTTP), unless from ELBs                       |MULTIPLE                   |High    |FG_R00041|
|ELBv1 load balancer cross zone load balancing should be enabled                                                                       |MULTIPLE                   |Medium  |FG_R00043|
|VPC security group inbound rules should not permit ingress from a public address to all ports and protocols                           |aws_security_group         |High    |FG_R00044|
|VPC security group inbound rules should not permit ingress from '0.0.0.0/0' to all ports and protocols                                |MULTIPLE                   |High    |FG_R00045|
|SQS access policies should not have global \"*.*\" access                                                                             |MULTIPLE                   |Critical|FG_R00049|
|SNS subscriptions should deny access via HTTP                                                                                         |MULTIPLE                   |Medium  |FG_R00052|
|VPC flow logging should be enabled                                                                                                    |MULTIPLE                   |Medium  |FG_R00054|
|Load balancer access logging should be enabled                                                                                        |MULTIPLE                   |Medium  |FG_R00066|
|CloudFront access logging should be enabled                                                                                           |MULTIPLE                   |Medium  |FG_R00067|
|CloudWatch log groups should be encrypted with customer managed KMS keys                                                              |MULTIPLE                   |Medium  |FG_R00068|
|DynamoDB tables should be encrypted with AWS or customer managed KMS keys                                                             |MULTIPLE                   |Medium  |FG_R00069|
|SQS queue server-side encryption should be enabled with KMS keys                                                                      |MULTIPLE                   |High    |FG_R00070|
|CloudFront distributions should be protected by WAFs                                                                                  |aws_cloudfront_distribution|Medium  |FG_R00073|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH)                                          |MULTIPLE                   |High    |FG_R00085|
|IAM password policies should have a minimum length of 7 and include both alphabetic and numeric characters                            |MULTIPLE                   |Medium  |FG_R00086|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)                            |MULTIPLE                   |High    |FG_R00087|
|IAM password policies should prevent reuse of the four previously used passwords                                                      |MULTIPLE                   |Medium  |FG_R00088|
|VPC default security group should restrict all traffic                                                                                |MULTIPLE                   |Medium  |FG_R00089|
|IAM policies should not have full \"*:*\" administrative privileges                                                                   |MULTIPLE                   |High    |FG_R00092|
|RDS instances should be encrypted                                                                                                     |MULTIPLE                   |High    |FG_R00093|
|RDS instances should have FedRAMP approved database engines                                                                           |MULTIPLE                   |Low     |FG_R00094|
|S3 bucket server-side encryption should be enabled                                                                                    |aws_s3_bucket              |High    |FG_R00099|
|S3 bucket policies should only allow requests that use HTTPS                                                                          |MULTIPLE                   |Medium  |FG_R00100|
|S3 bucket versioning and lifecycle policies should be enabled                                                                         |aws_s3_bucket              |Medium  |FG_R00101|
|ELB listener security groups should not be set to TCP all                                                                             |MULTIPLE                   |High    |FG_R00102|
|VPC security groups attached to EC2 instances should not permit ingress from '0.0.0.0/0' to all ports                                 |MULTIPLE                   |High    |FG_R00103|
|VPC security groups attached to RDS instances should not permit ingress from '0.0.0.0/0' to all ports                                 |MULTIPLE                   |High    |FG_R00104|
|ElastiCache transport encryption should be enabled                                                                                    |MULTIPLE                   |Medium  |FG_R00105|
|DynamoDB tables Point in Time Recovery should be enabled                                                                              |MULTIPLE                   |Medium  |FG_R00106|
|RDS instances should have backup retention periods configured                                                                         |MULTIPLE                   |Medium  |FG_R00107|
|RDS Aurora cluster multi-AZ should be enabled                                                                                         |MULTIPLE                   |Medium  |FG_R00209|
|S3 bucket policies should not allow all actions for all IAM principals and public users                                               |MULTIPLE                   |High    |FG_R00210|
|S3 bucket policies should not allow list actions for all IAM principals and public users                                              |MULTIPLE                   |High    |FG_R00211|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 9200 (Elasticsearch)                              |MULTIPLE                   |High    |FG_R00212|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 9300 (Elasticsearch)                              |MULTIPLE                   |High    |FG_R00213|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 2379 (etcd)                                       |MULTIPLE                   |High    |FG_R00214|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 27017 (MongoDB)                                   |MULTIPLE                   |High    |FG_R00215|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 27018 (MongoDB)                                   |MULTIPLE                   |High    |FG_R00216|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 27019 (MongoDB)                                   |MULTIPLE                   |High    |FG_R00217|
|IAM policies should not allow broad list actions on S3 buckets                                                                        |MULTIPLE                   |Medium  |FG_R00218|
|IAM role trust policies should not allow all principals to assume the role                                                            |MULTIPLE                   |Medium  |FG_R00219|
|IAM roles attached to instance profiles should not allow broad list actions on S3 buckets                                             |MULTIPLE                   |Medium  |FG_R00220|
|S3 buckets should have all `block public access` options enabled                                                                      |MULTIPLE                   |High    |FG_R00229|
|VPC security groups attached to EC2 instances should not permit ingress from '0.0.0.0/0' to TCP/UDP port 389 (LDAP)                   |MULTIPLE                   |High    |FG_R00234|
|CloudTrail trails should be configured to log management events                                                                       |aws_cloudtrail             |Medium  |FG_R00237|
|CloudWatch alarms should have at least one alarm action, one INSUFFICIENT_DATA action, or one OK action enabled                       |aws_cloudwatch_metric_alarm|Medium  |FG_R00240|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 11214 (Memcached SSL)                             |aws_security_group         |High    |FG_R00242|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 11215 (Memcached SSL)                             |aws_security_group         |High    |FG_R00243|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 135 (MSSQL Debugger)                              |aws_security_group         |High    |FG_R00244|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 137 (NetBIOS Name Service)                        |aws_security_group         |High    |FG_R00245|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 138 (NetBios Datagram Service)                    |aws_security_group         |High    |FG_R00246|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 139 (NetBios Session Service)                     |aws_security_group         |High    |FG_R00247|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 1433 (MSSQL Server)                               |aws_security_group         |High    |FG_R00248|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 1434 (MSSQL Admin)                                |aws_security_group         |High    |FG_R00249|
|Require Multi Availability Zones turned on for RDS Instances                                                                          |MULTIPLE                   |Medium  |FG_R00251|
|KMS master keys should not be publicly accessible                                                                                     |aws_kms_key                |Critical|FG_R00252|
|EC2 instances should use IAM roles and instance profiles instead of IAM access keys to perform requests                               |aws_instance               |High    |FG_R00253|
|IAM roles used for trust relationships should have MFA or external IDs                                                                |aws_iam_role               |High    |FG_R00255|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 2382 (SQL Server Analysis Services browser)       |aws_security_group         |High    |FG_R00256|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 2383 (SQL Server Analysis Services)               |aws_security_group         |High    |FG_R00257|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 2484 (Oracle DB SSL)                              |aws_security_group         |High    |FG_R00258|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3000 (Ruby on Rails web server)                   |aws_security_group         |High    |FG_R00259|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3020 (CIFS / SMB)                                 |aws_security_group         |High    |FG_R00260|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3306 (MySQL)                                      |aws_security_group         |High    |FG_R00261|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 4505 (SaltStack Master)                           |aws_security_group         |High    |FG_R00262|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 4506 (SaltStack Master)                           |aws_security_group         |High    |FG_R00263|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5432 (PostgreSQL)                                 |aws_security_group         |High    |FG_R00264|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP port 61621 (Cassandra OpsCenter Agent)                     |aws_security_group         |High    |FG_R00265|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP port 636 (LDAP SSL)                                        |aws_security_group         |High    |FG_R00266|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP port 7001 (Cassandra)                                      |aws_security_group         |High    |FG_R00267|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 8000 (HTTP Alternate)                             |aws_security_group         |High    |FG_R00268|
|Redshift cluster 'Publicly Accessible' should not be enabled                                                                          |aws_redshift_cluster       |Critical|FG_R00270|
|EC2 instances should not have a public IP association (IPv4)                                                                          |aws_instance               |Medium  |FG_R00271|
|IAM users should be members of at least one group                                                                                     |MULTIPLE                   |Low     |FG_R00272|
|S3 bucket access logging should be enabled                                                                                            |aws_s3_bucket              |Medium  |FG_R00274|
|S3 bucket replication (cross-region or same-region) should be enabled                                                                 |aws_s3_bucket              |Medium  |FG_R00275|
|Lambda function policies should not allow global access                                                                               |MULTIPLE                   |High    |FG_R00276|
|S3 buckets should not be publicly readable                                                                                            |MULTIPLE                   |Critical|FG_R00277|
|RDS instance 'Publicly Accessible' should not be enabled                                                                              |aws_db_instance            |High    |FG_R00278|
|S3 bucket policies and ACLs should not be configured for public read access                                                           |MULTIPLE                   |High    |FG_R00279|
|RDS instance 'Deletion Protection' should be enabled                                                                                  |aws_db_instance            |Medium  |FG_R00280|
|VPC security group inbound rules should not permit ingress from any address to all ports and protocols                                |aws_security_group         |Medium  |FG_R00350|
|S3 bucket object-level logging for write events should be enabled                                                                     |MULTIPLE                   |Low     |FG_R00354|
|S3 bucket object-level logging for read events should be enabled                                                                      |MULTIPLE                   |Low     |FG_R00355|
|VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 22                                                                   |MULTIPLE                   |High    |FG_R00357|
|VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 3389                                                                 |MULTIPLE                   |High    |FG_R00359|
|API Gateway classic custom domains should use secure TLS protocol versions (1.2 and above)                                            |aws_api_gateway_domain_name|Medium  |FG_R00375|
|VPC security group rules should not permit ingress from '0.0.0.0/0' except to ports 80 and 443                                        |aws_security_group         |Medium  |FG_R00377|
|Lambda permissions with a service principal should apply to only one resource and AWS account                                         |MULTIPLE                   |Medium  |FG_R00499|
|WAFv2 web ACLs should include the 'AWSManagedRulesKnownBadInputsRuleSet' managed rule group                                           |MULTIPLE                   |Critical|FG_R00500|

## AWS (CloudFormation)
|                                                 Summary                                                  |    Resource Types    |Severity| Rule ID |
|----------------------------------------------------------------------------------------------------------|----------------------|--------|---------|
|IAM policies should not be attached to users                                                              |MULTIPLE              |Low     |FG_R00007|
|EBS volume encryption should be enabled                                                                   |AWS::EC2::Volume      |High    |FG_R00016|
|CloudTrail log file validation should be enabled                                                          |AWS::CloudTrail::Trail|Medium  |FG_R00027|
|S3 bucket ACLs should not have public access on S3 buckets that store CloudTrail log files                |MULTIPLE              |Critical|FG_R00028|
|CloudTrail trails should have CloudWatch log integration enabled                                          |AWS::CloudTrail::Trail|Medium  |FG_R00029|
|S3 bucket access logging should be enabled on S3 buckets that store CloudTrail log files                  |MULTIPLE              |Medium  |FG_R00031|
|CloudTrail log files should be encrypted using KMS CMKs                                                   |AWS::CloudTrail::Trail|High    |FG_R00035|
|KMS CMK rotation should be enabled                                                                        |AWS::KMS::Key         |Medium  |FG_R00036|
|VPC flow logging should be enabled                                                                        |MULTIPLE              |Medium  |FG_R00054|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH)              |MULTIPLE              |High    |FG_R00085|
|VPC security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)|MULTIPLE              |High    |FG_R00087|
|VPC default security group should restrict all traffic                                                    |MULTIPLE              |Medium  |FG_R00089|
|IAM policies should not have full \"*:*\" administrative privileges                                       |MULTIPLE              |High    |FG_R00092|
|S3 bucket server side encryption should be enabled                                                        |AWS::S3::Bucket       |High    |FG_R00099|
|S3 bucket policies should only allow requests that use HTTPS                                              |MULTIPLE              |Medium  |FG_R00100|
|S3 buckets should have all `block public access` options enabled                                          |AWS::S3::Bucket       |High    |FG_R00229|
|Lambda function policies should not allow global access                                                   |MULTIPLE              |High    |FG_R00276|
|S3 bucket object-level logging for write events should be enabled                                         |MULTIPLE              |Low     |FG_R00354|
|S3 bucket object-level logging for read events should be enabled                                          |MULTIPLE              |Low     |FG_R00355|
|VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 22                                       |MULTIPLE              |High    |FG_R00357|
|VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 3389                                     |MULTIPLE              |High    |FG_R00359|
|API Gateway classic custom domains should use secure TLS protocol versions (1.2 and above)                |MULTIPLE              |Medium  |FG_R00375|
|API Gateway v2 custom domains should use secure TLS protocol versions (1.2 and above)                     |MULTIPLE              |Medium  |FG_R00376|

## Azure (Terraform)
|                                                              Summary                                                               |      Resource Types       |Severity| Rule ID |
|------------------------------------------------------------------------------------------------------------------------------------|---------------------------|--------|---------|
|Storage Accounts 'Secure transfer required' should be enabled                                                                       |azurerm_storage_account    |Medium  |FG_R00152|
|Storage Account default network access rules should deny all traffic                                                                |MULTIPLE                   |High    |FG_R00154|
|Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3389 (RDP)                               |MULTIPLE                   |High    |FG_R00190|
|Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH)                                 |MULTIPLE                   |High    |FG_R00191|
|Virtual Network security groups attached to SQL Server instances should not permit ingress from 0.0.0.0/0 to all ports and protocols|azurerm_sql_firewall_rule  |High    |FG_R00192|
|Virtual Machines data disks (non-boot volumes) should be encrypted                                                                  |MULTIPLE                   |High    |FG_R00196|
|Virtual Machines unattached disks should be encrypted                                                                               |MULTIPLE                   |High    |FG_R00197|
|Blob Storage containers should have public access disabled                                                                          |azurerm_storage_container  |Critical|FG_R00207|
|Storage Accounts should have 'Trusted Microsoft Services' enabled                                                                   |MULTIPLE                   |Medium  |FG_R00208|
|SQL Server firewall rules should not permit start and end IP addresses to be 0.0.0.0                                                |MULTIPLE                   |High    |FG_R00221|
|MySQL Database server firewall rules should not permit start and end IP addresses to be 0.0.0.0                                     |MULTIPLE                   |High    |FG_R00222|
|PostgreSQL Database server firewall rules should not permit start and end IP addresses to be 0.0.0.0                                |MULTIPLE                   |High    |FG_R00223|
|Ensure Azure Application Gateway Web application firewall (WAF) is enabled                                                          |MULTIPLE                   |Medium  |FG_R00224|
|MySQL Database server 'enforce SSL connection' should be enabled                                                                    |azurerm_mysql_server       |Medium  |FG_R00225|
|PostgreSQL Database server 'enforce SSL connection' should be enabled                                                               |azurerm_postgresql_server  |Medium  |FG_R00226|
|Key Vault 'Enable Soft Delete' and 'Enable Purge Protection' should be enabled                                                      |azurerm_key_vault          |Medium  |FG_R00227|
|SQL Server auditing should be enabled                                                                                               |MULTIPLE                   |Medium  |FG_R00282|
|SQL Server auditing retention should be 90 days or greater                                                                          |MULTIPLE                   |Medium  |FG_R00283|
|Virtual Network security group flow log retention period should be set to 90 days or greater                                        |MULTIPLE                   |Medium  |FG_R00286|
|Active Directory custom subscription owner roles should not be created                                                              |azurerm_role_definition    |Medium  |FG_R00288|
|PostgreSQL Database configuration 'log_checkpoints' should be on                                                                    |MULTIPLE                   |Medium  |FG_R00317|
|PostgreSQL Database configuration 'log_connections' should be on                                                                    |MULTIPLE                   |Medium  |FG_R00318|
|Azure Kubernetes Service instances should have RBAC enabled                                                                         |azurerm_kubernetes_cluster |Medium  |FG_R00329|
|PostgreSQL Database configuration 'log_disconnections' should be on                                                                 |MULTIPLE                   |Medium  |FG_R00331|
|PostgreSQL Database configuration 'log_duration' should be on                                                                       |MULTIPLE                   |Medium  |FG_R00333|
|PostgreSQL Database configuration 'connection_throttling' should be on                                                              |MULTIPLE                   |Medium  |FG_R00335|
|PostgreSQL Database configuration 'log_retention days' should be greater than 3                                                     |MULTIPLE                   |Medium  |FG_R00337|
|Monitor 'Activity Log Retention' should be 365 days or greater                                                                      |azurerm_monitor_log_profile|Medium  |FG_R00340|
|Monitor audit profile should log all activities                                                                                     |azurerm_monitor_log_profile|Medium  |FG_R00341|
|Monitor log profile should have activity logs for global services and all regions                                                   |MULTIPLE                   |Medium  |FG_R00342|
|Key Vault logging should be enabled                                                                                                 |MULTIPLE                   |Medium  |FG_R00344|
|App Service web app authentication should be enabled                                                                                |MULTIPLE                   |Medium  |FG_R00345|
|App Service web apps should have 'HTTPS only' enabled                                                                               |azurerm_app_service        |High    |FG_R00346|
|App Service web apps should have 'Minimum TLS Version' set to '1.2'                                                                 |azurerm_app_service        |Medium  |FG_R00347|
|App Service web apps should have 'Incoming client certificates' enabled                                                             |azurerm_app_service        |Medium  |FG_R00348|
|Key Vault secrets should have an expiration date                                                                                    |MULTIPLE                   |Medium  |FG_R00451|
|App Service web apps should use a system-assigned managed service identity                                                          |azurerm_app_service        |Low     |FG_R00452|
|Security Center ‘Send email notification for high severity alerts’ should be enabled                                                |MULTIPLE                   |Medium  |FG_R00468|

## Azure (Azure Resource Manager)
|                                               Summary                                               |                               Resource Types                               |Severity| Rule ID |
|-----------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------|--------|---------|
|Storage Accounts 'Secure transfer required' should be enabled                                        |Microsoft.Storage/storageAccounts                                           |Medium  |FG_R00152|
|Storage Account default network access rules should deny all traffic                                 |Microsoft.Storage/storageAccounts                                           |High    |FG_R00154|
|Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3389 (RDP)|MULTIPLE                                                                    |High    |FG_R00190|
|Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH)  |MULTIPLE                                                                    |High    |FG_R00191|
|Virtual Machines data disks (non-boot volumes) should be encrypted                                   |MULTIPLE                                                                    |High    |FG_R00196|
|Virtual Machines unattached disks should be encrypted                                                |MULTIPLE                                                                    |High    |FG_R00197|
|Blob Storage containers should have public access disabled                                           |Microsoft.Storage/storageAccounts/blobServices/containers                   |Critical|FG_R00207|
|Storage Accounts should have 'Trusted Microsoft Services' enabled                                    |Microsoft.Storage/storageAccounts                                           |Medium  |FG_R00208|
|SQL Server firewall rules should not permit start and end IP addresses to be 0.0.0.0                 |Microsoft.Sql/servers/firewallRules                                         |High    |FG_R00221|
|MySQL Database server firewall rules should not permit start and end IP addresses to be 0.0.0.0      |Microsoft.DBforMySQL/servers/firewallRules                                  |High    |FG_R00222|
|PostgreSQL Database server firewall rules should not permit start and end IP addresses to be 0.0.0.0 |Microsoft.DBforPostgreSQL/servers/firewallRules                             |High    |FG_R00223|
|Ensure Azure Application Gateway Web application firewall (WAF) is enabled                           |Microsoft.Network/applicationGateways                                       |Medium  |FG_R00224|
|MySQL Database server 'enforce SSL connection' should be enabled                                     |Microsoft.DBforMySQL/servers                                                |Medium  |FG_R00225|
|PostgreSQL Database server 'enforce SSL connection' should be enabled                                |Microsoft.DBforPostgreSQL/servers                                           |Medium  |FG_R00226|
|Key Vault 'Enable Soft Delete' and 'Enable Purge Protection' should be enabled                       |Microsoft.KeyVault/vaults                                                   |Medium  |FG_R00227|
|SQL Server auditing should be enabled                                                                |MULTIPLE                                                                    |Medium  |FG_R00282|
|SQL Server auditing retention should be 90 days or greater                                           |MULTIPLE                                                                    |Medium  |FG_R00283|
|Virtual Network security group flow log retention period should be set to 90 days or greater         |MULTIPLE                                                                    |Medium  |FG_R00286|
|Active Directory custom subscription owner roles should not be created                               |Microsoft.Authorization/roledefinitions                                     |Medium  |FG_R00288|
|PostgreSQL Database configuration 'log_checkpoints' should be on                                     |MULTIPLE                                                                    |Medium  |FG_R00317|
|PostgreSQL Database configuration 'log_connections' should be on                                     |MULTIPLE                                                                    |Medium  |FG_R00318|
|Azure Kubernetes Service instances should have RBAC enabled                                          |Microsoft.ContainerService/managedClusters                                  |Medium  |FG_R00329|
|PostgreSQL Database configuration 'log_disconnections' should be on                                  |MULTIPLE                                                                    |Medium  |FG_R00331|
|PostgreSQL Database configuration 'log_duration' should be on                                        |MULTIPLE                                                                    |Medium  |FG_R00333|
|PostgreSQL Database configuration 'connection_throttling' should be on                               |MULTIPLE                                                                    |Medium  |FG_R00335|
|PostgreSQL Database configuration 'log_retention days' should be greater than 3                      |MULTIPLE                                                                    |Medium  |FG_R00337|
|Monitor 'Activity Log Retention' should be 365 days or greater                                       |Microsoft.Insights/logprofiles                                              |Medium  |FG_R00340|
|Monitor audit profile should log all activities                                                      |Microsoft.Insights/logprofiles                                              |Medium  |FG_R00341|
|Monitor log profile should have activity logs for global services and all regions                    |MULTIPLE                                                                    |Medium  |FG_R00342|
|Key Vault logging should be enabled                                                                  |MULTIPLE                                                                    |Medium  |FG_R00344|
|App Service web app authentication should be enabled                                                 |MULTIPLE                                                                    |Medium  |FG_R00345|
|App Service web apps should have 'HTTPS only' enabled                                                |Microsoft.Web/sites                                                         |High    |FG_R00346|
|App Service web apps should have 'Minimum TLS Version' set to '1.2'                                  |MULTIPLE                                                                    |Medium  |FG_R00347|
|App Service web apps should have 'Incoming client certificates' enabled                              |Microsoft.Web/sites                                                         |Medium  |FG_R00348|
|Storage Queue logging should be enabled for read, write, and delete requests                         |Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings|Medium  |FG_R00440|
|Key Vault secrets should have an expiration date set                                                 |Microsoft.KeyVault/vaults/secrets                                           |Medium  |FG_R00451|
|App Service web apps should use a system-assigned managed service identity                           |Microsoft.Web/sites                                                         |Low     |FG_R00452|
|Security Center 'Send email notification for high severity alerts' should be enabled                 |Microsoft.Security/securityContacts                                         |Medium  |FG_R00468|

## Google
|                                                Summary                                                 |       Resource Types       |Severity| Rule ID |
|--------------------------------------------------------------------------------------------------------|----------------------------|--------|---------|
|KMS keys should be rotated every 90 days or less                                                        |google_kms_crypto_key       |Medium  |FG_R00378|
|Service accounts should only have Google-managed service account keys                                   |MULTIPLE                    |Medium  |FG_R00383|
|User-managed service accounts should not have admin privileges                                          |MULTIPLE                    |High    |FG_R00384|
|IAM users should not have project-level 'Service Account User' or 'Service Account Token Creator' roles |MULTIPLE                    |High    |FG_R00385|
|KMS keys should not be anonymously or publicly accessible                                               |MULTIPLE                    |Critical|FG_R00386|
|IAM users should not have both KMS admin and any of the KMS encrypter/decrypter roles                   |MULTIPLE                    |Medium  |FG_R00388|
|IAM default audit log config should include 'DATA_READ' and 'DATA_WRITE' log types                      |MULTIPLE                    |Medium  |FG_R00389|
|IAM default audit log config should not exempt any users                                                |MULTIPLE                    |Medium  |FG_R00391|
|Logging storage bucket retention policies and Bucket Lock should be configured                          |MULTIPLE                    |Medium  |FG_R00393|
|DNS managed zone DNSSEC should be enabled                                                               |google_dns_managed_zone     |Medium  |FG_R00404|
|DNS managed zone DNSSEC key-signing keys should not use RSASHA1                                         |google_dns_managed_zone     |High    |FG_R00405|
|DNS managed zone DNSSEC zone-signing keys should not use RSASHA1                                        |google_dns_managed_zone     |High    |FG_R00406|
|Network firewall rules should not permit ingress from 0.0.0.0/0 to port 22 (SSH)                        |MULTIPLE                    |High    |FG_R00407|
|Network firewall rules should not permit ingress from 0.0.0.0/0 to port 3389 (RDP)                      |MULTIPLE                    |High    |FG_R00408|
|Network subnet flow logs should be enabled                                                              |google_compute_subnetwork   |Medium  |FG_R00409|
|Load balancer HTTPS or SSL proxy SSL policies should not have weak cipher suites                        |MULTIPLE                    |Medium  |FG_R00410|
|Compute instances should not use the default service account                                            |google_compute_instance     |Medium  |FG_R00411|
|Compute instances should not use the default service account with full access to all Cloud APIs         |google_compute_instance     |High    |FG_R00412|
|Compute instance 'block-project-ssh-keys' should be enabled                                             |MULTIPLE                    |Medium  |FG_R00413|
|Compute instances 'Enable connecting to serial ports' should not be enabled                             |MULTIPLE                    |High    |FG_R00415|
|Compute instances 'IP forwarding' should not be enabled                                                 |google_compute_instance     |Low     |FG_R00416|
|Compute instance disks should be encrypted with customer-supplied encryption keys (CSEKs)               |MULTIPLE                    |Medium  |FG_R00417|
|Compute instance Shielded VM should be enabled                                                          |google_compute_instance     |Medium  |FG_R00418|
|Compute instances should not have public IP addresses                                                   |google_compute_instance     |Medium  |FG_R00419|
|Storage buckets should not be anonymously or publicly accessible                                        |MULTIPLE                    |Critical|FG_R00420|
|Storage bucket uniform access control should be enabled                                                 |google_storage_bucket       |Medium  |FG_R00421|
|MySQL database instance 'local_infile' database flag should be set to 'off'                             |MULTIPLE                    |Medium  |FG_R00423|
|PostgreSQL database instance 'log_checkpoints' database flag should be set to 'on'                      |MULTIPLE                    |Medium  |FG_R00424|
|PostgreSQL database instance 'log_connections' database flag should be set to 'on'                      |MULTIPLE                    |Medium  |FG_R00425|
|PostgreSQL database instance 'log_disconnections' database flag should be set to 'on'                   |MULTIPLE                    |Medium  |FG_R00426|
|PostgreSQL database instance 'log_lock_waits' database flag should be set to 'on'                       |MULTIPLE                    |Medium  |FG_R00427|
|PostgreSQL database instance 'log_min_error_statement' database flag should be set appropriately        |MULTIPLE                    |Medium  |FG_R00428|
|PostgreSQL database instance 'log_temp_files' database flag should be set to '0' (on)                   |MULTIPLE                    |Medium  |FG_R00429|
|PostgreSQL database instance 'log_min_duration_statement' database flag should be set to '-1' (disabled)|MULTIPLE                    |Medium  |FG_R00430|
|SQL Server database instance 'cross db ownership chaining' database flag should be set to 'off'         |MULTIPLE                    |Medium  |FG_R00431|
|SQL Server database instance 'contained database authentication' database flag should be set to 'off'   |MULTIPLE                    |Medium  |FG_R00432|
|SQL database instances should require incoming connections to use SSL                                   |google_sql_database_instance|Medium  |FG_R00433|
|SQL database instances should not permit access from 0.0.0.0/0                                          |google_sql_database_instance|High    |FG_R00434|
|SQL database instances should not have public IPs                                                       |google_sql_database_instance|Medium  |FG_R00435|
|SQL database instance automated backups should be enabled                                               |google_sql_database_instance|Medium  |FG_R00436|
|BigQuery datasets should not be anonymously or publicly accessible                                      |google_bigquery_dataset     |Critical|FG_R00437|
|VPC subnet 'Private Google Access' should be enabled                                                    |google_compute_subnetwork   |Low     |FG_R00438|

## Kubernetes
|                                         Summary                                          |Resource Types|Severity| Rule ID |
|------------------------------------------------------------------------------------------|--------------|--------|---------|
|The 'cluster-admin' role should not be used                                               |MULTIPLE      |High    |FG_R00479|
|Roles and cluster roles should not grant 'get', 'list', or 'watch' permissions for secrets|MULTIPLE      |Medium  |FG_R00480|
|Roles and cluster roles should not use wildcards for resource, verb, or apiGroup entries  |MULTIPLE      |High    |FG_R00481|
|Roles and cluster roles should not grant 'create' permissions for pods                    |MULTIPLE      |Medium  |FG_R00482|
|Default service account 'automountServiceAccountToken' should be set to 'false'           |MULTIPLE      |Medium  |FG_R00483|
|Service account 'automountServiceAccountToken' should be set to 'false'                   |MULTIPLE      |Medium  |FG_R00484|
|Pods should not run privileged containers                                                 |MULTIPLE      |High    |FG_R00485|
|Pods should not run containers wishing to share the host process ID namespace             |MULTIPLE      |Medium  |FG_R00486|
|Pods should not run containers wishing to share the host IPC namespace                    |MULTIPLE      |Medium  |FG_R00487|
|Pods should not run containers wishing to share the host network namespace                |MULTIPLE      |Medium  |FG_R00488|
|Pods should not run containers with allowPrivilegeEscalation                              |MULTIPLE      |Medium  |FG_R00489|
|Pods should not run containers as the root user                                           |MULTIPLE      |Medium  |FG_R00490|
|Pods should not run containers with the NET_RAW capability                                |MULTIPLE      |Medium  |FG_R00491|
|Pods should not run containers with added capabilities                                    |MULTIPLE      |Medium  |FG_R00492|
|Pods should not run containers with default capabilities assigned                         |MULTIPLE      |Medium  |FG_R00493|
|Pods should not use secrets stored in environment variables                               |MULTIPLE      |Medium  |FG_R00494|
|Pod seccomp profile should be set to 'docker/default'                                     |MULTIPLE      |Medium  |FG_R00495|
|Pods and containers should apply a security context                                       |MULTIPLE      |Medium  |FG_R00496|
|The default namespace should not be used                                                  |MULTIPLE      |Low     |FG_R00497|
|Roles and cluster roles should not be bound to the default service account                |MULTIPLE      |Medium  |FG_R00498|

