#!/usr/bin/env python3

import os
import sys
from pyload.__main__ import _parse_args
from pyload.core import Core
from pyload import APPID

envNamePrefix = "PYLOAD_CONF_"

cmd_args=sys.argv[1:]
args = _parse_args(cmd_args)
core_args = (args.userdir, args.tempdir, args.storagedir, args.debug, args.reset, args.dry_run)
print(f'Initializing pyload core with args {core_args}')
core = Core(*core_args)

print(f'Configuring pyload from environment variables {envNamePrefix}*')
for param in os.environ.keys():
    if param.startswith(envNamePrefix):
        propertySection, propertyName = param[len(envNamePrefix):].split("_", 1)
        propertyValue = os.environ[param]
        print(" - injecting %s - %s = %s" % (propertySection, propertyName, propertyValue))
        core.config.set(propertySection, propertyName, propertyValue)

print('Saving configuration')
core.config.save()

pyload_original_default_user = APPID
pyload_default_user = os.environ.get('PYLOAD_DEFAULT_USER')
pyload_default_password = os.environ.get('PYLOAD_DEFAULT_PASSWORD')
if pyload_default_user and pyload_default_password:
    print(f'Add or update user {pyload_default_user}')
    core.db.add_user(pyload_default_user, pyload_default_password, role=0)
    if pyload_default_user != pyload_original_default_user:
        print(f'Remove original default user {pyload_original_default_user}')
        core.db.remove_user(pyload_original_default_user)
