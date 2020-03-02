#!/usr/bin/env python2
import sys
sys.path.append('/opt/sabnzbd')

from os import path
from sabnzbd import config
from sabnzbd.utils import configobj

print("Reading sabnzbd config file")
config.read_config('/opt/sabnzbd-data/sabnzbd.ini')

print("Reading sabnzbd_delta config file")
configDelta = configobj.ConfigObj('/tmp/config/sabnzbd_delta.ini')

print("Merging the sabnzbd configs")
config.CFG.merge(configDelta)

print("Writing resulting sabnzbd config file")
with open('/opt/sabnzbd-data/sabnzbd.ini', 'w') as configfile:
    config.CFG.write(configfile)



if path.exists('/opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg'):
    print("Reading autoProcessMedia config file from existing file")
    autoProcessMediaPath='/opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg'
else:
    print("Reading autoProcessMedia config file from default file")
    autoProcessMediaPath='/opt/nzbToMedia/autoProcessMedia.cfg.spec'
config = configobj.ConfigObj(autoProcessMediaPath)

print("Reading autoProcessMedia_delta config file")
configDelta = configobj.ConfigObj('/tmp/config/autoProcessMedia_delta.cfg')

print("Merging the autoProcessMedia configs")
config.merge(configDelta)

print("Writing resulting autoProcessMedia config file")
with open('/opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg', 'w') as configfile:
    config.write(configfile)
