vnc: start
	open vnc://localhost:5900

build:
	docker-compose build ib-gateway

start:
	docker-compose up -d ib-gateway

deploy:
	docker push martinffx/ib-gateway-docker
