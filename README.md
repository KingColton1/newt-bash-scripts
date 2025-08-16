# newt-bash-scripts
Small QoL script for Newt's binary install, configure, and upgrade. Based on this [guidance](https://docs.fossorial.io/Newt/install).

If you use [Pangolin/Fossorial](https://github.com/fosrl/pangolin) and don't want to use Docker in every servers, but feel too much hassle with installing and configuring binary package manually every time. Or that you don't know how to keep newt running in background (such as systemd), this is for you.

What this script does is very similar to newt's binary install guidance. Install newt, move newt files to `/usr/local/bin` (to make it permanent install), create, enable, and start a new newt.service file to have newt run in background. All you need is enter your site's ID, secret, and endpoint domain after you run `./install-newt.sh`. The information you put in the shell will be used to connect to your pangolin server from your server you installed newt in. They will be stored in a newly created newt.service file, located at `/etc/systemd/system/newt.service`.

Keep that in mind, this script require a Linux system with `wget`, `tee`, `chmod`, and `systemctl`. Make sure your Linux/FreeBSD/Darwin system does have these packages or able to install them. Windows is not supported currently.

Once you download `install-newt.sh` and/or `upgrade-newt.sh`, you don't need to re-download it every time a new Newt version is available because both scripts will grab latest version for you!

# Usage
This is a bash script and should take few seconds to set it up. This guidance assume you have a site's ID, secret, and endpoint domain ready to fill it out. **You must run this shell script as root**
1. Run `su -` to log in as root.
   - If you are on Ubuntu or a server that have `sudo` package installed, run `sudo su -` instead.
2. Run one-line install script (install-newt.sh):
```bash
   bash <(wget -qO- https://raw.githubusercontent.com/KingColton1/newt-bash-scripts/main/install-newt.sh)
```
3. Enter your site's ID, secret, and endpoint domain.
4. Let the script take care rest of it.
5. Newt service should be active and running (the output of `sudo systemd status newt.service` will appear after install shell is finished).
6. Check your pangolin dashboard, your site should be shown as "Online". If it is, it's a successful installation!

# Upgrade to a new Newt version
Another bash script for upgrading Newt to a new version. **You must run this shell script as root**
1. Run `su -` to log in as root.
2. Grab upgrade-newt.sh using wget:
```bash
   wget -qO- https://raw.githubusercontent.com/KingColton1/newt-bash-scripts/refs/heads/main/upgrade-newt.sh
```
4. Run `chmod +x upgrade-newt.sh` to make it executable.
5. Run `./upgrade-newt.sh` to start install and configure.
7. Newt service should be active and running (the output of `sudo systemd status newt.service` will appear after upgrade shell is finished).
6. Ensure that you can access to your sites without a problem. If there is no problem, you're good to go!

You can reuse `upgrade-newt.sh` to upgrade your newt client to a new version whenever a new version is published.
