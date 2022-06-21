import 'package:flutter/material.dart';

import '../system/theme.dart' as hea_theme show Theme;

class DemoScreen extends StatelessWidget {
  const DemoScreen({super.key});
  @override
  Widget build(BuildContext context) => ListView(
        children: <Widget>[
          Text(
            MaterialLocalizations.of(context).formatCompactDate(DateTime.now()),
          ),
          const ComponentScreen(showNavBottomBar: false),
          const ColorPalettesScreen(),
        ],
      );
}

class ComponentScreen extends StatelessWidget {
  const ComponentScreen({super.key, required this.showNavBottomBar});

  final bool showNavBottomBar;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: _maxWidthConstraint,
          child: Column(
            children: [
              _colDivider,
              _colDivider,
              const Buttons(),
              _colDivider,
              const FloatingActionButtons(),
              _colDivider,
              const Cards(),
              _colDivider,
              const Dialogs(),
              _colDivider,
              if (showNavBottomBar)
                const NavigationBars(
                  selectedIndex: 0,
                  isExampleBar: true,
                )
              else
                Container(),
            ],
          ),
        ),
      );
}

const SizedBox _rowDivider = SizedBox(width: 10);
const SizedBox _colDivider = SizedBox(height: 10);
const double _cardWidth = 115;
const double _maxWidthConstraint = 400;

void Function()? handlePressed(
  BuildContext context,
  bool isDisabled,
  String buttonName,
) =>
    isDisabled
        ? null
        : () {
            SnackBar snackBar = SnackBar(
              content: Text(
                'Yay! $buttonName is clicked!',
              ),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {},
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          };

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) => Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: const <Widget>[
          ButtonsWithoutIcon(isDisabled: false),
          _rowDivider,
          ButtonsWithIcon(),
          _rowDivider,
          ButtonsWithoutIcon(isDisabled: true),
        ],
      );
}

class ButtonsWithoutIcon extends StatelessWidget {
  const ButtonsWithoutIcon({super.key, required this.isDisabled});
  final bool isDisabled;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
              onPressed: handlePressed(context, isDisabled, 'ElevatedButton'),
              child: const Text('Elevated'),
            ),
            _colDivider,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                // Background color
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
              onPressed: handlePressed(context, isDisabled, 'FilledButton'),
              child: const Text('Filled'),
            ),
            _colDivider,
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                // Background color
                primary: Theme.of(context).colorScheme.secondaryContainer,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
              onPressed:
                  handlePressed(context, isDisabled, 'FilledTonalButton'),
              child: const Text('Filled Tonal'),
            ),
            _colDivider,
            OutlinedButton(
              onPressed: handlePressed(context, isDisabled, 'OutlinedButton'),
              child: const Text('Outlined'),
            ),
            _colDivider,
            TextButton(
              onPressed: handlePressed(context, isDisabled, 'TextButton'),
              child: const Text('Text'),
            ),
          ],
        ),
      );
}

class ButtonsWithIcon extends StatelessWidget {
  const ButtonsWithIcon({super.key});

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed:
                  handlePressed(context, false, 'ElevatedButton with Icon'),
              icon: const Icon(Icons.add),
              label: const Text('Icon'),
            ),
            _colDivider,
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                // Background color
                primary: Theme.of(context).colorScheme.primary,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
              onPressed:
                  handlePressed(context, false, 'FilledButton with Icon'),
              label: const Text('Icon'),
              icon: const Icon(Icons.add),
            ),
            _colDivider,
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                // Foreground color
                onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                // Background color
                primary: Theme.of(context).colorScheme.secondaryContainer,
              ).copyWith(elevation: ButtonStyleButton.allOrNull(0)),
              onPressed:
                  handlePressed(context, false, 'FilledTonalButton with Icon'),
              label: const Text('Icon'),
              icon: const Icon(Icons.add),
            ),
            _colDivider,
            OutlinedButton.icon(
              onPressed:
                  handlePressed(context, false, 'OutlinedButton with Icon'),
              icon: const Icon(Icons.add),
              label: const Text('Icon'),
            ),
            _colDivider,
            TextButton.icon(
              onPressed: handlePressed(context, false, 'TextButton with Icon'),
              icon: const Icon(Icons.add),
              label: const Text('Icon'),
            )
          ],
        ),
      );
}

