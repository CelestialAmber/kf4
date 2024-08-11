# kf4
King's Field 4 shenanigans :3

## Disclaimer
No game assets are hosted on this repository. You must provide them yourself, copying them from a legal copy.


## Getting Started & Building
Linux is required in order to build this project. It requires a compiler that is only available for Linux. You'll also need at least `python 3.8` to run any command. Your linux distribution should come with `python3` already installed. If not, please follow your distribution's instructions to install it. Python is a mandatory dependency, as many core tools are written in python. On Ubuntu, if necessary, python3 can be installed with the following command:
```bash
sudo apt install python3-full
```

### Add i386 architecture
The original GCC compiler is a 32-bit executable, so on a 64-bit system the `i386` architecture must be added in order for the system to run it. On Ubuntu you can use the following commands:
```bash
sudo dpkg --add-architecture i386
sudo apt upgrade
sudo apt install libc6:i386 libstdc++6:i386
```

### Install dependencies
```bash
sudo apt install make binutils-mips-linux-gnu gcc-mips-linux-gnu python3-venv
```

### Setup a Virtual Environment for Python
Python's virtual environments are the preferred way to use this software, as you may not be allowed to install packages globally. 
```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install -r requirements.txt
```

### Copy assets from game DVD/ISO
The main executable is needed in order to perform the decompilation.
#### EU
Copy `SLPS_250.57` from DVD/ISO into `config/jp/`. File **must** have the following sha1 hash:
```
d7b7357dd4533d101f6c1117f8ac87ae879e633d
```

### Extract data
NOTE: this operation needs to be performed only once.
#### JP
```bash
make jp-extract-data
```

### Configure the project
NOTE: running these commands on an already configured project will reconfigure it.
#### JP
```bash
make jp-configure
```

### Compile
#### JP
```bash
make jp-build
```

### Clean Artifacts
#### JP
```bash
make jp-clean
```

### Command Help
To have a list all available commands, run `make` without targets:
```bash
make
```

## Decompiling a TU
1. Add the decompiled code to the TU's `c` file in `src/`
2. Update `config/{region}/kf4.{region}.yaml`:
   1. Replace `asm` with `c` for the TU you are decompiling
   2. Add a leading dot (`.`) to the type (e.g., `rodata` -> `.rodata`) of each subsection that belongs to the TU
3. Reconfigure the project
4. Build the project

