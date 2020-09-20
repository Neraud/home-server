#!/usr/bin/env python3
import sys
sys.path.append('/opt/sabnzbd')

from os import path
from shutil import copyfile
from sabnzbd import config
import configobj

config_path = '/opt/sabnzbd-data/sabnzbd.ini'
config_delta_path = '/tmp/config/sabnzbd_delta.ini'

print("Reading sabnzbd config file")
config.read_config(config_path)

print("Reading sabnzbd_delta config file")
configDelta = configobj.ConfigObj(config_delta_path)

print("Merging the sabnzbd configs")
config.CFG.merge(configDelta)

print("Writing resulting sabnzbd config file")
config.CFG.write()


config_nzbtomedia_path = '/opt/sabnzbd-data/nzbtomedia/autoProcessMedia.cfg'
config_nzbtomedia_delta_path = '/tmp/config/autoProcessMedia_delta.cfg'

if path.exists(config_nzbtomedia_path):
    print("Reading autoProcessMedia config file from existing file")
else:
    print("Reading autoProcessMedia config file from default file")    
    copyfile('/opt/nzbToMedia/autoProcessMedia.cfg.spec', config_nzbtomedia_path)
config = configobj.ConfigObj(config_nzbtomedia_path)

print("Reading autoProcessMedia_delta config file")
configDelta = configobj.ConfigObj(config_nzbtomedia_delta_path)

print("Merging the autoProcessMedia configs")
config.merge(configDelta)

print("Writing resulting autoProcessMedia config file")
config.write()
