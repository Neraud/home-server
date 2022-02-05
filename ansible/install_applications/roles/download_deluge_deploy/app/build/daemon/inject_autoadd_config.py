#!/usr/bin/python3

import os
import re
import logging
logging.basicConfig(level=logging.DEBUG)
from deluge.config import Config

import sys
import sysconfig
import glob
auto_add_pattern = f"{sysconfig.get_paths()['purelib']}/deluge/plugins/AutoAdd*-py{sys.version_info.major}.{sys.version_info.minor}.egg"
sys.path.append(glob.glob(auto_add_pattern)[0])
from deluge_autoadd.core import DEFAULT_PREFS as AUTOADD_CONFIG_DEFAULTS

envNamePrefix = "DELUGE_CONF_AUTOADD_"
configDir = '/home/deluge/.config/deluge'
configFileName = 'autoadd.conf'
configPath = configDir + '/' + configFileName

if os.path.isfile(configPath):
    logging.info("Config file (%s) found, skipping defaults" % configPath)
    defaults = None
else:
    logging.info("Config file (%s) not found, loading defaults" % configPath)
    defaults = AUTOADD_CONFIG_DEFAULTS

logging.info("Reading %s" % configFileName)
config = Config(configFileName, defaults, configDir)

envWatchDirs = {}

for param in os.environ.keys():
    if param.startswith(envNamePrefix):
        confIndex = re.sub(r'_.*', '', param[len(envNamePrefix):])
        propertyName = param[len(envNamePrefix)+len(confIndex)+1:].lower()
        propertyValue = os.environ[param]
        if propertyValue.lower() in ("true", "yes"):
            propertyValue = True
        elif propertyValue.lower() in ("false", "no"):
            propertyValue = False

        logging.debug("Read property for index %s : %s = %s" % (confIndex, propertyName, propertyValue))
        if not confIndex in envWatchDirs:
            envWatchDirs[confIndex] = {}
        envWatchDirs[confIndex][propertyName] = propertyValue

if envWatchDirs:
    for confIndex in envWatchDirs.keys():
        logging.debug("Injecting watchdir id = %s" % confIndex)

        if 'path' in envWatchDirs[confIndex] and not 'abspath' in envWatchDirs[confIndex]:
            envWatchDirs[confIndex]['abspath'] = os.path.abspath(envWatchDirs[confIndex]['path'])

        if not confIndex in config['watchdirs']:
            config['watchdirs'][confIndex] = {}

        for propertyName in envWatchDirs[confIndex].keys():
            propertyValue = envWatchDirs[confIndex][propertyName]
            logging.debug(" - %s = %s" % (propertyName, propertyValue))
            config['watchdirs'][confIndex][propertyName] = propertyValue

        if not 'enabled' in config['watchdirs'][confIndex]:
            logging.debug(" - %s = %s" % ('enabled', True))
            config['watchdirs'][confIndex]['enabled'] = True

nextId = max(list(map(int, config['watchdirs'].keys()))) + 1

logging.debug("Settings next_id = %s" % nextId)
config['next_id'] = nextId

logging.info("Saving merged %s" % configFileName)
config.save(configPath)
