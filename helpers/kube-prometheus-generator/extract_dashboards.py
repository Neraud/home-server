#!/usr/bin/env python3

import sys
import yaml
import json
import re

configmap_path = sys.argv[1]
dashboards_dir = sys.argv[2]


# From https://gist.github.com/nvie/f304caf3b4f1ca4c3884
def traverse(obj, path=None, callback=None):
    """
    Traverse an arbitrary Python object structure (limited to JSON data
    types), calling a callback function for every element in the structure,
    and inserting the return value of the callback as the new value.
    """
    if path is None:
        path = []

    if isinstance(obj, dict):
        value = {k: traverse(v, path + [k], callback) for k, v in obj.items()}
    elif isinstance(obj, list):
        value = [traverse(elem, path + [[]], callback) for elem in obj]
    else:
        value = obj

    if callback is None:
        return value
    else:
        return callback(path, value)


def update_dashboard(path, value):
    # Fix link to other dashboard
    if path and path[-1] == "linkUrl" and value.startswith('./d/'):
        value = re.sub('./d/', '/grafana/d/', value)

    # Disable 'editable'
    if path and path[-1] == 'editable' and value:
        value = False

    if len(path) == 1 and path[0] == 'tags':
        # Add 'infra' tag
        if 'infra' not in value:
            value.insert(0, 'infra')
        # Rename 'kubernetes-mixin' tag
        if 'kubernetes-mixin' in value:
            value.remove('kubernetes-mixin')
            value.append('kubernetes')

    return value


print('Reading %s' % configmap_path)
with open(configmap_path) as file:
    configmaps = yaml.full_load(file)
    for configmap in configmaps['items']:
        for filename in configmap['data']:
            print(' - %s ' % filename)
            dashboard_json = json.loads(configmap['data'][filename])
            dashboard_json_updated = traverse(dashboard_json,
                                              callback=update_dashboard)
            formatted_json = json.dumps(dashboard_json_updated,
                                        indent=4,
                                        sort_keys=True)
            dashboard_path = '%s/%s' % (dashboards_dir, filename)
            with open(dashboard_path, 'w') as dashboard:
                dashboard.write(formatted_json)