class FloatingActionButtons extends StatelessWidget {
  const FloatingActionButtons({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FloatingActionButton.small(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            _rowDivider,
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            _rowDivider,
            FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create'),
            ),
            _rowDivider,
            FloatingActionButton.large(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
}

class Cards extends StatelessWidget {
  const Cards({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: _cardWidth,
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: const [
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.more_vert),
                      ),
                      SizedBox(height: 35),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Elevated'),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _cardWidth,
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: const [
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.more_vert),
                      ),
                      SizedBox(height: 35),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Filled'),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: _cardWidth,
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: const [
                      Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.more_vert),
                      ),
                      SizedBox(height: 35),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Outlined'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class Dialogs extends StatefulWidget {
  const Dialogs({super.key});

  @override
  State<Dialogs> createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  void openDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Basic Dialog Title'),
        content: const Text(
          'A dialog is a type of modal window that appears in front of app content to provide critical information, or prompt for a decision to be made.',
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Action'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: TextButton(
          child: const Text(
            'Open Dialog',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => openDialog(context),
        ),
      );
}

const List<NavigationDestination> appBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.widgets_outlined),
    label: 'Components',
    selectedIcon: Icon(Icons.widgets),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.format_paint_outlined),
    label: 'Color',
    selectedIcon: Icon(Icons.format_paint),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.text_snippet_outlined),
    label: 'Typography',
    selectedIcon: Icon(Icons.text_snippet),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.invert_colors_on_outlined),
    label: 'Elevation',
    selectedIcon: Icon(Icons.opacity),
  )
];

final List<NavigationRailDestination> navRailDestinations = appBarDestinations
    .map(
      (destination) => NavigationRailDestination(
        icon: Tooltip(
          message: destination.label,
          child: destination.icon,
        ),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      ),
    )
    .toList();

const List<Widget> exampleBarDestinations = [
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.explore_outlined),
    label: 'Explore',
    selectedIcon: Icon(Icons.explore),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.pets_outlined),
    label: 'Pets',
    selectedIcon: Icon(Icons.pets),
  ),
  NavigationDestination(
    tooltip: '',
    icon: Icon(Icons.account_box_outlined),
    label: 'Account',
    selectedIcon: Icon(Icons.account_box),
  )
];

class NavigationBars extends StatefulWidget {
  const NavigationBars({
    super.key,
    this.onSelectItem,
    required this.selectedIndex,
    required this.isExampleBar,
  });
  final void Function(int)? onSelectItem;
  final int selectedIndex;
  final bool isExampleBar;

  @override
  State<NavigationBars> createState() => _NavigationBarsState();
}

class _NavigationBarsState extends State<NavigationBars> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) => NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (!widget.isExampleBar) {
            widget.onSelectItem!(index);
          }
        },
        destinations:
            widget.isExampleBar ? exampleBarDestinations : appBarDestinations,
      );
}

class NavigationRailSection extends StatefulWidget {
  const NavigationRailSection({
    super.key,
    required this.onSelectItem,
    required this.selectedIndex,
  });
  final void Function(int) onSelectItem;
  final int selectedIndex;

  @override
  State<NavigationRailSection> createState() => _NavigationRailSectionState();
}

class _NavigationRailSectionState extends State<NavigationRailSection> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) => NavigationRail(
        minWidth: 50,
        destinations: navRailDestinations,
        selectedIndex: _selectedIndex,
        useIndicator: true,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          widget.onSelectItem(index);
        },
      );
}

const Widget divider = SizedBox(height: 10);

// If screen content width is greater or equal to this value, the light and dark
// color schemes will be displayed in a column. Otherwise, they will
// be displayed in a row.
const double narrowScreenWidthThreshold = 400;

class ColorPalettesScreen extends StatelessWidget {
  const ColorPalettesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData lightTheme = hea_theme.Theme.lightThemeData;
    ThemeData darkTheme = hea_theme.Theme.darkThemeData;

