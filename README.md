# Simple SpoofMAC (macOS Airport card MAC address spoofer)

This repository contains a very simple Apple Airport card [MAC (Media Access Control, aka "Ethernet address")](https://en.wikipedia.org/wiki/MAC_address) spoofer designed for macOS systems compatible with [`launchd`](http://launchd.info/). (However, it has only been tested on Apple systems ranging from Mac OS X 10.10.x Yosemite to macOS 10.14.x Mojave. YMMV.)

You might want to spoof your MAC address if you use your laptop in a lot of different environments (Starbucks FTW) and you'd prefer to appear as a "new" device whenever you restart. This helps protect your privacy by making it more difficult to associate your human identity with a particular device.

The best way to think about a MAC address is like a license plate for your network card; anyone on the network can see it. Unlike a license plate, though, you can (legally) change your MAC address at any time. You can [learn more about MAC address spoofing (and a bunch of other privacy-related things)](https://maymay.net/blog/2013/02/20/howto-use-tor-for-all-network-traffic-by-default-on-mac-os-x/#spoof-your-mac-address) on [my blog](https://maymay.net/blog/tag/privacy).

This script works by finding your Macintosh computer's "Wi-Fi" network interface card (NIC) and randomizing its "hardware"/"ethernet"/"link-local"/"MAC" address each time you restart your computer. The script is currently smart enough to work regardless of whether your Airport card is assigned the `en0` or `en1` interface device names, as long as the Airport card is called "`Wi-Fi`" in your Network System Preference pane.

Optionally, this script can also randomize your computer's various host names. Consistent host names can reveal your identity regardless of MAC address randomization. On a macOS system, host names include:

* the "Computer Name" (used for various "user-friendly" name purposes such as AFP- or SMB-based file sharing),
* the "Local Host Name" (used as the network name for a local subnet, e.g., Bonjour/mDNS service auto-discovery),
* the "Host Name" (used as the system's own, non-networked name such as in command line prompts)

For example, when your system is configured to obtain its IP network address via DHCP, your Computer Name is broadcast to the DHCP server as part of [DHCP option](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol#DHCP_options) number 12. Many people name their computers after themselves, such as `Alice Jones's Computer` or `Bob Smith's PC`, which will leak their legal identity to every DHCP server from which they request an IP address. Even if they randomize their network interface card's MAC address, their computer names will remain static and thus can be correlated to their identity.

# Installing

Each step in the following list of instructions is a one-liner. The steps are:

1. Download.
1. Install the `SpoofMAC.sh` script (into `/usr/local/libexec`).
1. Install the `launchd` service.
1. Reboot your Macintosh.

The complete process looks like this:

```sh
git clone https://github.com/meitar/SimpleSpoofMAC.git       # Download.
cd SimpleSpoofMAC
sudo mkdir -p /usr/local/libexec
sudo cp SpoofMAC.sh /usr/local/libexec                       # Install script.
# Install ONE (not both) of the launchd service jobs. (This defaults to the MAC and name spoofing service.)
sudo cp local.SpoofMACandName.plist /Library/LaunchDaemons \
  || sudo cp local.SpoofMAC.plist /Library/LaunchDaemons
sudo shutdown -r +1 "Rebooting in 1 minute."                 # Reboot your Macintosh.
```

## Using a custom computer name list

You can customize the random computer names the script chooses by supplying a names file with one name per line. For example:

```
alice
bob
mallory
```

When your system boots up, the script will randomly choose one of these three names to set as your computer's name.

To set a names file, edit the [`local.SpoofMACandName.plist`](local.SpoofMACandName.plist) file, setting the value of the `SIMPLE_SPOOF_MAC_NAMES_FILE` environment variable to the absolute path to a names file on your filesystem. Uncompressed wordlists such as those provided by [SecLists](https://github.com/danielmiessler/SecLists) make a good choice for such a names file.

# Alternatives

[Feross Aboukhadijeh wrote a handy tool in Python](https://github.com/feross/SpoofMAC) to do the same thing as this script though I'm unsure if it handles hostname randomization as completely as this script does. Feross's tool also supports Windows and Linux computers. I wrote this because I don't like the idea of a Python dependency for such a basic sysadmin task as spoofing a MAC address or hostname. Use Feross's script if you want a cross-platform solution. Use this script if you also think Python, while swell, is probably overkill for this sort of thing, and if you want a more Macintosh-specific solution for ensuring hostname randomization.
