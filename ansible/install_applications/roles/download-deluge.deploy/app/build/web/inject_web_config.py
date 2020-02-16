#!/usr/bin/python

import os
import logging
logging.basicConfig(level=logging.DEBUG)
from deluge.config import Config
from deluge.ui.web.server import CONFIG_DEFAULTS as WEB_CONFIG_DEFAULTS

envNamePrefix = "DELUGE_CONF_WEB_"
configDir = '/home/deluge/.config/deluge'
configFileName = 'web.conf'
configPath = configDir + '/' + configFileName

if os.path.isfile(configPath):
    logging.info("Config file (%s) found, skipping defaults" % configPath)
    defaults = None
else:
    logging.info("Config file (%s) not found, loading defaults" % configPath)
    defaults = WEB_CONFIG_DEFAULTS

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

        logging.debug("Injecting %s = %s" % (propertyName, propertyValue))
        config[propertyName] = propertyValue

logging.info("Saving merged %s" % configFileName)
config.save(configPath)
