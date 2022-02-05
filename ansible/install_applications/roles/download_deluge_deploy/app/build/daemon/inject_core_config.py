#!/usr/bin/python3

import os
import logging
import re
logging.basicConfig(level=logging.DEBUG)
from deluge.config import Config
from deluge.core.preferencesmanager import DEFAULT_PREFS as CORE_CONFIG_DEFAULTS

envNamePrefix = "DELUGE_CONF_CORE_"
configDir = '/home/deluge/.config/deluge'
configFileName = 'core.conf'
configPath = configDir + '/' + configFileName

if os.path.isfile(configPath):
    logging.info("Config file (%s) found, skipping defaults" % configPath)
    defaults = None
else:
    logging.info("Config file (%s) not found, loading defaults" % configPath)
    defaults = CORE_CONFIG_DEFAULTS

logging.info("Reading %s" % configFileName)
config = Config(configFileName, defaults, configDir)

for param in os.environ.keys():
    if param.startswith(envNamePrefix):
        propertyName = param[len(envNamePrefix):].lower()
        propertyValue = os.environ[param]
        if propertyValue.lower() in ("true", "yes"):
            propertyValue = True
        elif propertyValue.lower() in ("false", "no"):
            propertyValue = False
        elif re.match(r'^\[.*\]$', propertyValue):
            propertyValue = propertyValue[1:-1].split(',')

        logging.debug("Injecting %s = %s" % (propertyName, propertyValue))
        config[propertyName] = propertyValue

logging.info("Saving merged %s" % configFileName)
config.save(configPath)
