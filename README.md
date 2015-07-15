# Simple SpoofMAC (Mac OS X Airport card MAC address spoofer)

This repository contains a very simple Apple Airport card [MAC (Media Access Control, aka "Ethernet address")](https://en.wikipedia.org/wiki/MAC_address) spoofer designed for Mac OS X systems compatible with [`launchd`](http://launchd.info/). (However, it has only been tested on Mac OS X 10.10.x Yosemite systems. YMMV.)

You might want to spoof your MAC address if you use your laptop in a lot of different environments (Starbucks FTW) and you'd prefer to appear as a "new" device whenever you restart. This helps protect your privacy by making it more difficult to associate you with a particular device. The best way to think about a MAC address is like a license plate for your network card; anyone on the network can see it. Unlike a license plate, though, you can (legally) change your MAC address at any time. You can [learn more about MAC address spoofing (and a bunch of other privacy-related things)](https://maymay.net/blog/2013/02/20/howto-use-tor-for-all-network-traffic-by-default-on-mac-os-x/#spoof-your-mac-address) on [my blog](https://maymay.net/blog/tag/privacy).

This script works by finding your Mac's "Wi-Fi" network interface and randomizing its hardware/ethernet/link-local address each time you restart your Mac. It's currently smart enough to work on either `en0` or `en1` interfaces, as long as your Airport interface is called "Wi-Fi" in your Network System Preference pane.

# Installing

Each step in the following list of instructions is a one-liner. The steps are:

1. Download.
1. Install the `SpoofMAC.sh` script (into `/usr/local/libexec`).
1. Install the `launchd` service.
1. Reboot your Macintosh.

The complete process looks like this:

    git clone https://github.com/meitar/SimpleSpoofMAC.git  # Download.
    cd SimpleSpoofMAC
    sudo mkdir -p /usr/local/libexec
    sudo cp SpoofMAC.sh /usr/local/libexec              # Install script.
    sudo cp local.SpoofMAC.plist /Library/LaunchDaemons # Install launchd service.
    sudo shutdown -r +1 "Rebooting in 1 minute."        # Reboot your Macintosh.

# Alternatives

[Feross Aboukhadijeh wrote a handy tool in Python](https://github.com/feross/SpoofMAC) to do the same thing as this script. Feross's tool also supports Windows and Linux computers. I wrote this because I don't like the idea of a Python dependency for such a basic sysadmin task as spoofing a MAC address. Use Feross's script if you want a cross-platform solution. Use this script if you also think Python, while swell, is probably overkill for this sort of thing.
