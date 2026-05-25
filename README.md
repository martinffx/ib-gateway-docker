# ib-gateway-docker

A Docker image running [Interactive Brokers Gateway](https://www.interactivebrokers.com/en/index.php?f=5041) with [IbcAlpha/IBC](https://github.com/IbcAlpha/IBC) for headless automation and a VNC server for debugging.

## Quick Start

1. Copy and configure your credentials:

```sh
cp .env.example .env
# Edit .env with your IB paper trading credentials
```

2. Start the container:

```sh
make up
```

This exposes:
- **Port 4002** — TWS API for programmatic trading
- **Port 5900** — VNC for debugging (password: `password`)

3. Connect with [ib_insync](https://github.com/erdewit/ib_insync):

```python
from ib_insync import IB

ib = IB()
ib.connect('localhost', 4002, clientId=1)

# Example: get Apple stock details
aapl = Stock('AAPL', 'SMART', 'USD')
ib.qualifyContracts(aapl)
print(aapl)

ib.disconnect()
```

## Configuration

Set these in your `.env` file:

| Variable | Description |
|----------|-------------|
| `TWSUSERID` | IB account username |
| `TWSPASSWORD` | IB account password |
| `TRADING_MODE` | `paper` (default) or `live` |
| `VNC_PASSWORD` | VNC server password |

## Building & Releasing

Build a new image:

```sh
make build
```

Create a versioned release (from `main` branch with a clean working tree):

```sh
make release
```

This tags the image as `v<TWS_VERSION>-ibc<IBC_VERSION>` and pushes it to Docker Hub via GitHub Actions.

## Security

⚠️ **This container is not secure for public internet access.**

- Never commit `.env` — it is `.gitignore`d by default
- Change the default VNC password (`password`) before exposing port 5900
- Only run on trusted networks; place a secure reverse proxy or VPN in front if remote access is needed
- Port 4002 (TWS API) and 5900 (VNC) have no built-in authentication beyond the VNC password
