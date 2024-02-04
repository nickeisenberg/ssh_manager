# Setup and Functionality

1. Create the file `~/.config/myssh/conf.json`

2. Inside the `conf.json`, place the info for the `ip`, `user` and `pem` for
   the `ssh` connection you want to make. This is done in the following manner:
   ```json
   {
       "<keyname>": {
           "ip": "<ip_address>",
           "user": "<remote_host_username>",
           "pem": "<path_to_pem_file>"
       },
   }
   ```

# Functionality

1.   With the above entry, `myssh <keyname>` will run the following:
   ```bash
   ssh -p 22 -i <path_to_pem> <remote_host_username>@<ip_address>
   ```

2. `myssh` supports the input of `-L` to port forward to the remotes
   localhost. For example `myssh <keyname> -L 8000 7474` runs the following:
   ```bash
   ssh -i <path_to_pem> \
   -L 8000:localhost:8000 -L 7474:localhost:7474 \
   <remote_host_username>@<ip_address>
   ```

3. `myssh` default to port 22, but you can specify another port with `-p`. For 
   example `myssh <keyname> -p 2000` runs the following:
   ```bash
   ssh -i <path_to_pem> -p 2000 <remote_host_username>@<ip_address>
   ```

4. The `-p` and `-L` options can be used in tandem as well. In other words, 
   `myssh <keyname> -p 2000 -L 8000 7474` will forward the remotes localhost on
   port 8000 and 7474 to the users localhost port 8000 and 7474.

5. `myssh -h` will parse the `conf.json` file and tell you all of the available
    keys.
