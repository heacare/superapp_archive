
# Widgets

We follow the principles behind [Atomic Design](https://atomicdesign.bradfrost.com/chapter-2/). When communicating, we prefer using Atomic Design terms. In this folder resides all the atoms (core widgets) and some molecules (common widgets) built upon the atoms. We intentionally don't have any distinction between those two types of widgets to keep things flexible within this folder.

Widgets that belong in this folder are feature-agnostic. They avoid using terminology specific to any feature. Such widgets are expected to be reused across features or future features.

Widgets in this folder should not interact directly with app features, but dispatch state management to their parent widgets. For most widget states, this might involve a `value` parameter and an `onChange` callback. The built-in Flutter input widgets (like [`Slider`](https://api.flutter.dev/flutter/material/Slider/onChanged.html) and [`TextField`](https://api.flutter.dev/flutter/material/TextField-class.html) are good references.

All widgets should be re-exported in `widgets.dart`.

<!-- vim: set conceallevel=2 et ts=2 sw=2: -->
