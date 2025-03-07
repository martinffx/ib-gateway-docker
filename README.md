# ib-gateway-docker

This builds a Docker image with the latest version of [Interactive Brokers](https://interactivebrokers.com)' [IB Gateway](https://www.interactivebrokers.com/en/index.php?f=5041), the modern [IbcAlpha/IBC](https://github.com/IbcAlpha/IBC) for automation, and a VNC server for debugging purposes.

**Currently, the API is only enabled in read-only mode**, for testing purposes.

## Building

```sh
make build
make deploy
```

## Running

```sh
make run
```

This will expose port 4002 for the TWS API (usable with, e.g., [ib_insync](https://github.com/erdewit/ib_insync)) and 5900 for VNC (with default password `1358`). **Neither are secure for public internet access**, as the expectation is that private, secure services will sit on top and be the only open interface to the internet.

### VNC

```sh
make vnc
```

The password is `password`
