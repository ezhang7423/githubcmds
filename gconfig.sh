ready=0;

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

if [ -z "$(command -v git)" ]; then    
    sudo apt install git
fi

read -p "Username: " username
git config $g user.name "$username"
read -p "Email: "  email
git config $g user.email "$email"

if [ -z "$(cat ~/.ssh/id_rsa.pub)" ]; then
    echo 'USE DEFAULTS: just click enter twice'
    ssh-keygen
    
fi


