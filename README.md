# newt-systemd-bash-script
Small QoL script for Newt's binary install and configure. Based on this [guidance](https://docs.fossorial.io/Newt/install).

If you use [Pangolin/Fossorial](https://github.com/fosrl/pangolin) and don't want to use Docker in every servers, but feel too much hassle with doing it manually every time, this is for you.

# Usage
This is a simple bash script and should take few seconds to set it up. This guidance assume you have a site's ID, secret, and endpoint domain ready to fill it out. **You must run this shell script as root**
1. Run `su -` to log in as root.
2. Grab install-newt.sh using wget: `wget https://raw.githubusercontent.com/KingColton1/newt-systemd-bash-script/refs/heads/main/install-newt.sh`
3. Run `chmod +x install-newt.sh` to make it executable.
4. Run `./install-newt.sh` to start install and configure.
5. Enter your site's ID, secret, and endpoint domain.
6. Let the script take care rest of it
7. Newt service should be active and running. Double check `sudo systemctl status newt.service` to be sure it is running.
8. Check your pangolin dashboard, your site should be shown as "Online". If it is, it's a successful installation!
