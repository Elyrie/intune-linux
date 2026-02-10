# Fedora 43

## Fedora 43 needs the same changes as Fedora 42

See [Fedora 42](fedora_42.md) for instructions.

## libwebkit2gtk-4.0.so.37()(64bit) not available in Fedora 43

Can't install intune-portal for a fresh install of Fedora 43 because the dependency is not available. Was able to get it working when upgrading from 42.

## python3-pydbus not installed by default for linux-entra-sso plugin

The linux-entra-sso plugin that enables the conditional access checks for Firefox and Chrome uses pydbus Python package that isn't installed by default on 43 for Python 3. You can install this with a simple `sudo dnf install python3-pydbus` and SSO checks should work with a browser reboot after.
