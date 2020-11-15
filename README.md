# Project H 개발 일지  
#### Focus
- Infrastructure shopping mall web using Tomcat and Mariadb on Amazon Web Service
- Designed to meet the requirements of the backend
- Monitoring to operate and improve servers
- Pursue continuous integration and build infrastructure as code
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
![스크린샷 2020-11-16 오전 12 33 57](https://user-images.githubusercontent.com/43293666/99189188-7326b080-27a3-11eb-8ef7-566a5c8bad64.png)

<img width="1283" alt="스크린샷 2020-11-13 오후 7 55 34" src="https://user-images.githubusercontent.com/43293666/99083308-b698e780-2608-11eb-9386-b097e9c8694f.png">

- EC2 두개를 생성하여 AMI를 사용하여 고가용성 클러스터 구축 (현재 프로젝트에서는 비용상 두개 설계한뒤 하나는 지운 상태)
- 마지막으로 CloudWatch를 통해 Load Balancer에 대한 모니터링을 하여 트래픽 패턴을 분석하고 대상의 문제를 해결하기 위함 

--------------------------------------------------------------------------------------------------------------------------------------------------------
# AWS_cli (AWS configue), Terraform, Docker (docker-compose) Install
- AWS_cli를 통해 AWS서비스와 상호작용하기 위함 ( 즉 콘솔로 통해 IaaS AWS 관리 및 엑세스 -
[aws-cli.pdf](https://github.com/hm98127/project_h/files/5537428/aws-cli.pdf) 참고)
- 보통은 인프라를 만들 수 있도록 콘솔을 제공해주지만, 콘솔을 통해서 생성한 인프라는 형상을 파악하거나 변경사항을 추적하기가 쉽지 않음. 또한 연계된 인프라를 세팅해야 하는 경우도 많아짐.
- 위의 이유로 클라우드 인프라스트럭처 자동화를 위해 Terraform을 사용. (이 프로젝트의 경우 VPC-Network, S3버켓 생성에 사용)
- 애플리케이션을 환경에 구애 받지 않고 실행하는 기술 즉 컨테이너 환경에서 구축하기 위해 Docker 사용 (서버를 코드로 구성하고 관리하는 방법으로써 도커가 지닌 장점은 속도이다.) 
## Install
1. docker install
- docker install의 경우 설치 방법이 여러가지가 있다. 
- docker.io, docker-ce 등 다양하게 제공을 하지만 나중에 docker login에서 credentials 이슈가 발생할 수 있으므로 공홈에 나오는 절차에 따라 설치.
2. aws-cli install
3. terraform install
4. version
<img width="803" alt="스크린샷 2020-11-09 오후 12 26 38" src="https://user-images.githubusercontent.com/43293666/98550184-1fb5ed80-22df-11eb-8507-a6536a502480.png">

- Install Version 


## Terraform Public VPC, Subneting, S3-bucket 
- AWS의 Network는 무조건 VPC를 걸치기 때문에 필수적인 설정이라 볼 수 있음. 
-  VPC -> public Subnet -> Internet Gateway -> Route Table -> association -> rule create -> Loadbalancer 순이라 의존적
- private subnet일 경우 NatGateway를 만들어줘야 된다.
- S3_bucket을 통해 개발자들은 손쉽게 객체 파일이나 자원들을 업로드 할 수 있음. (주의점은 생성시 전세계에 유일한 이름이어야 한다.)  

<img width="658" alt="스크린샷 2020-11-15 오후 8 49 12" src="https://user-images.githubusercontent.com/43293666/99184179-778fa100-2784-11eb-8efb-71d4a861c702.png">

- 확장성을 위해 Inner rule을 사용하지 않고 Outer rule을 이용하는 것이 좋은 코드라 할 수 있음
- terraform plan을 통해 수정사항 확인 및 복구 
- terraform source 참고

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Jenkins Setting + Github 
- 소프트웨어 개발시 지속적으로 통합 서비스를 위해 사용
- 다수의 개발자들이 하나의 프로그램을 개발할 때 버전 충돌을 방지하기 위해 각자 작업한 내용을 공유영역(ex.Git)에 있는 저장소에 빈번히 업로드함으로써 지속적 통합이 가능

## jenkins docker setting
[jenkins-test-deploy-success](https://user-images.githubusercontent.com/43293666/99147272-f45a4680-26c2-11eb-84a2-4dcdc2e4a7ca.png)
- 설치후 배포 test 진행
- Dockerfile 및 docker-compose source 참고
## jenkins github integration
![jenkins-github-connect](https://user-images.githubusercontent.com/43293666/99147280-0e942480-26c3-11eb-8092-7af2c8fe170f.png)
- git과 연동하여 자동화 배포 test 진행

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Nginx + Tomcat + MariaDB
- apache와 tomcat 조합은 다양하고 효율적으로 연동이 되지만 nginx를 쓰는 이유는 세가지 이유에서이다.
- 첫째 비동기 Event-Driven 구조 (아파치와 달리 코어당 프로세스 처리식이 아니라 Event Handier를 통해 비동기 방식으로 처리해 먼저 처리되는 것부터 로직이 진행됨)
- 둘째 적은 리소스로 빠르게 동작 (운영측면에서는 나중에 클라이언트가 많아질 경우 쓰레드, 메모리 유지보수가 힘듬. 무엇보다 nginx 구성이 단순하다는 점)
- 마지막으로 인프라스트럭처의 여러 수준에서 부하를 분산할 수 있어 유용 (upstream 블록과 가중치 지정 등등)
- mariadb의 경우 백엔드 요구사항.  
## docker network setting 
<div class="colorscripter-code" style="color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important; position:relative !important;overflow:auto"><table class="colorscripter-code-table" style="margin:0;padding:0;border:none;background-color:#fafafa;border-radius:4px;" cellspacing="0" cellpadding="0"><tr><td style="padding:6px;border-right:2px solid #e5e5e5"><div style="margin:0;padding:0;word-break:normal;text-align:right;color:#666;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="line-height:130%">1</div></div></td><td style="padding:6px 0;text-align:left"><div style="margin:0;padding:0;color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="padding:0 6px; white-space:pre; line-height:130%">sudo&nbsp;docker&nbsp;network&nbsp;create&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>driver<span style="color:#0086b3"></span><span style="color:#a71d5d">=</span>bridge&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>subnet<span style="color:#0086b3"></span><span style="color:#a71d5d">=</span><span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">0.</span><span style="color:#0099cc">0</span><span style="color:#a71d5d">/</span><span style="color:#0099cc">16</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>ip<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>range<span style="color:#0086b3"></span><span style="color:#a71d5d">=</span><span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">5.</span><span style="color:#0099cc">0</span><span style="color:#a71d5d">/</span><span style="color:#0099cc">24</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>gateway<span style="color:#0086b3"></span><span style="color:#a71d5d">=</span><span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">5.</span><span style="color:#0099cc">254</span>&nbsp;project<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>h<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>proxy</div></div></td><td style="vertical-align:bottom;padding:0 2px 4px 0"><a href="http://colorscripter.com/info#e" target="_blank" style="text-decoration:none;color:white"><span style="font-size:9px;word-break:normal;background-color:#e5e5e5;color:white;border-radius:10px;padding:1px">cs</span></a></td></tr></table></div>
- 외부 침입자가 공격하기 위해서는 사설망의 내부 사설 IP주소를 알아야 하기 때문에 공격이 불가능해지므로 내부 네트워크를 보호함을 위해 생성

## Install
<div class="colorscripter-code" style="color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important; position:relative !important;overflow:auto"><table class="colorscripter-code-table" style="margin:0;padding:0;border:none;background-color:#fafafa;border-radius:4px;" cellspacing="0" cellpadding="0"><tr><td style="padding:6px;border-right:2px solid #e5e5e5"><div style="margin:0;padding:0;word-break:normal;text-align:right;color:#666;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="line-height:130%">1</div><div style="line-height:130%">2</div><div style="line-height:130%">3</div></div></td><td style="padding:6px 0;text-align:left"><div style="margin:0;padding:0;color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="padding:0 6px; white-space:pre; line-height:130%">sudo&nbsp;docker&nbsp;run&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>name&nbsp;mariadb&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>net&nbsp;project<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>h<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>proxy&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>ip&nbsp;<span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">5.</span><span style="color:#0099cc">67</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>p&nbsp;<span style="color:#0099cc">3306</span>:<span style="color:#0099cc">3306</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>v&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>home<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>ubuntu<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>project_H<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>db<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>lib<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>mysql:<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>var<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>lib<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>mysql&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>e&nbsp;MYSQL_ROOT_PASSWORD<span style="color:#0086b3"></span><span style="color:#a71d5d">=</span>root&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>d&nbsp;mariadb:<span style="color:#0099cc">10.</span><span style="color:#0099cc">3</span></div><div style="padding:0 6px; white-space:pre; line-height:130%">sudo&nbsp;docker&nbsp;run&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>d&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>net&nbsp;project<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>h<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>proxy&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>ip&nbsp;<span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">5.</span><span style="color:#0099cc">38</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>name&nbsp;nginx&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>p&nbsp;<span style="color:#0099cc">80</span>:<span style="color:#0099cc">80</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>p&nbsp;<span style="color:#0099cc">443</span>:<span style="color:#0099cc">443</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>restart&nbsp;always&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>v&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>home<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>ubuntu<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>project_H<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>nginx<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>setting<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>file<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>:<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>etc<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>nginx&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>v&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>home<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>nginx:<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>usr<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>share<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>nginx&nbsp;nginx:latest</div><div style="padding:0 6px; white-space:pre; line-height:130%">sudo&nbsp;docker&nbsp;run&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>d&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>net&nbsp;project<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>h<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>proxy&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>ip&nbsp;<span style="color:#0099cc">172.</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>.<span style="color:#0099cc">5.</span><span style="color:#0099cc">12</span>&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>name&nbsp;tomcat&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span><span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>restart&nbsp;always&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">-</span>v&nbsp;<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>home<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>ubuntu<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>project_H<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>tomcat<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>ROOT.war:<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>usr<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span><span style="color:#a71d5d">local</span><span style="color:#a71d5d">/</span>tomcat<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>webapps<span style="color:#0086b3"></span><span style="color:#a71d5d">/</span>ROOT.war&nbsp;tomcat:<span style="color:#0099cc">8.</span><span style="color:#0099cc">5.</span><span style="color:#0099cc">59</span></div></div></td><td style="vertical-align:bottom;padding:0 2px 4px 0"><a href="http://colorscripter.com/info#e" target="_blank" style="text-decoration:none;color:white"><span style="font-size:9px;word-break:normal;background-color:#e5e5e5;color:white;border-radius:10px;padding:1px">cs</span></a></td></tr></table></div>

- docker-compose source 참고  

## Nginx proxy setting
<img width="827" alt="스크린샷 2020-11-14 오후 10 59 01" src="https://user-images.githubusercontent.com/43293666/99148793-1fe22e80-26cd-11eb-8b07-799feeeeeb74.png">

- 프록시 모듈에는 설계를 최적화하는 데 사용할 수 있는 기능이 더 많음
- 이 설정은 여러 번 사용될 수 있기 때문에 location 블록에서 불러서 쓸 수 있도록 별도 구성파일을 분리
#### proxy_set_header 설정을 요약하자면 
- X-Real-IP $remote_addr; #클라이언트의 실제 IP 주소를 X-Real-IP라는 새로운 헤더에 담아 전달.
- X-Forwarded-For $proxy_add_x_forwarded_for; #X-Real-IP과 비슷하지만 클라이언트가 이미 스스로 프록시를 사용하고 있다면 클라이언트의 실제 IP 주소는 X-Forwarded-For라는 요청 헤더에 들어 있을 것 즉 통신에 사용하는 소켓과 클라이언트의 원래 IP 주소 모두를 뒷단 서버에 확실히 전달.
- Host $http_host; #엔진엑스가 클라이언트 요청의 원래 Host 값을 대신 사용하도록 설정.

## Tomcat + MariaDB
<img width="827" alt="스크린샷 2020-11-14 오후 11 14 24" src="https://user-images.githubusercontent.com/43293666/99149077-3ee1c000-26cf-11eb-9de0-13b7141a1341.png">

- context 우선순위 고려
1. server.xml  (권장하지 않음)

2. $CATALINA_HOME/conf/context.xml  (전역적인 설정)

3. /META_INF/context.xml (특정 호스트)

4. $CATALINA_HOME/conf/[enginename]/[hostname]/context.xml.default (위와 마찬가지)


<img width="824" alt="스크린샷 2020-11-12 오후 11 47 12" src="https://user-images.githubusercontent.com/43293666/99178999-82ced680-275c-11eb-8529-54bb7f250540.png">

![image](https://user-images.githubusercontent.com/43293666/99150579-f7603180-26d8-11eb-8873-acf29bd72777.png)

- img upload test success
 
--------------------------------------------------------------------------------------------------------------------------------------------------------
# Docker Monitering (Data Dog)
<img width="827" alt="스크린샷 2020-11-14 오후 11 30 43" src="https://user-images.githubusercontent.com/43293666/99149449-6c2f6d80-26d1-11eb-9f8c-e1a7e9f9a2f3.png">

- Datadog 모니터링 실행 항목 확인 

![스크린샷 2020-11-14 오후 11 56 48](https://user-images.githubusercontent.com/43293666/99150067-5754d900-26d5-11eb-87ef-8e658a0dc2c6.png)

![스크린샷 2020-11-16 오전 12 20 26](https://user-images.githubusercontent.com/43293666/99188871-8fc1e900-27a1-11eb-8595-a6fb43cc271d.png)

- Server의 CPU/메모리 사용량, 레이턴시 및 네트워크 등 파악
- 컨테이너에 떠 있는 프로세스, 네트워크 트래픽 사용량, 파일시스템 사용량등의 정보를 확인

--------------------------------------------------------------------------------------------------------------------------------------------------------
# Test, Issue Trouble shooting

## Issue 1 - Jenkins capacity is expected to be exceeded
#### Trouble
- jenkins의 용량이 너무 비대해짐에 따른 문제 
- 나중에 job이 많아 지고, job 마다 설정이 달라지며, 써야하는 Tool들의 버전까지 달라지는 상황이 나옴 
#### Shooting
- jenkins worker(slave) 사용 (가장 대중적인 방법은 Jenkins 의 Worker(slave)를 ECS, Fargate, Codebuild 등을 통해서 구현, AWS아닐 경우 k8s 같은 것도 가능 - [Project Z](https://github.com/hm98127/project_z) 에서 구현 예정)
- 매 Job 이 실행될때마다 내가 지정한 Docker image 로 (node, pod 등 아무거나) 새로운 환경으로 작업을 실행하는 것
  
## Issue 2 - 413 Request Entity Too Large error
#### Trouble
<img width="1295" alt="스크린샷 2020-11-09 오후 4 50 33" src="https://user-images.githubusercontent.com/43293666/99178679-e6ef9b80-2758-11eb-81b7-6d41b9474305.png">

- nginx로 reverse proxy 를 사용할 때, 용량이 큰 파일을 업로드하면 413 Request Entity Too Large 라는 메시지를 볼 수 있는 문제

#### Shooting
- client_max_body_size 설정 때문이고, 너무 큰 사이즈의 request를 보내지 못 하도록 제한을 걸 수 있다. 기본값은 1MB이다. request의 Content-Length 헤더값이 여기 설정된 값을 넘을 수 없다. POST나 PUT 등의 request 사이즈 제한을 할 수도 있지만, 보통 악의적으로 큰 용량의 파일을 업로드해서 디스크를 가득 채우는 경우를 방지하는데 사용
<div class="colorscripter-code" style="color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important; position:relative !important;overflow:auto"><table class="colorscripter-code-table" style="margin:0;padding:0;border:none;background-color:#fafafa;border-radius:4px;" cellspacing="0" cellpadding="0"><tr><td style="padding:6px;border-right:2px solid #e5e5e5"><div style="margin:0;padding:0;word-break:normal;text-align:right;color:#666;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="line-height:130%">1</div><div style="line-height:130%">2</div><div style="line-height:130%">3</div><div style="line-height:130%">4</div><div style="line-height:130%">5</div><div style="line-height:130%">6</div></div></td><td style="padding:6px 0;text-align:left"><div style="margin:0;padding:0;color:#010101;font-family:Consolas, 'Liberation Mono', Menlo, Courier, monospace !important;line-height:130%"><div style="padding:0 6px; white-space:pre; line-height:130%">http&nbsp;{</div><div style="padding:0 6px; white-space:pre; line-height:130%">&nbsp;&nbsp;&nbsp;&nbsp;client_max_body_size&nbsp;5M;</div><div style="padding:0 6px; white-space:pre; line-height:130%">&nbsp;</div><div style="padding:0 6px; white-space:pre; line-height:130%">&nbsp;&nbsp;&nbsp;&nbsp;...</div><div style="padding:0 6px; white-space:pre; line-height:130%">}</div><div style="padding:0 6px; white-space:pre; line-height:130%">&nbsp;</div></div></td><td style="vertical-align:bottom;padding:0 2px 4px 0"><a href="http://colorscripter.com/info#e" target="_blank" style="text-decoration:none;color:white"><span style="font-size:9px;word-break:normal;background-color:#e5e5e5;color:white;border-radius:10px;padding:1px">cs</span></a></td></tr></table></div>

- nginx.conf 파일에서 http, server, location에 설정이 가능
- 즉 client_max_body_size 값을 늘려주면 해결

## Issue 3 - AWS Certificate Manager 검증 지연 발생
#### Trouble
![스크린샷 2020-11-08 오전 2 45 42](https://user-images.githubusercontent.com/43293666/99178886-20290b00-275b-11eb-842b-4979603d7daa.png)

- 검증 보류 문제가 발생 

#### Shooting
<img width="1283" alt="스크린샷 2020-11-13 오후 7 53 26" src="https://user-images.githubusercontent.com/43293666/99179344-0e963200-2760-11eb-9a9f-f9f99a91e073.png">

- Certificate Manager에서 발급해준 CNAME 레코드를 작성하고 10 ~ 15분 정도 기다리면 해결

## Issue 4 - Easily build Cloud Container
#### Trouble
- 클라우드에서도 온프레미스에서 하듯이 docker 설치에 Container들을 일일히 만들어야 되는 문제
#### Shooting
![스크린샷 2020-11-15 오전 12 51 56](https://user-images.githubusercontent.com/43293666/99151201-c5e96500-26dc-11eb-999c-7148ea95997d.png)
- aws ECS를 사용하면 말도안되게 바로 구축가능 (AMI와 같이쓴다면.)