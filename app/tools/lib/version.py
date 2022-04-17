from typing import Optional, Tuple


def optional_rsplit(string: str, split: str) -> Tuple[str, Optional[str]]:
    parts = string.rsplit(split, 1)
    if len(parts) == 1:
        return parts[0], None
    elif len(parts) == 2:
        return parts[0], parts[1]


class Version:
    major: int
    minor: int
    patch: int
    prerelease: Optional[str] = None
    build: Optional[int] = None

    def __init__(self, string: str):
        core_prerelease, build = optional_rsplit(string, "+")
        if build is not None:
            self.build = int(build)
        core, prerelease = optional_rsplit(core_prerelease, "-")
        if prerelease is not None:
            self.prerelease = prerelease
        self.major, self.minor, self.patch = core.split(".")

    def __str__(self):
        string = f"{self.major}.{self.minor}.{self.patch}"
        if self.prerelease:
            string += f"-{self.prerelease}"
        if self.build:
            string += f"+{self.build}"
        return string

    def set_beta(self):
        self.prerelease = "beta"

    def increment_build(self):
        self.build += 1


# vim: set et ts=4 sw=4:
