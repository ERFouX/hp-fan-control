#!/bin/bash

echo "Installing HP EliteBook Fan Control..."
echo "Creating directories..."
sudo mkdir -p /etc/nbfc/configs
mkdir -p ~/bin

echo "Copying files..."
sudo cp "HP EliteBook 850 G5.json" /etc/nbfc/configs/
cp smart-fan-control.sh fan-high.sh fan-auto.sh ~/bin/
chmod +x ~/bin/smart-fan-control.sh ~/bin/fan-high.sh ~/bin/fan-auto.sh
sudo cp nbfc-smart-control.service nbfc-smart-control.timer /etc/systemd/system/
sudo cp 99-nbfc-ac-event.rules /etc/udev/rules.d/

echo "Setting up nbfc service..."
sudo nbfc config --set "HP EliteBook 850 G5"
sudo systemctl enable nbfc_service
sudo systemctl start nbfc_service
sudo systemctl enable nbfc-smart-control.service
sudo systemctl enable nbfc-smart-control.timer
sudo systemctl start nbfc-smart-control.timer

echo "Reloading udev rules..."
sudo udevadm control --reload-rules

echo "Running fan control script for the first time..."
sudo ~/bin/smart-fan-control.sh

echo "Installation complete!"
echo "Fan speed control is now active. Check status with: nbfc status -a"
