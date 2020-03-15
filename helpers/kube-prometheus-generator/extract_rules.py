#!/usr/bin/env python3

import sys
import yaml

in_path = sys.argv[1]
out_dir = sys.argv[2]

print('Reading %s' % in_path)
with open(in_path) as in_file:
    in_rules = yaml.full_load(in_file)
    for in_rule in in_rules['spec']['groups']:
        rule_name = in_rule['name']
        print(' - %s' % rule_name)

        dashboard_path = '%s/%s.yaml' % (out_dir, rule_name)
        formatted_yaml = yaml.dump([in_rule])
        with open(dashboard_path, 'w') as out_file:
            out_file.write(formatted_yaml)
