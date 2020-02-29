#!/usr/bin/env python2
import sys
sys.path.append('/opt/sickchill/lib/')

from configobj import ConfigObj

print("Reading config files :")
print(" - /opt/sickchill-data/config.ini")
config = ConfigObj('/opt/sickchill-data/config.ini', encoding='UTF-8', options={'indent_type': '  '})
print(" - /tmp/config/config_delta.ini")
config_delta = ConfigObj('/tmp/config/config_delta.ini', encoding='UTF-8', options={'indent_type': '  '})
config.merge(config_delta)

with open('/opt/sickchill-data/config.ini', 'w') as configfile:
  print("Writing to %s" % configfile.name)
  config.write(configfile)
