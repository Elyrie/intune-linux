# Restart Intune when memory limit is reached

`sudodit /etc/systemd/system/microsoft-identity-device-broker.service.d/override.conf`

```
[Service]
#RuntimeMaxSec=23h 59min 59s
MemoryAccounting=true
MemoryMax=2G
```
