pi-opencv-bootstrap
===

Installs dependencies and compiles OpenCV on a fresh Raspbian install.

Heavily borrows from [these steps](https://www.pyimagesearch.com/2017/09/04/raspbian-stretch-install-opencv-3-python-on-your-raspberry-pi/).

## Requirements

This branch assumes the following:

- Raspberry Pi 3+
- Fresh install of [Raspbian Stretch](https://www.raspberrypi.org/downloads/raspbian/)

## Preparations

These steps are highly recommended to be done before running the bootstrap script on your hardware:

---

### Expand the file system

This should have been done automatically for you during your first boot,
but if it wasn't:

1. `sudo raspi-config`
2. Select **Advanced Options**
3. Select **Expand Filesystem**
4. Reboot the pi (e.g. `sudo reboot now`)

You should be able to confirm the change by running `df -h` and ensuring that
the pi is using all available space on your card.

---

### Remove superfluous apps on the pi

This step should free up around **~1 GB** of additional space on your card.

```
sudo apt-get purge -y wolfram-engine libreoffice*
sudo apt-get clean -y
sudo apt-get autoremove -y
```

---

### Expand your swap file

This step enables the pi to use all four cores during the compilation process later.

1. Open `/etc/dphys-swapfile` using your editor of choice
   (`nano` is preinstalled; you will have to `sudo apt-get install vim` if you prefer that)

2. Edit the `CONF_SWAPSIZE` assignment to read `CONF_SWAPSIZE=1024`, then save and close the file.
3. Activate the new swap space using:

```
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
```

> **IMPORTANT:** Don't forget to bring the swap file size back to its default (100) 
> after we're done with all the bootstrapping.


---

### Install a terminal multiplexer

If you're going to be working with your pi over `ssh`, then having a terminal multiplexer
like `tmux` will allow you to disconnect and reconnect to your pi without killing the 
bootstrapping process. Useful for patchy connections, or when you just want the option
to be able to walk away from the process if you need to (the compilation takes about ~2 hours).

```
sudo apt-get install -y tmux
```

To use:
1. After you've `ssh`'ed into your pi, run `tmux`. This creates a session.
2. To detach from your session (and have it continue to run), press `Ctrl+B`, `D` (by default).
3. To reattach to your session (e.g. when you've disconnected and reconnected your `ssh` connection), run `tmux a`.

---

## Cleanup

After the bootstrap script is done, don't forget to 
revert your swapfile size back to normal levels.

Not doing so will significantly shorten the life
of your SD card.
