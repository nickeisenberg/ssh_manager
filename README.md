# myssh Documentation

The `myssh` tool is a Bash function designed to simplify the process of 
establishing SSH connections with dynamic configuration options based on 
predefined profiles stored in a JSON configuration file. It supports local 
port forwarding and allows for specifying SSH connection parameters such as 
port and identity file (pem).

## Installation

To use the `myssh` tool, you must first include it in your `.bashrc` file or any script file that you source into your shell.

1. Open your `.bashrc` file or a custom script file in a text editor.
2. Copy and paste the `myssh` function definition into the file.
3. Save the file and source it to your shell:
   ```bash
   source ~/.bashrc
   ```

## Configuration File

The tool relies on a JSON configuration file located at 
`~/.config/myssh/conf.json`. This file should contain the SSH connection 
profiles with their respective configurations, such as IP addresses, 
usernames, and optional PEM files for authentication.

Example conf.json format:
```json
{
  "profileName": {
    "ip": "192.168.1.1",
    "user": "username",
    "pem": "/path/to/pem/file"
  }
}
```

# Usage

To use `myssh`, run the `myssh` command followed by the options you wish to 
use. The general syntax is as follows:
```bash
myssh [options] [arguments]
```

## Options

* Profile selection: Specify the profile name directly (e.g., profileName) to 
use the configuration defined in `conf.json`.
* `-h, --help`: Displays help information and exits.
* `-L [local_port]:[remote_port]`: Specifies ports for local port forwarding. 
   Can be used multiple times for multiple ports.
*  `-p, --port [port]`: Specifies the port for the SSH connection.
*  `-dryrun`: Displays the SSH command without executing it.

# Examples

* Connecting to a profile with port forwarding:

  ```bash
  myssh profileName -L 8080:80
  ```
  
  This command establishes an SSH connection using the profileName profile, 
  forwarding port 80 of the remote host's localhost to port 8080 on your 
  local machine. In other words, `ssh ... -L 8080:localhost:80 ...`
  

* Specifying the SSH port:

  ```bash
  myssh profileName -p 2222
  ```

  This command connects to the remote host using the profileName profile on 
  port 2222.

* Dry run:

  ```bash
  myssh profileName -dryrun
  ```

  This command prints the SSH command that would be executed, based on the 
  profileName profile, without actually establishing the connection.
