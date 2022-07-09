#!/usr/bin/env python

from typing import Optional, Generator, Callable
from pathlib import Path
from shutil import copyfile
from argparse import ArgumentParser
from json import dump as dump_json
from xml.dom.minidom import parse as parse_xml, Node, Attr
from lib.pubspec import *


def iterate_node_attributes(node: Node) -> Generator[Attr, None, None]:
    if node.attributes is None:
        return
    for i in range(node.attributes.length):
        yield node.attributes.item(i)


def iterate_all_nodes(parent_node: Node) -> Generator[Node, None, None]:
    for node in parent_node.childNodes:
        yield node
    for node in parent_node.childNodes:
        yield from iterate_all_nodes(node)


def export_vectordrawable(input: str, output: str, width: int):
    paths = []
    with open(input, "r") as f:
        with parse_xml(f) as svg:
            for node in iterate_all_nodes(svg):
                if node.nodeType != Node.ELEMENT_NODE:
                    continue
                if node.tagName != "path":
                    continue
                path = {}
                for attr in iterate_node_attributes(node):
                    path[attr.name] = attr.value
                if "style" in path and "fill" in path["style"]:
                    fill = re.findall(r"fill:([^;]+)", path["style"])
                    path["fill"] = fill
                if "fill" in path and "url(" in path["fill"]:
                    raise UnsupportedSVGError
                paths.append(path)
    with open(output, "w") as f:
        f.write(
            f'<vector xmlns:android="http://schemas.android.com/apk/res/android" android:width="{width}dp" android:height="{width}dp" android:viewportWidth="{width}" android:viewportHeight="{width}">'
        )
        for path in paths:
            d, fill = path["d"], path["fill"]
            if fill == "white":
                fill = "#fff"
            if fill == "black":
                fill = "#000"
            f.write(f'<path android:pathData="{d}" android:fillColor="{fill}"/>')
        f.write("</vector>")


class UnsupportedSVGError(Exception):
    pass


parser = ArgumentParser()
parser.add_argument("source", help="source asset folder containing Figma exports")
args = parser.parse_args()

source = Path(args.source)


print("Android")
android_res = Path("android", "app", "src", "main", "res")


def android_copy_raster(input_name: str, output_name: str, type: str = "drawable"):
    dpis = ("ldpi", "mdpi", "hdpi", "xhdpi", "xxhdpi", "xxxhdpi")
    for dpi in dpis:
        source_file = source / f"{input_name}@{dpi.upper()}.png"
        if source_file.is_file():
            res_dpi = android_res / f"{type}-{dpi}"
            res_dpi.mkdir(exist_ok=True)
            copyfile(source_file, res_dpi / f"{output_name}.png")


android_copy_raster("android_icon_background", "ic_launcher_background")
android_copy_raster("android_icon_legacy", "ic_launcher", type="mipmap")
export_vectordrawable(
    source / "android_icon_foreground.svg",
    android_res / "drawable-v26" / "ic_launcher_foreground.xml",
    108,
)
android_res_anydpi = android_res / "mipmap-anydpi-v26"
android_res_anydpi.mkdir(exist_ok=True)
with open(android_res_anydpi / "ic_launcher.xml", "w") as f:
    f.write(
        '<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">'
        '<background android:drawable="@drawable/ic_launcher_background"/>'
        '<foreground android:drawable="@drawable/ic_launcher_foreground"/>'
        "</adaptive-icon>"
    )
# Notifications
android_copy_raster("android_icon_notification", "notification_icon")
android_res_drawable_v21 = android_res / "drawable-v21"
android_res_drawable_v21.mkdir(exist_ok=True)
export_vectordrawable(
    source / "android_icon_notification.svg",
    android_res_drawable_v21 / "notification_icon.xml",
    24,
)


print("iOS")
apple_images = {
    "images": [
        {
            "size": "20x20",
            "idiom": "iphone",
            "filename": "Icon-App-20x20@2x.png",
            "scale": "2x",
        },
        {
            "size": "20x20",
            "idiom": "iphone",
            "filename": "Icon-App-20x20@3x.png",
            "scale": "3x",
        },
        {
            "size": "29x29",
            "idiom": "iphone",
            "filename": "Icon-App-29x29@1x.png",
            "scale": "1x",
        },
        {
            "size": "29x29",
            "idiom": "iphone",
            "filename": "Icon-App-29x29@2x.png",
            "scale": "2x",
        },
        {
            "size": "29x29",
            "idiom": "iphone",
            "filename": "Icon-App-29x29@3x.png",
            "scale": "3x",
        },
        {
            "size": "40x40",
            "idiom": "iphone",
            "filename": "Icon-App-40x40@2x.png",
            "scale": "2x",
        },
        {
            "size": "40x40",
            "idiom": "iphone",
            "filename": "Icon-App-40x40@3x.png",
            "scale": "3x",
        },
        {
            "size": "60x60",
            "idiom": "iphone",
            "filename": "Icon-App-60x60@2x.png",
            "scale": "2x",
        },
        {
            "size": "60x60",
            "idiom": "iphone",
            "filename": "Icon-App-60x60@3x.png",
            "scale": "3x",
        },
        {
            "size": "20x20",
            "idiom": "ipad",
            "filename": "Icon-App-20x20@1x.png",
            "scale": "1x",
        },
        {
            "size": "20x20",
            "idiom": "ipad",
            "filename": "Icon-App-20x20@2x.png",
            "scale": "2x",
        },
        {
            "size": "29x29",
            "idiom": "ipad",
            "filename": "Icon-App-29x29@1x.png",
            "scale": "1x",
        },
        {
            "size": "29x29",
            "idiom": "ipad",
            "filename": "Icon-App-29x29@2x.png",
            "scale": "2x",
        },
        {
            "size": "40x40",
            "idiom": "ipad",
            "filename": "Icon-App-40x40@1x.png",
            "scale": "1x",
        },
        {
            "size": "40x40",
            "idiom": "ipad",
            "filename": "Icon-App-40x40@2x.png",
            "scale": "2x",
        },
        {
            "size": "76x76",
            "idiom": "ipad",
            "filename": "Icon-App-76x76@1x.png",
            "scale": "1x",
        },
        {
            "size": "76x76",
            "idiom": "ipad",
            "filename": "Icon-App-76x76@2x.png",
            "scale": "2x",
        },
        {
            "size": "83.5x83.5",
            "idiom": "ipad",
            "filename": "Icon-App-83.5x83.5@2x.png",
            "scale": "2x",
        },
        {
            "size": "1024x1024",
            "idiom": "ios-marketing",
            "filename": "Icon-App-1024x1024@1x.png",
            "scale": "1x",
        },
    ],
    "info": {"version": 1, "author": "xcode"},
}
ios_icon = Path("ios", "Runner", "Assets.xcassets", "AppIcon.appiconset")
ios_icon.mkdir(exist_ok=True)
with open(ios_icon / "Contents.json", "w") as f:
    dump_json(apple_images, f)
for image in apple_images["images"]:
    width = image["size"].split("x")[0]
    scale = image["scale"]
    output_name = image["filename"]
    input_name = "ios_icon"
    copyfile(source / f"{input_name}-{width}@{scale}.png", ios_icon / output_name)

# vim: set et ts=4 sw=4:
