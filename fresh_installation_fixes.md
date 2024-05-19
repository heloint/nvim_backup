# Probable fix for freezes after login on intel machines

*Change the following "GRUB_CMDLINE_LINUX_DEFAULT" in /etc/default/grub:*
- GRUB_CMDLINE_LINUX_DEFAULT="quiet splash intel_idle.max_cstate=1"
*Restart GRUB*
- sudo update-grub
*Then reboot*
*NOTE: Pop-OS doesn't have GRUB. The following command will have the same effect as the one above:*
- sudo kernelstub -v -a intel_idle.max_cstate=1
---

# Probable fix for touchpad recognization issues on ubuntu/pop_os laptop installation

*First look for hints from the followings:*
- cat /proc/bus/input/devices | grep -i touchpad
    -> If there is something like 'Name="SynPS/2 Synaptics Touchpad"' or other variant,
       then list xinput with the following

       -> xinput list
            -> With these you should get a good hint about the type of touchpad you have.

*Once got done, and with the previous steps you could identify your touchpad,*
*then it is possible, that only the drivers are messing around.*

*Try to install the followings:*
- xserver-xorg-input-libinput 
- xserver-xorg-input-evdev 
- xserver-xorg-input-mouse

*Then reboot and hopefully these helped.*
---

* Fix broken virtualenv pip on ubuntu 22.04*

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py --force-reinstall

---

# Fix if the wifi is connected correctly, but cannot resolve the DNS.

* Fix for Ubuntu 24.04 *

sudo ln -s /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