    Widget schemeLabel(String brightness) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            brightness,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );

    Widget schemeView(ThemeData theme) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ColorSchemeView(
            colorScheme: theme.colorScheme,
          ),
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < narrowScreenWidthThreshold) {
          return Column(
            children: [
              divider,
              schemeLabel('Light Theme'),
              schemeView(lightTheme),
              divider,
              divider,
              schemeLabel('Dark Theme'),
              schemeView(darkTheme)
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      schemeLabel('Light Theme'),
                      schemeView(lightTheme)
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      schemeLabel('Dark Theme'),
                      schemeView(darkTheme)
                    ],
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

class ColorSchemeView extends StatelessWidget {
  const ColorSchemeView({super.key, required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ColorGroup(
            children: [
              ColorChip(
                label: 'primary',
                color: colorScheme.primary,
                onColor: colorScheme.onPrimary,
              ),
              ColorChip(
                label: 'onPrimary',
                color: colorScheme.onPrimary,
                onColor: colorScheme.primary,
              ),
              ColorChip(
                label: 'primaryContainer',
                color: colorScheme.primaryContainer,
                onColor: colorScheme.onPrimaryContainer,
              ),
              ColorChip(
                label: 'onPrimaryContainer',
                color: colorScheme.onPrimaryContainer,
                onColor: colorScheme.primaryContainer,
              )
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(
                label: 'secondary',
                color: colorScheme.secondary,
                onColor: colorScheme.onSecondary,
              ),
              ColorChip(
                label: 'onSecondary',
                color: colorScheme.onSecondary,
                onColor: colorScheme.secondary,
              ),
              ColorChip(
                label: 'secondaryContainer',
                color: colorScheme.secondaryContainer,
                onColor: colorScheme.onSecondaryContainer,
              ),
              ColorChip(
                label: 'onSecondaryContainer',
                color: colorScheme.onSecondaryContainer,
                onColor: colorScheme.secondaryContainer,
              )
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(
                label: 'tertiary',
                color: colorScheme.tertiary,
                onColor: colorScheme.onTertiary,
              ),
              ColorChip(
                label: 'onTertiary',
                color: colorScheme.onTertiary,
                onColor: colorScheme.tertiary,
              ),
              ColorChip(
                label: 'tertiaryContainer',
                color: colorScheme.tertiaryContainer,
                onColor: colorScheme.onTertiaryContainer,
              ),
              ColorChip(
                label: 'onTertiaryContainer',
                color: colorScheme.onTertiaryContainer,
                onColor: colorScheme.tertiaryContainer,
              ),
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(
                label: 'error',
                color: colorScheme.error,
                onColor: colorScheme.onError,
              ),
              ColorChip(
                label: 'onError',
                color: colorScheme.onError,
                onColor: colorScheme.error,
              ),
              ColorChip(
                label: 'errorContainer',
                color: colorScheme.errorContainer,
                onColor: colorScheme.onErrorContainer,
              ),
              ColorChip(
                label: 'onErrorContainer',
                color: colorScheme.onErrorContainer,
                onColor: colorScheme.errorContainer,
              ),
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(
                label: 'background',
                color: colorScheme.background,
                onColor: colorScheme.onBackground,
              ),
              ColorChip(
                label: 'onBackground',
                color: colorScheme.onBackground,
                onColor: colorScheme.background,
              ),
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(
                label: 'surface',
                color: colorScheme.surface,
                onColor: colorScheme.onSurface,
              ),
              ColorChip(
                label: 'onSurface',
                color: colorScheme.onSurface,
                onColor: colorScheme.surface,
              ),
              ColorChip(
                label: 'surfaceVariant',
                color: colorScheme.surfaceVariant,
                onColor: colorScheme.onSurfaceVariant,
              ),
              ColorChip(
                label: 'onSurfaceVariant',
                color: colorScheme.onSurfaceVariant,
                onColor: colorScheme.surfaceVariant,
              ),
            ],
          ),
          divider,
          ColorGroup(
            children: [
              ColorChip(label: 'outline', color: colorScheme.outline),
              ColorChip(label: 'shadow', color: colorScheme.shadow),
              ColorChip(
                label: 'inverseSurface',
                color: colorScheme.inverseSurface,
                onColor: colorScheme.onInverseSurface,
              ),
              ColorChip(
                label: 'onInverseSurface',
                color: colorScheme.onInverseSurface,
                onColor: colorScheme.inverseSurface,
              ),
              ColorChip(
                label: 'inversePrimary',
                color: colorScheme.inversePrimary,
                onColor: colorScheme.primary,
              ),
            ],
          ),
        ],
      );
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: children,
        ),
      );
}

class ColorChip extends StatelessWidget {
  const ColorChip({
    super.key,
    required this.color,
    required this.label,
    this.onColor,
  });

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    switch (brightness) {
      case Brightness.dark:
        return Colors.white;
      case Brightness.light:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color labelColor = onColor ?? contrastColor(color);

    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}
