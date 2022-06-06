#!/usr/bin/env python3

import os
import logging
import re
from lxml import etree
logging.basicConfig(level=logging.DEBUG)

config_path = os.getenv('SYNCTHING_CONFIG_FILE', '/var/syncthing/config/config.xml')

logging.info('Reading config at %s', config_path)
tree = etree.parse(config_path)

logging.info('Injecting conf')
for k, v in os.environ.items():
  env_search = re.search('^SYNCTHING_CONF_([^_]+)_([^_]+)$', k)
  if not env_search:
    continue

  category = env_search.group(1)
  key = env_search.group(2)

  logging.debug('%s > %s = %s', category, key, v)

  items = tree.xpath(f'{category}/{key}')
  if items:
    for index, item in enumerate(items):
      if index > 0:
        logging.debug('Removing %s > %s [%d] (%s)', category, key, index, item.text)
        item.getparent().remove(item)
    items[0].text = v
  else:
    new = etree.SubElement(tree.xpath(category)[0], key)
    new.text = v


data_dir = os.getenv('SYNCTHING_DATA_DIR', '~')
logging.debug('Setting default fodler path to %s', data_dir)
df = tree.xpath('defaults/folder')[0]
df.set('path', data_dir)


logging.info('Writing config at %s', config_path)
tree.write(config_path)
