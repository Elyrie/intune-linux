# Guide to Restart Intune Services on Linux so no need for Reboot

## Run commands to restart services

sudo systemctl status microsoft-identity-device-broker
sudo systemctl restart microsoft-identity-device-broker
systemctl --user status microsoft-identity-broker
systemctl --user restart microsoft-identity-broker

## Check output

/opt/microsoft/intune/bin/intune-agent

## Check compliance

intune-portal
