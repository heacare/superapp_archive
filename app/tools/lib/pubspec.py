import re


def pubspec_read_version() -> str:
    # Read file
    with open("pubspec.yaml", "r") as f:
        pubspec = f.read()
    # Discover previous version number
    matches = re.findall("^version: .+$", pubspec, flags=re.MULTILINE)
    assert len(matches) == 1
    version_line = matches[0]
    return version_line.split(":")[1].strip()


def pubspec_write_version(version: str) -> str:
    # Read file
    with open("pubspec.yaml", "r") as f:
        pubspec = f.read()
    # Discover previous version number
    matches = re.findall("^version: .+$", pubspec, flags=re.MULTILINE)
    assert len(matches) == 1
    version_line = matches[0]
    # Replace version number
    pubspec = pubspec.replace(version_line, f"version: {version}")
    # Write file
    with open("pubspec.yaml", "w") as f:
        f.write(pubspec)


# vim: set et ts=4 sw=4:
