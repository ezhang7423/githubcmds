ready=0;



if [ -z "$(command -v git)" ]; then    
    sudo apt install git
fi

cat << EOF
Gitub config: Set up a new computer for development

Options:
1) Run all
2) Configure username and email 
3) Upload SSH key 
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
fi

if [go == "all"] || [go == "2"]; then
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
fi

if [go == "all"] || [go == "2"]; then
    if [ -z "$(cat ~/.ssh/id_rsa.pub)" ]; then
        echo 'USE DEFAULTS: just click enter twice'
        ssh-keygen
    fi
    desc="${desc:-$(date +%D)}"
    user="${user:-$(git config --get user.name)}"
    path="${path:-$HOME/.ssh/id_rsa.pub}"
    title="$(hostname) ($desc)"
    # check if the path is available
    [[ -f $path ]] || die "$path: no such file or directory"
    key_data="$(cat "$path")"
    result="$(
            curl -u "${user:=$USER}" \
                --data "{\"title\":\"$title\",\"key\":\"$key_data\"}" \
                https://api.github.com/user/keys
            )"
    echo $result
fi
