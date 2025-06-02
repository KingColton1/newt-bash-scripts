# newt-systemd-bash-script
Small QoL script for Newt's binary install and configure. Based on this [guidance](https://docs.fossorial.io/Newt/install).

If you use [Pangolin/Fossorial](https://github.com/fosrl/pangolin) and don't want to use Docker in every servers, but feel too much hassle with installing and configuring binary package manually every time. Or that you don't know how to keep newt running in background (such as systemd), this is for you.

What this script does is very similar to newt's binary install guidance. Install newt, move newt files to `/usr/local/bin` (to make it permanent install), create, enable, and start a new newt.service file to have newt run in background. All you need is enter your site's ID, secret, and endpoint domain after you run `./install-newt.sh`. The information you put in the shell will be used to connect to your pangolin server from your server you installed newt in. They will be stored in a newly created newt.service file, located at `/etc/systemd/system/newt.service`.

Keep that in mind, this script require a Linux system with `wget`, `tee`, `chmod`, and `systemctl`.

# Usage
This is a simple bash script and should take few seconds to set it up. This guidance assume you have a site's ID, secret, and endpoint domain ready to fill it out. **You must run this shell script as root**
1. Run `su -` to log in as root.
2. Grab install-newt.sh using wget: `wget https://raw.githubusercontent.com/KingColton1/newt-systemd-bash-script/refs/heads/main/install-newt.sh`
3. Run `chmod +x install-newt.sh` to make it executable.
4. Run `./install-newt.sh` to start install and configure.
5. Enter your site's ID, secret, and endpoint domain.
6. Let the script take care rest of it
7. Newt service should be active and running (systemd status newt.service will. Double check `sudo systemctl status newt.service` to be sure it is running.
8. Check your pangolin dashboard, your site should be shown as "Online". If it is, it's a successful installation!
