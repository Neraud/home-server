#!/usr/bin/env python3
import sys
sys.path.append('/opt/sickchill/lib3/')

from configobj import ConfigObj

config_path = '/opt/sickchill-data/config.ini'
config_delta_path = '/tmp/config/config_delta.ini'

print("Reading config files :")
print(" - %s" % config_path)
config = ConfigObj(config_path, encoding='UTF-8', options={'indent_type': '  '})
print(" - %s" % config_delta_path)
config_delta = ConfigObj(config_delta_path, encoding='UTF-8', options={'indent_type': '  '})
config.merge(config_delta)
config.write()
