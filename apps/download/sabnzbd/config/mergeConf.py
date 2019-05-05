#!/usr/bin/env python2

import configobj

print("Reading config file")
config = configobj.ConfigObj('/config/sabnzbd.ini')

print("Reading delta config file")
configDelta = configobj.ConfigObj('/tmp/config/sabnzbd_delta.ini')

print("Merging the configs")
config.merge(configDelta)

print("Writing resulting config file")
with open('/config/sabnzbd.ini', 'w') as configfile:
    config.write(configfile)
