ready=0;



if [ -z "$(command -v git)" ]; then    
    sudo apt install git
fi

cat << EOF
Gitub config: Set up a new computer for development

Options:
1) Run all (recommended)
2) Configure username and email 
3) Upload SSH key (requires option 2)
4) Add shortcuts

EOF
read -p "Select option: " ans


if [ $ans == "1" ]; then
    go=all
elif [ $ans == "2" ]; then
    go=2
elif [ $ans == "3" ]; then
    go=3
elif [ $ans == "4" ]; then
    go=4
else 
    echo "Not a valid option"
    exit
fi

if [ "$go" == "all" ] || [ "$go" == "2" ]; then    

    echo "Configuring username and email"

    while ! (($ready))
    do
        read -p "Do you share this computer (y/n)? " global
        if [ $global == "y" ]; then
            g="--global"
            ready=1
        elif [ $global == "n" ]; then
            g=""
            ready=1
        fi
    done

    read -p "Username: " username
    git config $g user.name "$username"
    read -p "Email: "  email
    git config $g user.email "$email"
    
    echo "Successfully configured username and email."
    
fi

if [ "$go" == "all" ] || [ "$go" == "3" ]; then

    echo "Starting key installation."
    
    if [ -z "$(cat ~/.ssh/id_rsa.pub)" ]; then
        echo 'USE DEFAULTS: just press enter twice'
        ssh-keygen
    fi
    
    ready=0
    while ! (($ready))
    do
        read -p "Do you use 2FA (y/n)? " global
        if [ "$global" == "y" ] || [ "$global" == "n" ]; then
            ready=1
        fi
    done

    desc="${desc:-$(date +%D)}"
    user="${user:-$(git config --get user.name)}"
    path="${path:-$HOME/.ssh/id_rsa.pub}"
    title="$(hostname) ($desc)"
    # check if the path is available
    [[ -f $path ]] || die "$path: no such file or directory"
    key_data="$(cat "$path")"

    if [ $global == "y" ]; then
        if [ -z "$(command -v python3)" ]; then    
            sudo apt install python3
        fi
        
        if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
            echo "$key_data"
            echo "$key_data" | clip.exe
        else
            if [ -z "$(command -v xclip)" ]; then    
                sudo apt install xclip
            fi
            echo "$key_data"
            echo "$key_data" | xclip
        fi
        python3 -mwebbrowser https://github.com/settings/ssh/new
    else
        result="$(
                curl -u "${user:=$USER}" \
                    --data "{\"title\":\"$title\",\"key\":\"$key_data\"}" \
                    https://api.github.com/user/keys
                )"
        echo $result
    fi

    echo "Successfully installed keys."
fi

if [ "$go" == "all" ] || [ "$go" == "4" ]; then    

    echo "Starting shortcut installation."
    current="$(ls)"
    if [[ $current == *"gd"* ]] && [[ $current == *"gi"* ]] && [[ $current == *"gr"* ]]; then
        if [ -z "$(command -v go)" ]; then    
            sudo add-apt-repository ppa:longsleep/golang-backports
            sudo apt update
            sudo apt install golang-go
        fi
        if [ -z "$(command -v hub)" ]; then    
            if [ -z "$(sudo apt install hub)"]; then
                echo "hub isn't installed. Download at https://github.com/github/hub/"
            fi
        fi
        commands=(gd gi gp gr gc)

        for i in "${commands[@]}"; 
            do sudo cp "$i" /usr/bin;
        done
        
        echo "Successfully installed shortcuts."
    fi
    
fi
