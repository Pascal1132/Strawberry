## Create file in ./server/.env if not exist bash script

    # Generate random RSA
    SERVER_RSA_PUBLIC_KEY=$(openssl rand -base64 32)
# Check if file exist
if [ ! -f ./server/.env ]; then
    # Create file
    touch ./server/.env

    # Write to file
    echo "SERVER_RSA_PUBLIC_KEY=$SERVER_RSA_PUBLIC_KEY" >> ./server/.env
fi

# Check if file exist
if [ ! -f ./client/.env ]; then
    # Create file
    touch ./client/.env

    # Write to file
    echo "SERVER_RSA_PUB=$SERVER_RSA_PUBLIC_KEY" >> ./client/.env
fi