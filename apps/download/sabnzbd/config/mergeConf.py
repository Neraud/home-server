#!/usr/bin/env python2

import configobj

print("Reading sabnzbd config file")
config = configobj.ConfigObj('/config/sabnzbd.ini')

print("Reading sabnzbd_delta config file")
configDelta = configobj.ConfigObj('/tmp/config/sabnzbd_delta.ini')

print("Merging the sabnzbd configs")
config.merge(configDelta)

print("Writing resulting sabnzbd config file")
with open('/config/sabnzbd.ini', 'w') as configfile:
    config.write(configfile)

print("Reading autoProcessMedia config file")
config = configobj.ConfigObj('/config/autoProcessMedia.cfg')

print("Reading autoProcessMedia_delta config file")
configDelta = configobj.ConfigObj('/tmp/config/autoProcessMedia_delta.cfg')

print("Merging the autoProcessMedia configs")
config.merge(configDelta)

print("Writing resulting autoProcessMedia config file")
with open('/config/autoProcessMedia.cfg', 'w') as configfile:
    config.write(configfile)
