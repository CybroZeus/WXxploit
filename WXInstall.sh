#!/usr/bin/env bash

# WXxploit Installer
# GitHub: https://github.com/CybroZeus
# Telegram: https://t.me/CybroZeus
# Developer: CybroZeus

set -euo pipefail

BOLD=$'\033[1m'
RESET=$'\033[0m'
RED=$'\033[1;31m'
BLUE=$'\033[1;34m'
CYAN=$'\033[1;36m'
GREEN=$'\033[1;32m'
YELLOW=$'\033[1;33m'

clear

if [[ $EUID -ne 0 ]]; then
  echo -e "${RED}${BOLD}[-]${RESET} Please run as root."
  exit 1
fi

echo -e "${RED}${BOLD}"
cat << "WXInstall"
 __      ______  ___ ___                 __          __   __   
/  \    /  \   \/  /|   | ____   _______/  |______  |  | |  |  
\   \/\/   /\     / |   |/    \ /  ___/\   __\__  \ |  | |  |  
 \        / /     \ |   |   |  \\___ \  |  |  / __ \|  |_|  |__
  \__/\  / /___/\  \|___|___|  /____  > |__| (____  /____/____/
       \/        \_/         \/     \/            \/           

                      WXxploit Installer
WXInstall
echo -e "${RESET}"

echo -e "${CYAN}${BOLD}[*]${RESET} ${RED}${BOLD}WXxploit${RESET} installer started..."

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"

if [ -f "$SCRIPT_PATH" ]; then
  chmod +x "$SCRIPT_PATH" 2>/dev/null || true
fi

find . -maxdepth 1 -type f -name "*.sh" -exec chmod +x {} \;

for p in "WXxploit.py"; do
  [ -f "$p" ] && chmod +x "$p" 2>/dev/null || true
done

echo -e "${BLUE}${BOLD}[*]${RESET} Updating package lists..."

if ! apt-get update -y >/dev/null 2>&1; then
  echo -e "${YELLOW}${BOLD}[!]${RESET} apt-get update failed — retrying..."
  apt-get update || { echo -e "${RED}${BOLD}[-]${RESET} apt-get update failed."; exit 1; }
fi

echo -e "${BLUE}${BOLD}[*]${RESET} Installing required packages..."

apt-get install -y python3 python3-venv python3-pip build-essential wget git >/dev/null 2>&1 || {
  echo -e "${YELLOW}${BOLD}[!]${RESET} Some packages failed, retrying..."
  apt-get install -y python3 python3-venv python3-pip build-essential wget git || {
    echo -e "${RED}${BOLD}[-]${RESET} Package installation failed."
    exit 1
  }
}

declare -A PKGS
PKGS[metasploit-framework]=msfconsole

check_and_install_pkg() {

  local pkg="$1"
  local cmd="$2"

  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "${GREEN}${BOLD}[+]${RESET} $pkg already installed."
    return 0
  fi

  echo -e "${YELLOW}${BOLD}[!]${RESET} $pkg not found — installing..."

  if ! apt-get install -y "$pkg"; then
    echo -e "${RED}${BOLD}[-]${RESET} Installation of $pkg failed."
    return 1
  fi

  if command -v "$cmd" >/dev/null 2>&1; then
    echo -e "${GREEN}${BOLD}[+]${RESET} $pkg installed successfully."
  else
    echo -e "${YELLOW}${BOLD}[!]${RESET} $pkg installed but command missing."
  fi

}

echo -e "${BLUE}${BOLD}[*]${RESET} Checking & installing packages..."

for pkg in "${!PKGS[@]}"; do
  check_and_install_pkg "$pkg" "${PKGS[$pkg]}" || true
done

VENV_DIR="venv"

if [ -d "$VENV_DIR" ]; then
  echo -e "${BLUE}${BOLD}[*]${RESET} Virtualenv exists, reusing..."
else
  echo -e "${BLUE}${BOLD}[*]${RESET} Creating Python virtual environment..."
  python3 -m venv "$VENV_DIR" || {
    echo -e "${RED}${BOLD}[-]${RESET} Failed to create virtualenv."
    exit 1
  }
fi

source "$VENV_DIR/bin/activate"

echo -e "${BLUE}${BOLD}[*]${RESET} Upgrading pip..."

python3 -m pip install --upgrade pip >/dev/null 2>&1 || {
  echo -e "${YELLOW}${BOLD}[!]${RESET} pip upgrade warning..."
  python3 -m pip install --upgrade pip || {
    echo -e "${RED}${BOLD}[-]${RESET} Pip upgrade failed."
    exit 1
  }
}

PY_PKGS=(colorama pystyle)

echo -e "${BLUE}${BOLD}[*]${RESET} Installing Python packages..."

python3 -m pip install "${PY_PKGS[@]}" >/dev/null 2>&1 || {
  echo -e "${YELLOW}${BOLD}[!]${RESET} pip retry..."
  python3 -m pip install "${PY_PKGS[@]}" || {
    echo -e "${RED}${BOLD}[-]${RESET} Pip install failed."
    exit 1
  }
}

echo -e "${BLUE}${BOLD}[*]${RESET} Tools status:"

for pkg in "${!PKGS[@]}"; do
  cmd="${PKGS[$pkg]}"
  path=$(command -v "$cmd" 2>/dev/null || true)
  if [[ -n "$path" ]]; then
    echo -e "    ${GREEN}${BOLD}[>]${RESET} $pkg -> $path"
  else
    echo -e "    ${YELLOW}${BOLD}[!]${RESET} $pkg missing."
  fi
done

echo -e "${BLUE}${BOLD}[*]${RESET} Verifying key tools..."
echo -e "${BLUE}${BOLD}[>]${RESET} Python: $(python3 --version)"
echo -e "${BLUE}${BOLD}[>]${RESET} Pip: $(python3 -m pip --version)"

if command -v msfvenom >/dev/null 2>&1; then
  echo -e "${GREEN}${BOLD}[+]${RESET} ${BLUE}Msfvenom${RESET} $(command -v msfvenom)"
else
  echo -e "${RED}${BOLD}[-]${RESET} ${BLUE}Msfvenom${RESET} not found."
fi

echo -e "${GREEN}${BOLD}[+]${RESET} Installation completed."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOOL_PATH="$SCRIPT_DIR/WXxploit.py"
CMD_PATH="/usr/local/bin/wxxploit"

read -p "$(echo -e "${BLUE}${BOLD}[*]${RESET} Add '${RED}wxxploit${RESET}' command to system? (Y/N) > ")" INSTALL_CMD

while [[ ! "$INSTALL_CMD" =~ ^[YyNn]$ ]]; do
    echo -e "${RED}${BOLD}[-]${RESET} Please enter 'Y' or 'N'."
    read -p "$(echo -e "${BLUE}${BOLD}[*]${RESET} Add '${RED}wxxploit${RESET}' command to system? (Y/N) > ")" INSTALL_CMD
done

if [[ "$INSTALL_CMD" =~ ^[Yy]$ ]]; then
  if [ -f "$CMD_PATH" ]; then
    echo -e "${YELLOW}${BOLD}[!]${RESET} The command 'wxxploit' already exists. Overwriting..."
  fi

  echo -e "${BLUE}${BOLD}[*]${RESET} Creating launcher..."

  cat << EOF > "$CMD_PATH"
#!/usr/bin/env bash
python3 "$TOOL_PATH" "\$@"
EOF

  chmod +x "$CMD_PATH"

  echo -e "${GREEN}${BOLD}[+]${RESET} Command installed!"
  echo -e "${BLUE}${BOLD}[*]${RESET} Run > ${RED}${BOLD}wxxploit${RESET}"

else
  echo -e "${YELLOW}${BOLD}[!]${RESET} Command installation skipped."
fi

echo -e "${GREEN}${BOLD}[+]${RESET} Virtual environment ready."

echo -e "${BLUE}${BOLD}[*]${RESET} To activate the virtual environment run:"
echo -e "    ${YELLOW}${BOLD}source venv/bin/activate${RESET}"

echo -e "${BLUE}${BOLD}[*]${RESET} Then start the tool with:"
echo -e "    ${RED}${BOLD}python3 WXxploit.py${RESET} ${BLUE}or${RESET} ${RED}${BOLD}wxxploit${RESET}"

echo -e "${CYAN}${BOLD}[*]${RESET} To deactivate the environment run:"
echo -e "    ${CYAN}${BOLD}deactivate${RESET}"

exit 0
