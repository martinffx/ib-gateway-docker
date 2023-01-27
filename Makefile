build:
	podman build -t martinffx/ib-gateway-docker --arch amd64 .

run:
	podman run -p 4002:4002 -p 5900:5900 \
	    --env TWSUSERID=$TWSUSERID \
	    --env TWSPASSWORD=$TWSPASSWORD \
	    martinffx/ib-gateway-docker:latest

deploy:
	podman push martinffx/ib-gateway-docker
