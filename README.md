### <h1>Project H 개발 일지</h1>  

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Road Map

![project-h-roadmap](https://user-images.githubusercontent.com/43293666/98557407-80e1bf00-22e7-11eb-923b-11034bb22043.jpg)

--------------------------------------------------------------------------------------------------------------------------------------------------------
# AWS hosting (DNS, SSL) + Load Balancer
- AWS의 도메인과 SSL은 Route53과 Certificate Manager을 통해 할 수 있다. 
- SSL 적용은 AWS에서 CloudFront와 Load Balancer를 통해 적용 할 수 있다. 

## DNS 
- 호스팅케이알을 통해 구입하여 도메인 세팅을 하였음 
- https://hessdalen.xyz

## Route53 + Certificate Manager
<img width="1283" alt="스크린샷 2020-11-13 오후 7 53 26" src="https://user-images.githubusercontent.com/43293666/99083113-6b7ed480-2608-11eb-89e7-d3d1b113573b.png">

- Route53의 호스팅 영역 들어가서 도메인 세팅

## Load Balancer


<img width="1283" alt="스크린샷 2020-11-13 오후 7 55 34" src="https://user-images.githubusercontent.com/43293666/99083308-b698e780-2608-11eb-9386-b097e9c8694f.png">

- 마지막으로 Load Balancer에 대한 모니터링을 하여 트래픽 패턴을 분석하고 대상의 문제를 해결

--------------------------------------------------------------------------------------------------------------------------------------------------------
# AWS_cli (AWS configue), Terraform, Docker (docker-compose) Install
- AWS_cli를 통해 AWS서비스와 상호작용하기 위함 ( 즉 콘솔로 통해 IaaS AWS 관리 및 엑세스 )
[aws-cli.pdf](https://github.com/hm98127/project_h/files/5537428/aws-cli.pdf) 참고
- 
## Install
1. docker install
2. aws-cli install
3. terraform install
4. version
<img width="803" alt="스크린샷 2020-11-09 오후 12 26 38" src="https://user-images.githubusercontent.com/43293666/98550184-1fb5ed80-22df-11eb-8507-a6536a502480.png">
- version


## Terraform S3-bucket
<img width="799" alt="스크린샷 2020-11-09 오후 2 26 25" src="https://user-images.githubusercontent.com/43293666/98557618-c7371e00-22e7-11eb-863a-bba01c278bcd.png">
- aws s3_bucket terraform file

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Jenkins Setting + Github 
## jenkins docker setting
## jenkins github integration


--------------------------------------------------------------------------------------------------------------------------------------------------------
# Nginx + Tomcat + MariaDB
## docker network setting 
## Nginx, Tomcat and MariaDB Install
## Nginx proxy setting
## Tomcat + MariaDB

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Docker Monitering (Data Dog)

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Test, Issue Trouble shooting
## Issue 1 
## Issue 2
