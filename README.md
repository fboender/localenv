localenv
========

About
-----

localenv is a collection of scripts that run other scripts and replace
(configuration) files depending on the current profile, which is determined by
the network you're currently on. It is ideal for laptop owners that move
between different networks.

### How does it work?

localenv determines the network you're on by obtaining the MAC address of certain computers or routers on the current network you're on. It then links that MAC address, and thus your specific location, to a profile.

The profile is then ran, and can replace files, runs commands, etc. 

Some examples include:

*   Automatically mount and unmount network shares on home networks.
*   Automatically signal that backups can be ran when you're on a specific network.

### Scripts

localenv is made up by a bunch of different scripts:


*   `localenv-init.d`

    init.d script that runs the scripts and configs in /etc/localenv.d/
    upon system boot.

*   `localenv-discover`

    Discovers which network you're on by comparing the MAC address of
    certain hosts on the network. See examples/localenv.d/localenv.conf for
    examples on how to specify hosts and MAC addresses. Outputs the profile
    name on stdout, or 'unknown' if the network couldn't be discovered. See
    below on how to figure out the MAC addresses of machines on your
    network.

*   `localenv-scripts`

    Runs scripts in a directory [path]/[profile]/scripts/ in the correct 
    order. See the examples/localenv.d/[profile]/scripts/ directory.

*   `localenv-script-wrapper`

    localenv-scripts uses this wrapper script to run the scripts in the
    profile directories. localenv-script-wrapper contains usefull functions
    which can be used in scripts.

*   `localenv-conf`

    Create, replace or append oonfiguration files depending on the profile.
    Reads all the files in [path]/[profile]/confs. Each file should be up
    like:

        dest=/path/to/conf/to/replace
        mode=overwrite (or) mode=append
        --
        REAL CONFIG CONTENTS

*   `localenv-run`

    Simple wrapper script that detects the network and runs
    localenv-scripts. This is the same as running:

        localenv-scripts `localenv-discover` PATH

    localenv-run also works for when you can't use backticks or other shell
    expansions.

Installation
------------

1.   Run ./install. This will copy the scripts to /usr/bin/
2.   Copy localenv-init.d to /etc/init.d/localenv if you're on a Linux system.
3.   Symlink /etc/init.d/localenv to the rcX.d directories to start localenv
     at boottime.

Configuration
-------------

Configuring localenv can be done in three steps:

*   `localenv-discover`
        
    localenv-discover uses the localenv.conf file to determine which profile
    you should currently be working with. It does this by pinging an IP on
    your network and then checking it's MAC address. Configuration lines in
    the file are made up like this:

        PROFILENAME    IP    MACADDRESS

    For instance,

        electricmonk.nl   192.168.1.1    00:20:18:B9:13:CD
        
*   `localenv-scripts`

    localenv-scripts scripts can be any kind of script like a Bash or PERL
    script. The script should have the executable flag set. Scripts can be
    prepended with a number to specify the order in which they should be
    run: 00_first  01_second

*   `localenv-confs`

    localenv-confs configuration files are normal configuration files but
    with a special header which will be parsed by localenv-confs. The files
    should look like this:

        dest=/path/to/conf/to/replace
        mode=overwrite (or) mode=append
        --
        REAL CONFIG CONTENTS

    Configuration files can be prepended with a number to specify the order
    in which they should be run: 00_first  01_second

### Running manual

You can also copy the skeleton directory localenv.d-skel to any directory,
for instance ~/.localenv.d and run it by hand or from your .xsession file.
To run localenv by hand, use the following commands:

    localenv-scripts `localenv-discover` /home/john/.localenv.d
    localenv-confs `localenv-discover` /home/john/.localenv.d

Copyright / License
-------------------

This stuff's in the PUBLIC DOMAIN.

Author: Ferry Boender <f DOT boender (@) electricmonk . NL>
