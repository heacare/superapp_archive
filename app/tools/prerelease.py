#!/usr/bin/env python

from lib.git import *
from lib.version import *
from lib.pubspec import *
from lib.release_notes import *


git_ensure_status_clean()
# Ensure pushed
git_push(["main"])
# Set release_notes
print("In past tense, describe the changes that have been made")
release_notes = input("Release notes: ")
release_notes_write_beta(release_notes)
# Increment build number
version = Version(pubspec_read_version())
print(f"Current version: {version}")
version.set_beta()
version.increment_build()
print(f"New version: {version}")
input("Press enter to continue")
pubspec_write_version(version)
# Perform Git commit
git_add(["fastlane/metadata-beta-release-notes.txt", "pubspec.yaml"])
git_commit(f"chore: Release {version}")
# Perform Git tag
tag = f"v{version}"
git_tag(tag)
# Perform Git push
input("Press enter to push")
git_push(["main", tag])


# vim: set et ts=4 sw=4:
