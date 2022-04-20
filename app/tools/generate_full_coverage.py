#!/usr/bin/env python

from pathlib import Path
from lib.pubspec import *


with open("test/full_coverage_test.dart", "w") as f:
    package = pubspec_read_name()
    f.write("// ignore_for_file: unused_import\n")
    for match in Path().glob("lib/**/*.dart"):
        if match.name.endswith(".g.dart"):
            continue
        if "generated_plugin_registrant" in match.name:
            continue
        path = match.relative_to("lib")
        f.write(f"import 'package:{package}/{path}';\n")
    f.write("\nvoid main() {}\n")


# vim: set et ts=4 sw=4:
