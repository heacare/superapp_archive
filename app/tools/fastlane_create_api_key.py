#!/usr/bin/env python

import json


print("Proceed to generate an App Store Connect API key. Name it fastlane-hea")
key_id = input("Key ID: ")
issuer_id = input("Issuer ID: ")
key_path = input("Path to key (.p8): ")
with open(key_path, "r") as f:
    key = f.read()
key_json = {
    "key_id": key_id,
    "issuer_id": issuer_id,
    "key": key,
}
print(json.dumps(key_json))


# vim: set et ts=4 sw=4:
