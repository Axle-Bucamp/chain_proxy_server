# 🛡️ Multi-hop Anonymity Proxy Chain: Tor + Privoxy + ProtonVPN + NGINX

This project provides a secure, containerized anonymity pipeline using:

- 🔄 **Tor cluster** (replicated, containerized, pluggable obfs4 bridges supported)
- 🧰 **Privoxy** (per-Tor exit)
- 🌐 **NGINX stream proxy** (to chain Tor→Privoxy→ProtonVPN)
- 🛡️ **ProtonVPN outproxy** via tunnel-based Privoxy
- 📈 Optional: Prometheus, Grafana, Watchtower

---

## 📦 Architecture

```

\[User] → \[NGINX Proxy] → \[Tor Cluster] → \[Privoxy Cluster] → \[Privoxy (ProtonVPN)] → \[Internet]

````

All services run through `docker-compose`, replicating Tor + Privoxy nodes and chaining ProtonVPN as a secured egress tunnel.

---

## 🚀 Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/Axle-Bucamp/chain_proxy_server
cd chain_proxy_server
````

---

### 2. Prepare Your `.env` File

Create a `.env` file in the root folder:

```env
EMAIL=you@example.com
OR_PORT=9001
PT_PORT=9002
NICKNAME=BridgeObfs4Node

GF_SECURITY_ADMIN_USER=admin
GF_SECURITY_ADMIN_PASSWORD=changeme

WATCHTOWER_CLEANUP=true
WATCHTOWER_LABEL_ENABLE=true
```

> ProtonVPN credentials must also be created as a Docker secret named `protonvpn`.

---

### 3. Run the System

```bash
docker compose up -d --scale tor=3 --scale privoxy=3
```

This runs:

* 3x Tor nodes (`dockurr/tor`)
* 3x Privoxy nodes (each mapped to a Tor exit)
* 1x ProtonVPN tunnel (`genericmale/protonvpn`)
* 1x final Privoxy egress via VPN
* 1x NGINX stream proxy chaining everything

---

### 4. Test Your Connection

Test that your IP is **not leaking**:

* 🔎 [https://whatismyipaddress.com/](https://whatismyipaddress.com/)
* 🧪 [https://dnsleaktest.com/](https://dnsleaktest.com/)
* 🔐 [https://privacy.net/analyzer/](https://privacy.net/analyzer/)

```bash
curl --proxy http://localhost:8888 https://api.ipify.org
```

✅ This should return your ProtonVPN IP — not your ISP or Tor IP.

---

## 🔐 Enhanced Security Tips

* **IP Leak Prevention**: Always run this with `--network host` or DNS-secured Docker bridge
* **Zero Trust Tunnel**: ProtonVPN adds exit encryption after multiple Tor circuits
* **Obfs4 Support**: Deploy obfs4-bridge to bypass censorship
* **DNS Hardened**: Internal DNS disabled; relies on Tor-resolved or VPN-secured

---

## 📊 Optional Observability Stack

You can optionally enable:

* [Prometheus](https://prometheus.io/)
* [Grafana](https://grafana.com/)
* [Watchtower](https://github.com/containrrr/watchtower)

These services monitor uptime, restarts, and connectivity across your chain.

---

## 📁 Directory Layout

```bash
.
├── docker-compose.yml
├── nginx/
│   └── nginx.conf
├── privoxy/
│   ├── config1
│   ├── config2
│   └── config3
├── torrc.d/
│   ├── tor1.conf
│   ├── tor2.conf
│   └── tor3.conf
├── .env
└── README.md
```

---

## ✅ Status

* [x] Tor replication
* [x] Privoxy routing per Tor node
* [x] NGINX chaining
* [x] Final ProtonVPN tunnel
* [x] Leak tested

---

### ✨ Credits

* [Dockurr Tor](https://hub.docker.com/r/dockurr/tor)
* [Privoxy](https://www.privoxy.org/)
* [ProtonVPN Docker](https://hub.docker.com/r/genericmale/protonvpn)
* [The Tor Project](https://www.torproject.org/)
* [Grafana Labs](https://grafana.com/)

