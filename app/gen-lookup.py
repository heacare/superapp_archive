from re import findall
from pathlib import Path

for m in Path('lib', 'pages').iterdir():
    imports = ['package:hea/widgets/page.dart']
    pagedefs = []

    for chapter in sorted(m.iterdir()):
        if 'lookup' in chapter.name:
            continue
        imports.append(chapter.name)
        with open(chapter, "r") as f:
            name = None
            nextPage = None
            prevPage = None
            for line in f:
                if name is not None and "Page" in name and nextPage is None:
                    nextPage = []
                if nextPage is None and "nextPage = " in line:
                    nextPage = []
                    if ";" in line:
                        nextPage = line.split(" = ")[1]
                if nextPage is None and "nextPage: " in line:
                    nextPage = []
                    if "," in line:
                        nextPage = line.split(": ")[1]
                if "nextPageStringList" in line:
                    nextPage = []
                if prevPage is None and "prevPage = " in line:
                    prevPage = []
                    if ";" in line:
                        prevPage = line.split(" = ")[1]
                if type(nextPage) is list:
                    nextPage.append(line)
                    if "};" in line:
                        nextPage = "".join(nextPage)
                    elif line.endswith(",\n"):
                        nextPage = "".join(nextPage)
                    elif "Page" not in name and line == "  }\n":
                        nextPage = "".join(nextPage)
                    elif "Page" in name and line == "}\n":
                        nextPage = "".join(nextPage)
                if type(prevPage) is list:
                    prevPage.append(line)
                    if "};" in line:
                        prevPage = "".join(prevPage)
                if (line.startswith("class ") and "State<" not in line) or (line.startswith("Widget") and "Page(" in line):
                    if name is not None:
                        pagedefs.append((
                            name,
                            nextPage,
                            prevPage,
                        ))
                    name = line.split(" ")[1]
                    name = name.split("(")[0]
                    nextPage = None
                    prevPage = None
            pagedefs.append((
                name,
                nextPage,
                prevPage,
            ))

    lookup = []
    for item in imports:
        lookup.append(f"import '{item}';")
    lookup.append("")
    lookup.append(f"Lesson {m.name} = Lesson([")
    for item, nextPage, prevPage in pagedefs:
        if "Page" in item:
            continue
        lookup.append(f"  PageDef({item}, () => {item}()),")
    lookup.append("]);")

    with open(m / "lookup.dart", "w") as f:
        f.write("\n".join(lookup))
        f.write("\n")

    # Simple graph

    items = [item for item, nextPage, prevPage in pagedefs]
    with open(f"{m.name}.dot", "w") as f:
        f.write("digraph G {\n")
        for item, nextPage, prevPage in pagedefs:
            if nextPage is not None:
                nextPages = findall(r"\w+", nextPage)
                for p in nextPages:
                    if p in items:
                        f.write(f'{item} -> {p} [label="next"];\n')
            if prevPage is not None:
                prevPages = findall(r"\w+", prevPage)
                for p in prevPages:
                    if p in items:
                        f.write(f'{item} -> {p} [label="prev",style="dashed"];\n')
        f.write("}\n")

    # Copy-paste code

    # For sleep_notifications.dart
    for item, nextPage, prevPage in pagedefs:
        print(f's == "{item}" ||')



# vim: set et ts=4 sw=4:
