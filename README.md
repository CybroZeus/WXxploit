# WXxploit

**WXxploit** is a **Reverse Shell Listener** tool designed for **educational and authorized penetration testing**.  
It allows security professionals and ethical hackers to quickly set up a listener for various payloads, with interactive input validation for IP addresses, ports, and payload types.

> ⚠️ **Disclaimer:** This tool is intended for **educational purposes and authorized penetration testing only**. Unauthorized usage is illegal and unethical. Use responsibly.  

---

## Features

- Interactive prompts for **LHOST**, **LPORT**, and **Payload**.
- Validates IP addresses, hostnames, and port numbers.
- Smooth terminal output with colored feedback.
- Quick exit commands (`exit`, `quit`) supported at any time.
- Integrated execution of the listener using the installed payload framework.

---

## Screenshot of the WXxploit

![WXxploit](WXxploit%20Image/WXxploit.png)

## Prerequisites

- Python 3.8+  
- [Pystyle](https://pypi.org/project/pystyle/) (`pip install pystyle`)  
- [Colorama](https://pypi.org/project/colorama/) (`pip install colorama`)  
- Optional: Payload framework installed (e.g., Metasploit or equivalent), depending on your use case.

---

# Installation

## 1. Clone the repository:

```bash
git clone https://github.com/CybroZeus/WXxploit.git
```

## 2. Navigate to the project directory:
```bash
cd WXxploit
```

## 3. Run the setup file

```bash
bash WXInstall.sh
```

## 4. Run the tool:
```bash
python3 WXxploit.py
```

Example output:
```
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

WXxploit => LHOST > 192.168.0.1
[+] LHOST => 192.168.0.1
WXxploit => LPORT > 4444
[+] LPORT => 4444
WXxploit => PAYLOAD > windows/x64/meterpreter/reverse_tcp
[+] PAYLOAD => windows/x64/meterpreter/reverse_tcp
WXxploit => exploit

[*] Starting WXxploit...
    └─ Host > 192.168.0.1 | Port > 4444
    └─ Payload > windows/x64/meterpreter/reverse_tcp
```

*exploit → Start the listener with the configured LHOST, LPORT, and payload.*

To exit at any time, type:
```bash
exit
```

or

```bash
quit
```

# Contributing

Contributions are welcome! Please ensure all submissions follow ethical guidelines for penetration testing.

## *Developed By CybroZeus*

## Contact

- 👤 [Telegram](https://t.me/CybroZeus)

# License

This project is provided for educational purposes only. Unauthorized use for hacking or exploitation is strictly prohibited.