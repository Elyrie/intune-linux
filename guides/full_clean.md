# Full Clean Guide for Microsoft Intune on Linux

## Stop Identity Service

sudo systemctl stop microsoft-identity-device-broker

systemctl --user stop microsoft-identity-broker

## Clean up state

sudo systemctl clean --what=configuration --what=runtime --what=state microsoft-identity-device-broker

systemctl --user clean --what=state --what=configuration --what=runtime microsoft-identity-broker

rm -r ~/.config/intune

## Uninstall the Intune package

sudo apt purge intune-portal

## Uninstall any versions of Edge that are installed

sudo apt purge microsoft-edge-dev

## Optional, but this can potentially free space by some larger dependencies that the auth broker required

sudo apt autoremove

## remove secrets stored

sudo apt install libsecret-tools -y

secret-tool search --all env 60a144fbac31dfcf32034c112a615303b0e55ecad3a7aa61b7982557838908dc

secret-tool clear env 60a144fbac31dfcf32034c112a615303b0e55ecad3a7aa61b7982557838908dc

secret-tool search --all name LinuxBrokerRegularUserSecretKey --unlock

secret-tool search --all name LinuxBrokerSystemUserSecretKey --unlock

secret-tool clear name LinuxBrokerRegularUserSecretKey

secret-tool clear name LinuxBrokerSystemUserSecretKey

## Verify device is removed from Company Portal

On a managed device browse to <https://aka.ms/cpweb>

Click Devices

locate the Linux device, and if it is there select it

Click Remove
