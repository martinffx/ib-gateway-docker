vnc: start
	open vnc://localhost:5900

build:
	docker-compose build ib-gateway

up:
	docker-compose up -d ib-gateway

down:
	docker-compose down

deploy:
	docker push martinffx/ib-gateway-docker
