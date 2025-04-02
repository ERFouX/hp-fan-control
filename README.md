# HP EliteBook Fan Control

This repository contains scripts and configuration files to control the fan speed on HP EliteBook laptops, specifically tuned for the HP EliteBook 850 G5. The goal is to make the fans start at lower temperatures and run at higher speeds, especially during charging when the laptop gets hot.

## Prerequisites

This solution uses `nbfc-linux` (NoteBook FanControl) which is a lightweight fan control service. You need to install it first:

```bash
# Arch Linux (using an AUR helper like paru)
paru -S nbfc-linux
```
Or see the [nbfc](https://github.com/hirschmann/nbfc) repository

## Files Included

- `smart-fan-control.sh`: Main script that checks if laptop is plugged in and adjusts fan speed accordingly
- `fan-high.sh`: Simple script to set fans to high speed (80%)
- `fan-auto.sh`: Simple script to set fans to automatic control mode
- `nbfc-smart-control.service`: Systemd service that runs the smart fan control script
- `nbfc-smart-control.timer`: Systemd timer that runs the script every 5 minutes
- `99-nbfc-ac-event.rules`: Udev rules to run the script when AC power is connected/disconnected
- `HP EliteBook 850 G5.json`: NBFC configuration file for my laptop model

## Installation

1. Install nbfc-linux as shown in prerequisites
```bash
paru -S nbfc-linux
```

2. Clone the repository
```bash
git clone https://github.com/ERFouX/hp-fan-control.git
```

3. Go to the repository folder
```bash
cd hp-fan-control
```

4. To grant executable access to the file, enter the following command:
```bash
chmod +x ./install.sh
```

5. Run the installer
```bash
./install.sh
```

## Manual Installation
Copy the configuration files to their proper locations:

```bash
# Create necessary directories
sudo mkdir -p /etc/nbfc/configs
sudo mkdir -p /etc/udev/rules.d

# Copy the configuration file
sudo cp "HP EliteBook 850 G5.json" /etc/nbfc/configs/

# Set the configuration
sudo nbfc config --set "HP EliteBook 850 G5"

# Copy scripts to bin directory
mkdir -p ~/bin
cp smart-fan-control.sh fan-high.sh fan-auto.sh ~/bin/
chmod +x ~/bin/smart-fan-control.sh ~/bin/fan-high.sh ~/bin/fan-auto.sh

# Copy systemd service and timer
sudo cp nbfc-smart-control.service nbfc-smart-control.timer /etc/systemd/system/

# Copy udev rules
sudo cp 99-nbfc-ac-event.rules /etc/udev/rules.d/

# Enable and start services
sudo systemctl start nbfc_service
sudo systemctl enable nbfc_service
sudo systemctl enable nbfc-smart-control.service
sudo systemctl start nbfc-smart-control.timer
sudo systemctl enable nbfc-smart-control.timer

# Reload udev rules
sudo udevadm control --reload-rules
```

## Usage

After installation, the system should **automatically** adjust the fan speed based on whether the laptop is plugged in or running on battery:

- When plugged in: Fans run at 80% speed to keep the laptop cooler
- When on battery: Fans are automatically controlled by nbfc based on temperature

‌
You can also **manually** control the fans:

```bash
# Set fans to high speed (80%)
~/bin/fan-high.sh

# Set fans to automatic control
~/bin/fan-auto.sh

# Run the smart control script manually
~/bin/smart-fan-control.sh
```

## Checking Status

You can check the current fan status with:

```bash
nbfc status -a
```

To see if the timer is running:

```bash
systemctl list-timers | grep nbfc
```

## Customization

This installer will create a folder in your home, you can edit it and change it to `/usr/bin` or something else

If you want to adjust the fan speeds, you can edit the `smart-fan-control.sh` script. The current setting **uses 80% when plugged in**, but you can change this to any value between 0 and 100.

## Troubleshooting

If the fan control is not working:

1. Check if nbfc service is running: `systemctl status nbfc_service`
2. Check if the timer is running: `systemctl status nbfc-smart-control.timer`
3. Run the script manually to see any errors: `sudo ~/bin/smart-fan-control.sh`
4. Check the current AC status: `cat /sys/class/power_supply/AC/online` (1 means plugged in, 0 means on battery)

I would be happy if you open an issue if you see any problems.

## Other Laptop Models

To use this on other laptop models, you will need to find or create an nbfc configuration file for your specific model. You can list available configs with:

```bash
nbfc config --list
```

And get your model name with:

```bash
nbfc get-model-name
```

### support
You support me by giving this repository a star ⭐
