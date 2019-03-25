#!/usr/bin/python

import binascii

class FilterModule(object):
    def filters(self):
        return {
            'hexlify': self.hexlify
        }

    def hexlify(self, str):
        """
        hexlify a string
        See : https://docs.python.org/2/library/binascii.html#binascii.hexlify

        For example :
        * 'test' -> '74657374'
        * 'AZERTY' -> '415a45525459'

        :param str: the input string
        :returns: the hexlified string
        """
        return binascii.hexlify(str)
