#!/usr/bin/env python3

from configobj import ConfigObj
import sys
# sys.path.append('/opt/sickchill/lib3/')


config_delta_path = sys.argv[1]
config_path = sys.argv[2]

config_options = {'indent_type': '  '}

print("Reading config files :")
print(" - %s" % config_path)
config = ConfigObj(config_path, encoding='UTF-8', **config_options)
print(" - %s" % config_delta_path)
config_delta = ConfigObj(config_delta_path, encoding='UTF-8', **config_options)
config.merge(config_delta)
config.write()
