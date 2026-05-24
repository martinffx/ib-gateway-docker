vnc: up
	open vnc://localhost:5900

build:
	docker-compose build ib-gateway

up:
	docker-compose up -d ib-gateway

down:
	docker-compose down

logs:
	docker-compose logs -f ib-gateway

shell:
	docker-compose run -it ib-gateway /bin/bash

deploy:
	docker push martinffx/ib-gateway-docker
