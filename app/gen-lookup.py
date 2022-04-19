from pathlib import Path

for m in Path('lib', 'pages').iterdir():
    imports = ['package:hea/widgets/page.dart']
    pagedefs = []

    for chapter in sorted(m.iterdir()):
        if 'lookup' in chapter.name:
            continue
        imports.append(chapter.name)
        with open(chapter, "r") as f:
            for line in f:
                if line.startswith("class ") and "State" not in line:
                    name = line.split(" ")[1]
                    pagedefs.append(name)

    lookup = []
    for item in imports:
        lookup.append(f"import '{item}';")
    lookup.append("")
    lookup.append(f"Lesson {m.name} = Lesson([")
    for item in pagedefs:
        lookup.append(f"  PageDef({item}, () => {item}()),")
    lookup.append("]);")

    with open(m / "lookup.dart", "w") as f:
        f.write("\n".join(lookup))
        f.write("\n")

    # Copy-paste code

    # For sleep_notifications.dart
    for item in pagedefs:
        print(f's == "{item}" ||')


# vim: set et ts=4 sw=4:
