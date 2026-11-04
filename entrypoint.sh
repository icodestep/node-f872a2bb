#!/bin/sh
# VLESS + WS inbound, for platforms whose edge terminates TLS and
# forwards plain HTTP to $PORT. Corrected for Xray 26.x: VLESS clients
# must NOT carry an "encryption" field; settings keeps "decryption": "none".
set -eu

UUID="${UUID:-00000000-0000-0000-0000-000000000000}"
PORT="${PORT:-8080}"
WSPATH="${WSPATH:-/ws}"

if [ "$UUID" = "00000000-0000-0000-0000-000000000000" ] || [ "$UUID" = "CHANGE_ME" ]; then
  echo "WARNING: set a real UUID env before handing out client links" >&2
fi

case "$WSPATH" in
  /*) ;;
  *) WSPATH="/$WSPATH" ;;
esac

CFG=/tmp/xray-config.json
cat > "$CFG" <<JSON
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": { "path": "${WSPATH}" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
JSON

echo "starting xray on port ${PORT} path ${WSPATH}"
exec /usr/local/bin/xray run -c "$CFG"
