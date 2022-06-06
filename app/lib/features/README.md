
# Features

This folder contains business logic separated into folders for each operational domain. Each folder should contain code specific to the feature, including interfaces, abstractions, constants and widgets.

Each feature should expose a public API in a single file named after the feature (`feature_name/feature_name.dart`). This forces clean interfaces between features. A feature should never call into another feature's internal implementation. This model will allow us to easily break features into their own plugin when warranted.

Features with more than one public method must be implemented as an interface to aid unit testing.

A feature may have sub-features, but the decision must be made with care. Sub-features exist as folders within the feature.

A feature usually includes widgets, defined across files with the suffix `_widget.dart`, `_module.dart` or `_screen.dart`. The distinction between the two follows the principles behind [Atomic Design](https://atomicdesign.bradfrost.com/chapter-2/). When communicating, we prefer using Atomic Design terms.

- `_widget.dart` widgets are molecules (components), a set of atoms (core widgets) working together to present information and provide some feature-specific functionality. List items are an example of such a widget. Atoms should not be defined in feature folders.
- `_module.dart` widgets are organisms (large components), large widgets that consists of various atoms arraged to provide repetitive functionality across the feature. Lists are an example of such a widget.
- `_screen.dart` widgets are templates (and at the same time, pages), which is an arrangement of organisms on a screen to form a structure of visual elements. Additionally, screens should be responsible for populating themselves with data.

A features' templates (screens) should responsible for majority of state management. This is to enable optimisations such as efficient search queries, and handle state effectively.

Templates are also responsible for being responsive to screen size. They may choose to place modules side-by-side, open up cards, or trigger navigation to a child screen (like a list item's details page).

<!-- vim: set conceallevel=2 et ts=2 sw=2: -->
