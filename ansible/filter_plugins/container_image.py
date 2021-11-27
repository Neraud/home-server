#!/usr/bin/python

from ansible.errors import AnsibleUndefinedVariable
from ansible.module_utils._text import to_native


class FilterModule(object):

    def filters(self):
        return {
            'image_full_name': self.image_full_name,
        }

    def image_full_name(self, image_dict):
        ''' Return the full name of the image (repo/name:tag) '''

        try:
            return f"{image_dict['repo']}/{image_dict['name']}:{image_dict['tag']}"
        except KeyError as e:
            raise AnsibleUndefinedVariable(
                f"Missing key {to_native(e)} in image dict {image_dict}"
            )
