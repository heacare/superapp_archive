import re


def pubspec_read_version() -> str:
    # Read file
    with open("pubspec.yaml", "r") as f:
        pubspec = f.read()
    # Discover previous version number
    matches = re.findall("^version: .+$", pubspec, flags=re.MULTILINE)
    assert len(matches) == 1
    return matches[0].split(":")[1].strip()


def pubspec_write_version(version: str) -> str:
    # Read file
    with open("pubspec.yaml", "r") as f:
        pubspec = f.read()
    # Discover previous version number
    matches = re.findall("^version: .+$", pubspec, flags=re.MULTILINE)
    assert len(matches) == 1
    # Replace version number
    pubspec = pubspec.replace(matches[0], f"version: {version}")
    # Write file
    with open("pubspec.yaml", "w") as f:
        f.write(pubspec)


def pubspec_read_name() -> str:
    # Read file
    with open("pubspec.yaml", "r") as f:
        pubspec = f.read()
    # Discover package name
    matches = re.findall("^name: .+$", pubspec, flags=re.MULTILINE)
    assert len(matches) == 1
    return matches[0].split(":")[1].strip()


# vim: set et ts=4 sw=4:
