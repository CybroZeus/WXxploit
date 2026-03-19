#!/usr/bin/env python3

# WXxploit
# GitHub: https://github.com/CybroZeus
# Telegram: https://t.me/CybroZeus
# Developer: CybroZeus

import os
import re
import sys
import time
import shutil
import builtins
import platform
import subprocess
from pystyle import *
from colorama import *

gradient_colors = Colors.red_to_white
gradient_colors2 = Colors.green_to_cyan
gradient_colors3 = Colors.yellow_to_red

def clear_screen():
    os.system("cls" if platform.system() == "Windows" else "clear")
clear_screen()

def set_title(title):
    if platform.system() == "Windows":
        os.system(f"title {title}")
    else:
        sys.stdout.write(f"\033]0;{title}\007")
        sys.stdout.flush()

set_title("WXxploit")

original_input = builtins.input

def global_input(prompt=""):
    user_input = original_input(prompt)
    if user_input.strip().lower() in ("exit", "quit"):
        Write.Print("\n[*] Exiting", gradient_colors3, interval=0.03)
        Write.Print(" WXxploit...", gradient_colors, interval=0.03)
        time.sleep(1)
        sys.exit(0)

    return user_input

builtins.input = global_input

def is_valid_ip_or_hostname(value: str) -> bool:
    ip_pattern = r"^(?:\d{1,3}\.){3}\d{1,3}$"
    hostname_pattern = r"^(?!-)[A-Za-z0-9-]{1,63}(?<!-)(?:\.[A-Za-z]{2,})+$"
    if re.match(ip_pattern, value):
        return all(0 <= int(part) <= 255 for part in value.split('.'))

    return bool(re.match(hostname_pattern, value))

WXxploit = """
 █     █░▒██   ██▒▒██   ██▒ ██▓███   ██▓     ▒█████   ██▓▄▄▄█████▓
▓█░ █ ░█░▒▒ █ █ ▒░▒▒ █ █ ▒░▓██░  ██▒▓██▒    ▒██▒  ██▒▓██▒▓  ██▒ ▓▒
▒█░ █ ░█ ░░  █   ░░░  █   ░▓██░ ██▓▒▒██░    ▒██░  ██▒▒██▒▒ ▓██░ ▒░
░█░ █ ░█  ░ █ █ ▒  ░ █ █ ▒ ▒██▄█▓▒ ▒▒██░    ▒██   ██░░██░░ ▓██▓ ░ 
░░██▒██▓ ▒██▒ ▒██▒▒██▒ ▒██▒▒██▒ ░  ░░██████▒░ ████▓▒░░██░  ▒██▒ ░ 
░ ▓░▒ ▒  ▒▒ ░ ░▓ ░▒▒ ░ ░▓ ░▒▓▒░ ░  ░░ ▒░▓  ░░ ▒░▒░▒░ ░▓    ▒ ░░   
  ▒ ░ ░  ░░   ░▒ ░░░   ░▒ ░░▒ ░     ░ ░ ▒  ░  ░ ▒ ▒░  ▒ ░    ░    
  ░   ░   ░    ░   ░    ░  ░░         ░ ░   ░ ░ ░ ▒   ▒ ░  ░      
    ░     ░    ░   ░    ░               ░  ░    ░ ░   ░           
                                                                                      

                             WXxploit  
                      Reverse Shell Listener
                       Telegram: @CybroZeus
                       Developer: CybroZeus
""".strip()

def prompt_lhost() -> str:
    while True:
        try:
            Write.Print("WXxploit => LHOST > ", gradient_colors, interval=0.01)
            lhost = input().strip()
            if not lhost:
                print(Colorate.Horizontal(gradient_colors, "[-] LHOST cannot be empty."))
                time.sleep(1)
                clear_screen()
                continue
            if not is_valid_ip_or_hostname(lhost):
                Write.Print("[-] Please enter a valid IP or hostname.", gradient_colors, interval=0.01)
                time.sleep(1)
                clear_screen()
                wx_xploit()
                continue
            Write.Print(f"[+] LHOST => {lhost}\n", gradient_colors2, interval=0.01)
            return lhost
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(0)

def prompt_lport() -> int:
    while True:
        try:
            Write.Print("WXxploit => LPORT > ", gradient_colors, interval=0.01)
            lport = input().strip()
            Write.Print(f"[+] LPORT => {lport}\n", gradient_colors2, interval=0.01)
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(1)
        if not lport.isdigit():
            Write.Print("[-] LPORT must be numeric (1-65535).\n", gradient_colors, interval=0.01)
            continue
        lport = int(lport)
        if 1 <= lport <= 65535:
            return lport
        Write.Print("[-] LPORT out of range 1-65535.", gradient_colors, interval=0.01)
        continue

def prompt_payload():
    while True:
        try:
            Write.Print("WXxploit => PAYLOAD > ", gradient_colors, interval=0.01)
            payload = input().strip()
            if not payload:
                Write.Print("[-] PAYLOAD cannot be empty.\n", gradient_colors, interval=0.01)
                time.sleep(1)
                continue
            Write.Print(f"[+] PAYLOAD => {payload}\n", gradient_colors2, interval=0.01)
            return payload
        except (EOFError, KeyboardInterrupt):
            print()
            sys.exit(0)

def start_listener(lhost, lport, payload):
    Write.Print(f"\n[*] Starting", gradient_colors3, interval=0.03)
    Write.Print(f" WXxploit...", gradient_colors, interval=0.03)
    Write.Print(f"\n    └─ Host > {lhost} | Port > {lport}", gradient_colors, interval=0.003)
    Write.Print(f"\n    └─ Payload > {payload}\n\n", gradient_colors, interval=0.003)

    msf_path = shutil.which("msfconsole")
    if msf_path is None:
        Write.Print("[-] Metasploit Framework not found. Install it and try again.\n", gradient_colors, interval=0.01)
        
    msf_commands = (
        "use exploit/multi/handler; "
        f"set payload {payload}; "
        f"set LHOST {lhost}; "
        f"set LPORT {lport}; "
        "exploit"
    )
    try:
        subprocess.call([msf_path, "-q", "-x", msf_commands])
    except KeyboardInterrupt:
        Write.Print(f"\n\n[-] WXxploit stopped by user.", gradient_colors, interval=0.01)

def wx_xploit():
    clear_screen()
    print(Colorate.Horizontal(gradient_colors, WXxploit))
    print()

    lhost = prompt_lhost()
    lport = prompt_lport()
    payload = prompt_payload()

    while True:
        Write.Print("WXxploit => ", gradient_colors, interval=0.01)
        command = input().strip().lower()
        if command == "exploit":
            start_listener(lhost, lport, payload)
            break
        else:
            Write.Print("[-] Unknown command. Type 'exploit' to start or 'exit' to quit.\n", gradient_colors, interval=0.01)

if __name__ == "__main__":
    wx_xploit()
