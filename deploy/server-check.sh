#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  ./deploy/server-check.sh <user@host> [-p port]
  ./deploy/server-check.sh --local

Examples:
  ./deploy/server-check.sh root@1.2.3.4
  ./deploy/server-check.sh deploy@1.2.3.4 -p 22
USAGE
}

TARGET=""
PORT="22"
LOCAL="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --local)
      LOCAL="true"
      shift
      ;;
    -p|--port)
      PORT="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
        shift
      else
        echo "Unknown argument: $1" >&2
        usage
        exit 1
      fi
      ;;
  esac
done

if [[ "$LOCAL" != "true" ]]; then
  if [[ -z "$TARGET" ]]; then
    usage
    exit 1
  fi

  echo "Connecting to $TARGET on port $PORT..."
  ssh -p "$PORT" "$TARGET" 'bash -s' -- --local < "$0"
  exit $?
fi

ok() {
  printf '[OK] %s\n' "$1"
}

warn() {
  printf '[WARN] %s\n' "$1"
}

info() {
  printf '[INFO] %s\n' "$1"
}

section() {
  printf '\n== %s ==\n' "$1"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

check_service() {
  local name="$1"
  if have systemctl; then
    if systemctl is-active --quiet "$name"; then
      ok "$name is active"
    elif systemctl list-unit-files "$name.service" >/dev/null 2>&1; then
      warn "$name is installed but not active"
    else
      warn "$name service not found"
    fi
  else
    warn "systemctl not found, cannot check $name service"
  fi
}

section "System"
info "Host: $(hostname)"
info "User: $(id -un)"
info "Kernel: $(uname -srmo)"
if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  info "OS: ${PRETTY_NAME:-unknown}"
fi
if have uptime; then
  info "Uptime: $(uptime -p 2>/dev/null || uptime)"
fi

section "Resources"
if have free; then
  free -h
else
  warn "free not found"
fi
df -h /

section "Core Commands"
for cmd in sudo git rsync curl nginx docker ufw ss; do
  if have "$cmd"; then
    ok "$cmd: $(command -v "$cmd")"
  else
    warn "$cmd not found"
  fi
done

section "Nginx"
if have nginx; then
  nginx -v 2>&1
  check_service nginx
  if sudo -n nginx -t >/tmp/nginx-check.out 2>&1; then
    ok "nginx config test passed"
  else
    warn "nginx config test failed or needs sudo password"
    sed 's/^/  /' /tmp/nginx-check.out 2>/dev/null || true
  fi
else
  warn "nginx is not installed"
fi

section "Docker"
if have docker; then
  docker --version
  if docker info >/dev/null 2>&1; then
    ok "docker daemon is reachable by current user"
  else
    warn "docker exists, but current user cannot reach daemon or daemon is stopped"
  fi
else
  warn "docker is not installed"
fi

section "Network Ports"
if have ss; then
  ss -tulpen 2>/dev/null | grep -E ':(22|80|443)\b' || warn "No listeners found on 22/80/443"
else
  warn "ss not found"
fi
info "Tencent Cloud security group rules cannot be verified from inside the server."

section "Deploy Directory"
if [[ -d /var/www/nitrene-site ]]; then
  ok "/var/www/nitrene-site exists"
  ls -ld /var/www/nitrene-site /var/www/nitrene-site/current 2>/dev/null || true
else
  warn "/var/www/nitrene-site does not exist yet"
fi

section "Summary"
info "If nginx, git, rsync, and deploy directory are ready, GitHub Actions can publish this site."
