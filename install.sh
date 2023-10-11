#!/bin/bash

# Install the dependencies
if ! command -v sudo &> /dev/null
then
    echo "sudo could not be found. Installing..."
    apt install -y sudo
fi

if ! command -v node &> /dev/null
then
    echo "node could not be found. Installing..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo bash -
    sudo apt install -y nodejs
fi

# Place the files in the correct locations
INSTALL_DIR="/usr/local/bump-cycler"
if [ -d $INSTALL_DIR ]; then
    echo "Removing old installation..."
    sudo rm -rf $INSTALL_DIR
fi
mkdir $INSTALL_DIR
sudo cp ./main.ts $INSTALL_DIR
sudo cp ./package.json $INSTALL_DIR
sudo cp ./tsconfig.json $INSTALL_DIR
sudo cp ./.env $INSTALL_DIR

# Make the service
SERVICE_FILE="/etc/systemd/system/bump-cycler.service"

if [ -f $SERVICE_FILE ]; then
    echo "Removing old service..."
    sudo rm $SERVICE_FILE
fi

cat > $SERVICE_FILE <<EOF
[Unit]
Description=Bump Cycler
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bump-cycler/start.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Start the service
sudo systemctl daemon-reload
sudo systemctl enable bump-cycler.service
sudo systemctl start bump-cycler.service

echo "Installation complete!"
echo "Change the settings in /usr/local/bump-cycler/.env and then run 'sudo systemctl restart bump-cycler.service' to apply them."