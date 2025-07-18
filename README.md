# Tor + Privoxy + NGINX Load-Balancing Proxy

This project sets up a **rotating HTTP proxy** endpoint using multiple [Tor](https://www.torproject.org/) circuits, [Privoxy](https://www.privoxy.org/), and a unified [NGINX](https://nginx.org/) load-balanced interface.

> 🔐 Supports IP-leak prevention and Zero Trust secure tunneling options.

---

## 🧩 Architecture

```

\[Your App or System Proxy]
|
v
\[NGINX TCP Load Balancer :8888]
|
v
\[Privoxy @ 8111-8113] --> \[Tor @ 9051-9053]

````

---

## 🛠️ Installation & Setup

### 📦 Install dependencies

```bash
sudo apt update
sudo apt install tor privoxy nginx-full
````

---

### 📁 File Placement

#### 1. **Privoxy configs**

Place each custom Privoxy config file in:

```bash
sudo mkdir -p /etc/privoxy/privoxy.d/
sudo cp privoxy_config_example /etc/privoxy/privoxy.d/config8111
sudo cp privoxy_config_example /etc/privoxy/privoxy.d/config8112
sudo cp privoxy_config_example /etc/privoxy/privoxy.d/config8113
```

🔧 Edit each to forward to the correct Tor SOCKS port:

* `config8111` → `forward-socks5t / 127.0.0.1:9051 .`
* `config8112` → `forward-socks5t / 127.0.0.1:9052 .`
* `config8113` → `forward-socks5t / 127.0.0.1:9053 .`

#### 2. **NGINX config**

Place the stream configuration in `/etc/nginx`:

```bash
sudo cp nginx.conf.example /etc/nginx/privoxy_stream.conf
```

Open your main config and include it at top level:

```bash
sudo nano /etc/nginx/nginx.conf
```

Add this line **outside of `http {}`**:

```nginx
include /etc/nginx/privoxy_stream.conf;
```

---

## ▶️ Running the Services

### 🧯 Start multiple Tor instances (with separate SOCKSPorts)

Add this to your `/etc/tor/torrc`:

```ini
SocksPort 9051
SocksPort 9052
SocksPort 9053
```

Then restart Tor:

```bash
sudo systemctl restart tor
```

---

### 🚀 Start Privoxy Instances

Run each instance manually:

```bash
sudo privoxy --daemon /etc/privoxy/privoxy.d/config8111
sudo privoxy --daemon /etc/privoxy/privoxy.d/config8112
sudo privoxy --daemon /etc/privoxy/privoxy.d/config8113
```

You can also create `systemd` units if you want them to run persistently (ask if you need help with this).

---

### 🔁 Start NGINX TCP Load Balancer

Test and reload:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

Make sure port 8888 is listening:

```bash
ss -tulnp | grep 8888
```

---

## 🧪 Test

```bash
curl --proxy http://127.0.0.1:8888 https://icanhazip.com
```

Repeat to observe exit IP rotation via Tor circuits.

---

## 🛡 IP Leak Prevention

1. Export proxy variables for CLI tools:

```bash
export http_proxy=http://127.0.0.1:8888
export https_proxy=http://127.0.0.1:8888
```

2. Drop all non-Tor outbound traffic with `iptables` (optional):

```bash
sudo iptables -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner privoxy -j DROP
sudo iptables -A OUTPUT -p tcp --dport 443 -m owner ! --uid-owner privoxy -j DROP
```

3. Use `dns=none` or disable local DNS in apps to avoid leaks.

---

## 🔐 Optional: Zero Trust Tunnel

To securely expose your proxy over the internet:

* Use [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/) or [Tailscale Funnel](https://tailscale.com/funnel)
* Protect access with:

  * Basic Auth / Client certs
  * IP allowlists
  * ACLs or device rules

This makes your proxy **Zero Trust** compatible — perfect for remote access, censorship circumvention, or bot automation.

---

## 📁 Included Files

* `nginx.conf.example`: NGINX stream config with TCP load balancing
* `privoxy_config_example`: Base Privoxy config template
* `test_random_proxy.sh`: Shell script to test random proxy manually
* `README.md`: This documentation

---

## ✅ Next Ideas

* [ ] Add systemd services for Privoxy instances
* [ ] Dockerize the full stack
* [ ] Log Tor exit IPs per request
* [ ] Support SOCKS5 proxy output via chained Tor

---

## 📜 License

MIT — Use freely, anonymize responsibly. Be ethical.

