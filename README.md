TinySetup
=========

TinySetup can be used to setup a new TinyTitan unit in just a few steps.

## Step One
Step one will update each Raspberry Pi and configure the name and network settings. To start connect each Pi that will be part of the TinyTitan cluster to an active internet connection. Download the initial setup script and run it in a terminal as such:

```
$ curl -kfsSLO https://raw.github.com/TinyTitan/TinySetup/master/pi_setup.sh
$ bash pi_setup.sh
```

When prompted for the node number start at 1 and incriment to the total number of Raspberry Pi nodes.

## Step Two
With step one completed on all nodes connect each node to the router or switch. On the Pi that was given a node number of 1 login and download/run the second script:

```
$ git clone https://github.com/TinyTitan/TinySetup.git
$ cd TinySetup
$ bash pi_post_setup.sh
```

## Step Three
Your TinyTitan unit should now be ready to go. Checkout the TinySPH and PiBrot examples available through the TinyTitan repo.
