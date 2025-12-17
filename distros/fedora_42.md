# Fedora 42

## Fedora 42 used dnf5 package manager

Command for adding repository from a repo file:

```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo dnf5 config-manager add-repo --from-repofile=https://packages.microsoft.com/yumrepos/microsoft-rhel9.0-prod/config.repo
```

## Openjdk 11 dependency

Fedora stopped supporting legacy openjdk versions in favour of Adoptium Temurin JDK packages [https://fedoraproject.org/wiki/Changes/ThirdPartyLegacyJdks](https://fedoraproject.org/wiki/Changes/ThirdPartyLegacyJdks) with their 42 release so Intune won't work without a few changes as it depends on java-11-openjdk by default.

- adoptium-temurin-java-repository is already installed, but disabled in Fedora 42, so enable it with `sudoedit /etc/yum.repos.d/adoptium-temurin-java-repository.repo` and changing `enabled=1` on line 4
- Install the JDK with `sudo dnf install temurin-11-jdk`
- Create a symlink as a root with `sudo ln -s /usr/lib/jvm/temurin-11-jdk /usr/lib/jvm/jre-11-openjdk`
- Intune is probably unistalled at this point even if you did in-place update from 41 because of the dependencies so install again with `sudo dnf install intune-portal`
- **Reboot**
- Intune should now work
