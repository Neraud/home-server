#!/usr/bin/env python3

from deluge.config import Config

print("Reading core conf")
config = Config('core.conf', None, '/config')

print("Adding core_delta")
config.load('/tmp/config/core_delta.conf')

print("Saving merged core conf")
config.save('/config/core.conf')


print("Reading web conf")
config = Config('web.conf', None, '/config')

print("Adding web_delta")
config.load('/tmp/config/web_delta.conf')

print("Saving merged web conf")
config.save('/config/web.conf')
