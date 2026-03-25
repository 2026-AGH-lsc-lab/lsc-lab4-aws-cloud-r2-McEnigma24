# source this file #


unset http_proxy
unset https_proxy
unset HTTP_PROXY
unset HTTPS_PROXY



# sudo bash deploy/01-ecr.sh       # to robi problemy, bo potem SUDO user nie ma tych samych credentiali co wmackowiak


# # więc dodajemy wmackowiak do grupy uprzywilejowanych dockerowców #
# sudo usermod -aG docker wmackowiak

# # odświeżamy uprawnienia #
# newgrp docker

# # odpalamy
# bash deploy/01-ecr.sh




# jakieś Dockerowe -> że niby mi odebrało prawa dostępu do tego folderu #
# sudo chown -R $USER:$USER .



# bash deploy/02-lambda-zip.sh

# Creating Function URL...
# {
#     "Statement": "{\"Sid\":\"FunctionURLInvoke\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"lambda:InvokeFunctionUrl\",\"Resource\":\"arn:aws:lambda:us-east-1:211125690777:function:lsc-knn-zip\",\"Condition\":{\"StringEquals\":{\"lambda:FunctionUrlAuthType\":\"AWS_IAM\"}}}"
# }
# === Lambda Zip done. Function URL: https://qdkyggvbi4ppwabu3kdgubrrjq0qppdz.lambda-url.us-east-1.on.aws/ ===


# {"statusCode": 200, "headers": {"Content-Type": "application/json", "X-Server-Time-Ms": "72.104", "X-Instance-Id": "2026/03/25/[$LATEST]04a9c008096346a9906053e5b435fc37", "X-Cold-Start": "true"}, "body": "{\"results\": [{\"index\": 35859, \"distance\": 12.001459121704102}, {\"index\": 24682, \"distance\": 12.059946060180664}, {\"index\": 35397, \"distance\": 12.487079620361328}, {\"index\": 20160, \"distance\": 12.489519119262695}, {\"index\": 30454, \"distance\": 12.499402046203613}], \"query_time_ms\": 72.104, \"instance_id\": \"2026/03/25/[$LATEST]04a9c008096346a9906053e5b435fc37\", \"cold_start\": true}"}





# bash deploy/03-lambda-container.sh

# Config loaded: ACCOUNT_ID=211125690777, REGION=us-east-1
# === Step 3: Lambda Container Image Deployment ===
# Creating Lambda function (container)...
# arn:aws:lambda:us-east-1:211125690777:function:lsc-knn-container
# Waiting for function to become active...
# Creating Function URL...
# {
#     "Statement": "{\"Sid\":\"FunctionURLInvoke\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"lambda:InvokeFunctionUrl\",\"Resource\":\"arn:aws:lambda:us-east-1:211125690777:function:lsc-knn-container\",\"Condition\":{\"StringEquals\":{\"lambda:FunctionUrlAuthType\":\"AWS_IAM\"}}}"
# }
# === Lambda Container done. Function URL: https://4m52txfc4nrqogxestm6m3rq5u0eiblq.lambda-url.us-east-1.on.aws/ ===

# {"statusCode": 200, "headers": {"Content-Type": "application/json", "X-Server-Time-Ms": "75.467", "X-Instance-Id": "2026/03/25/[$LATEST]c1e34e40d61841e39c94558abe85ba23", "X-Cold-Start": "true"}, "body": "{\"results\": [{\"index\": 35859, \"distance\": 12.001459121704102}, {\"index\": 24682, \"distance\": 12.059946060180664}, {\"index\": 35397, \"distance\": 12.487079620361328}, {\"index\": 20160, \"distance\": 12.489519119262695}, {\"index\": 30454, \"distance\": 12.499402046203613}], \"query_time_ms\": 75.467, \"instance_id\": \"2026/03/25/[$LATEST]c1e34e40d61841e39c94558abe85ba23\", \"cold_start\": true}"}





# bash deploy/04-fargate.sh

# Task SG: sg-0327f2b1bf59eac28
# Creating ECS cluster...
# arn:aws:ecs:us-east-1:211125690777:cluster/lsc-knn-cluster
# Creating log group...
# Registering task definition...
# Task definition: arn:aws:ecs:us-east-1:211125690777:task-definition/lsc-knn-task:1
# Creating ALB...
# ALB ARN: arn:aws:elasticloadbalancing:us-east-1:211125690777:loadbalancer/app/lsc-knn-alb/285aa5e84ceed543
# ALB DNS: lsc-knn-alb-156229759.us-east-1.elb.amazonaws.com
# Creating target group...
# Target Group: arn:aws:elasticloadbalancing:us-east-1:211125690777:targetgroup/lsc-knn-tg/a678ee019b180604
# Creating ALB listener...
# Listener: arn:aws:elasticloadbalancing:us-east-1:211125690777:listener/app/lsc-knn-alb/285aa5e84ceed543/be1a72c7c9902778
# Creating ECS service...
# arn:aws:ecs:us-east-1:211125690777:service/lsc-knn-cluster/lsc-knn-service
# Waiting for ECS service to stabilize (this may take 1-2 minutes)...
# === Fargate done. ALB URL: http://lsc-knn-alb-156229759.us-east-1.elb.amazonaws.com ===

# curl -X POST -H "Content-Type: application/json" -d @loadtest/query.json http://lsc-knn-alb-156229759.us-east-1.elb.amazonaws.com/search
# {"instance_id":"ip-172-31-57-45.ec2.internal","query_time_ms":24.254,"results":[{"distance":12.001459121704102,"index":35859},{"distance":12.059946060180664,"index":24682},{"distance":12.487079620361328,"index":35397},{"distance":12.489519119262695,"index":20160},{"distance":12.499402046203613,"index":30454}]}




# bash deploy/05-ec2-app.sh

# Security Group: sg-06916e44096017107
# Finding latest Amazon Linux 2023 AMI...
# AMI: ami-0c421724a94bba6d6
# Checking for LabInstanceProfile...
# Instance Profile: LabInstanceProfile
# Launching EC2 instance...
# Instance ID: i-0622ddfe5beb41997
# Waiting for instance to be running...
# === EC2 App done. Public IP: 54.227.87.237 ===
# URL: http://54.227.87.237:8080
# NOTE: Wait ~2 minutes for Docker to pull and start the container.
# Test with: curl -X POST -H 'Content-Type: application/json' -d @loadtest/query.json http://54.227.87.237:8080/search

# curl -X POST -H 'Content-Type: application/json' -d @loadtest/query.json http://54.227.87.237:8080/search
# {"instance_id":"95eceda828ed","query_time_ms":23.636,"results":[{"distance":12.001459121704102,"index":35859},{"distance":12.059946060180664,"index":24682},{"distance":12.487079620361328,"index":35397},{"distance":12.489519119262695,"index":20160},{"distance":12.499402046203613,"index":30454}]}








# bash loadtest/scenario-a.sh "$LAMBDA_ZIP_URL" "$LAMBDA_CONTAINER_URL"

# wmackowiak@C-5CG2342Q9H:~/MY_STUFF/AI_AGH/sem_1$ aws logs filter-log-events --log-group-name /aws/lambda/lsc-knn-zip --filter-pattern 'Init Duration' --start-time $(date -d '30 minutes ago' +%s000) --query 'events[*].message' --output text
# REPORT RequestId: 10a1d94e-4bbc-45ea-a9ea-43c82d0708b1  Duration: 73.14 ms      Billed Duration: 683 ms Memory Size: 512 MB     Max Memory Used: 144 MB Init Duration: 609.74 ms
# XRAY TraceId: 1-69c452d5-46c6fc382fe223c877e7b654       SegmentId: 2b3291ed076d4c3b     Sampled: true

# wmackowiak@C-5CG2342Q9H:~/MY_STUFF/AI_AGH/sem_1$ aws logs filter-log-events --log-group-name /aws/lambda/lsc-knn-container --filter-pattern 'Init Duration' --start-time $(date -d '30 minutes ago' +%s000) --query 'events[*].message' --output text
# REPORT RequestId: bd546205-cea9-4fdc-9ea0-36d40ed28484  Duration: 85.66 ms      Billed Duration: 719 ms Memory Size: 512 MB     Max Memory Used: 142 MB Init Duration: 632.83 ms
# XRAY TraceId: 1-69c457a4-39e9f42e624daa2f23d1eda2       SegmentId: 610a6c19ee153c22     Sampled: true

# wmackowiak@C-5CG2342Q9H:~/MY_STUFF/AI_AGH/sem_1$ aws logs describe-log-groups --log-group-name-prefix "/aws/lambda/lsc-knn" \
#     --query 'logGroups[*].logGroupName' --output text
# /aws/lambda/lsc-knn-container   /aws/lambda/lsc-knn-zip











