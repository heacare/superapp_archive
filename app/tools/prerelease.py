#!/usr/bin/env python

from lib.git import *
from lib.version import *
from lib.pubspec import *


git_ensure_status_clean()
# Increment build number
version = Version(pubspec_read_version())
print(f"Current version: {version}")
version.set_beta()
version.increment_build()
print(f"New version: {version}")
input("Press enter to continue")
pubspec_write_version(version)
# Perform Git commit
git_add(["pubspec.yaml"])
git_commit(f"chore: Release {version}")
# Perform Git tag
git_tag(f"v{version}")
# Perform Git push
input("Press enter to push")
git_push(["main", tag])


# vim: set et ts=4 sw=4:
