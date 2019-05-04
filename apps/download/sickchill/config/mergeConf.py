#!/usr/bin/env python3

import configparser

config = configparser.ConfigParser()
# Do not lowercase keys : https://stackoverflow.com/a/19359720
config.optionxform = str

print("Reading config files :")
filesRead = config.read(['/config/config.ini', '/tmp/config/config_delta.ini'])
print(filesRead)

with open('/config/config.ini', 'w') as configfile:
    print("Writing to /config/config.ini")
    config.write(configfile)
