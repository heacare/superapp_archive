from pathlib import Path


def release_notes_write_beta(body: str):
    path = Path("fastlane", "metadata-beta-release-notes.txt")
    with open(path, "w") as f:
        f.write(body)


# vim: set et ts=4 sw=4:
