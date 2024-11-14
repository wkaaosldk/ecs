# ECS 클러스터 생성
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-fargate-cluster"
}

# 기존 ECS 태스크 실행 역할 데이터 소스
data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

# ECS Fargate 작업 정의
resource "aws_ecs_task_definition" "ecsdemo_frontend_task" {
  family                   = "ecsdemo-frontend"
  cpu                      = "1024"
  memory                   = "4096"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name             = "ecs-sample"
      image            = "nginx"
      cpu              = 512
      memory           = 1024
      essential        = true
      portMappings     = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# ECS 서비스 생성
resource "aws_ecs_service" "ecsdemo_frontend_service" {
  name            = "ecsdemo-frontend-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecsdemo_frontend_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.public_subnet_id_1, var.public_subnet_id_2]
    assign_public_ip = true
    security_groups = [var.security_group_id]
  }
}

# 기존 IAM 역할에 정책 첨부 (필요한 경우)
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = data.aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}