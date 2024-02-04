function myssh_() {
    local CONF_FILE="$HOME/.credentials/myssh_conf.json"

    if [[ $# -lt 1 ]]; then
        echo "Usage: myssh_ <option> [argument]"
        echo "Use 'myssh_ -h' or 'myssh_ --help' for a list of available options."
        return 1
    fi

    local port_forwarding=()
    local ip
    local user
    local pem
    local port=""  # Initialize port as an empty string, to be optionally set via -p or --port

    local options=$(jq -r 'keys[]' "$CONF_FILE")

    while [[ $# -gt 0 ]]; do
        case $1 in
            -L)
                while [[ $# -gt 1 ]] && [[ $2 =~ ^[0-9]+(:[0-9]+)?$ ]]; do
                    local remote_port=${2#*:}
                    local local_port=${2%%:*}
                    port_forwarding+=("-L ${local_port}:localhost:${remote_port:-$local_port}")
                    shift
                done
                shift
                ;;
            -p|--port)
                if [[ $# -gt 1 ]]; then
                    port=$2
                    shift  # Move past the port value
                else
                    echo "Error: '-p|--port' requires a port number argument."
                    return 1
                fi
                shift
                ;;
            -h|--help)
                echo "Usage: myssh_ <option> [argument]"
                for opt in $options; do
                    echo "-$opt : SSH into the $opt profile."
                done
                echo "-L : Specify ports for local port forwarding. Can be used multiple times for multiple ports."
                echo "-p, --port : Specify the port for the SSH connection."
                return 0
                ;;
            *)
                if jq -e --arg key "${1#-}" '.[$key]' "$CONF_FILE" > /dev/null; then
                    ip=$(jq -r --arg key "${1#-}" '.[$key].ip' "$CONF_FILE")
                    user=$(jq -r --arg key "${1#-}" '.[$key].user' "$CONF_FILE")
                    pem=$(jq -r --arg key "${1#-}" '.[$key].pem' "$CONF_FILE")
                    shift
                else
                    echo "Invalid option. Use 'myssh_ -h' or 'myssh_ --help' for a list of available options."
                    return 1
                fi
                ;;
        esac
    done

    # Default port if not specified
    if [[ -z $port ]]; then
        port=22  # Default SSH port
    fi

    ssh_command="ssh -p $port"

    if [[ -n $pem ]]; then
        ssh_command+=" -i $pem"
    fi

    for pf in "${port_forwarding[@]}"; do
        ssh_command+=" $pf"
    done

    if [[ -n $ip ]]; then
        ssh_command+=" $user@$ip"
        echo "Executing command: $ssh_command"
        eval "$ssh_command"
    else
        echo "No valid IP address found for connection."
        return 1
    fi
}
