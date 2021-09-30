#!/usr/bin/python

import os
import hashlib
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

if 'DELUGE_WEB_PASSWORD' in os.environ:
    logging.info("DELUGE_WEB_PASSWORD detected")
    clearPassword = os.environ['DELUGE_WEB_PASSWORD']

    if 'DELUGE_WEB_SALT' in os.environ:
        salt = os.environ['DELUGE_WEB_SALT']
        logging.info("DELUGE_WEB_SALT detected, using it as salt : %s" % salt)
    else:
        salt = config['pwd_salt']
        logging.info(
            "DELUGE_WEB_SALT not detected, using the existing salt : %s" %
            salt)

    s = hashlib.sha1(salt.encode('utf-8'))
    s.update(clearPassword.encode('utf8'))
    hashedPassword = s.hexdigest()

    if salt != config['pwd_salt'] or hashedPassword != config['pwd_sha1']:
        logging.info("Changing password and/or salt")
        logging.debug("pwd_salt = %s" % salt)
        config['pwd_salt'] = salt
        logging.debug("pwd_sha1 = %s" % hashedPassword)
        config['pwd_sha1'] = hashedPassword
        # Set first_login to avoid being promted to change the password
        logging.debug("first_login = %s" % False)
        config['first_login'] = False
    else:
        logging.info("Password and salt are unchanged")
else:
    logging.info("DELUGE_WEB_PASSWORD not detected")

logging.info("Saving merged %s" % configFileName)
config.save(configPath)
