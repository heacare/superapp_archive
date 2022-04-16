#!/usr/bin/env python

from subprocess import run
import re


# Read pubspec
with open("pubspec.yaml", "r") as f:
    pubspec = f.read()
# Discover previous version number
matches = re.findall("^version: .+$", pubspec, flags=re.MULTILINE)
assert len(matches) == 1
version_line = matches[0]
version = version_line.split(":")[1].strip()
print(f"Current version: {version}")
# Parse version
version_name, version_number = version.split("+")
# Increment build number
version_number = int(version_number) + 1
# Parse version name
version_name_parts = version_name.split("-")
version_xyz = version_name_parts[0]
version_prerelease = "beta.0"
if len(version_name_parts) == 2:
    version_prerelease = version_name_parts[1]
# Parse version prerelease
version_prerelease_type, version_prerelease_number = version_prerelease.split(".")
# Increment version prerelease number
version_prerelease_number = int(version_prerelease_number) + 1
# Write new version
version_prerelease = f"{version_prerelease_type}.{version_prerelease_number}"
version_name = f"{version_xyz}-{version_prerelease}"
version = f"{version_name}+{version_number}"
pubspec = pubspec.replace(version_line, f"version: {version}")
print(f"New version: {version}")
input("Press enter to continue")
# Write pubspec
with open("pubspec.yaml", "w") as f:
    f.write(pubspec)
# Perform Git commit
run(["git", "add", "pubspec.yaml"], check=True)
message = f"chore: Release {version}"
run(["git", "commit", "-m", message], check=True)
# Perform Git tag
tag = f"v{version}"
run(["git", "tag", tag], check=True)
# Perform Git push
input("Press enter to push")
run(["git", "push", "origin", "main", tag], check=True)


# vim: set et ts=4 sw=4:
