TWS_VERSION = $(shell cat .tws-version 2>/dev/null)
IBC_VERSION = $(shell grep -o 'IBCLinux-[0-9.]*' Dockerfile | sed 's/IBCLinux-//' | sed 's/\.$$//')
VERSION = v$(TWS_VERSION)-ibc$(IBC_VERSION)

vnc: up
	open vnc://localhost:5900

build:
	docker-compose build ib-gateway
	@docker run --rm martinffx/ib-gateway-docker cat /home/docker/.tws-version > .tws-version

up:
	docker-compose up -d ib-gateway

down:
	docker-compose down

logs:
	docker-compose logs -f ib-gateway

shell:
	docker-compose run -it ib-gateway /bin/bash

release: build
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "Error: Working tree is dirty. Commit or stash changes first."; \
		exit 1; \
	fi
	@if [ "$$(git branch --show-current)" != "main" ]; then \
		echo "Error: Must be on main branch to release."; \
		exit 1; \
	fi
	@if git rev-parse "$(VERSION)" >/dev/null 2>&1; then \
		echo "Error: Tag $(VERSION) already exists."; \
		exit 1; \
	fi
	@echo "Releasing $(VERSION)"
	git tag -a $(VERSION) -m "Release $(VERSION)"
	git tag -f -a latest -m "Latest release"
	git push origin $(VERSION)
	git push -f origin latest
