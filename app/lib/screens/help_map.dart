import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hea/models/helper.dart';
import 'package:hea/widgets/avatar_icon.dart';
import 'package:hea/providers/helper_provider.dart';
import 'package:latlong2/latlong.dart';

final provider = HelperProvider();

class HelpMapScreen extends StatefulWidget {
  @override
  State<HelpMapScreen> createState() => _HelpMapScreenState();
}

class _HelpMapScreenState extends State<HelpMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      createMap(context),
      if (selectedHelper == null) ...[optionsSetter(context)] else ...[displayHelper(context)]]);
  }

  HelpType? optionsValue = null;
  List<Marker> markers = [];
  Helper? selectedHelper = null;

  Widget optionsSetter(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.bottomCenter,
        child: Card(
          child: DropdownButtonFormField<HelpType>(
            value: optionsValue,
            items: const [
              DropdownMenuItem(
                  child: Text("Mental Help"), value: HelpType.MENTAL),
              DropdownMenuItem(
                  child: Text("Physical Help"), value: HelpType.PHYSICAL),
            ],
            hint: const Text("What help do you require?"),
            onChanged: (newValue) {
              setState(() {
                optionsValue = newValue!;
              });
              provider.getProviders(optionsValue!).then((helpers) {
                setState(() {
                  markers = helpers
                      .map((h) => createMarker(h, optionsValue!))
                      .toList();
                });
              });
            },
          ),
        ));
  }

  Widget displayHelper(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.bottomCenter,
        // TODO can refactor into it's own widget
        child: Card(
            child: SizedBox(
              height: 150,
              child: Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity.comfortable,
                    leading: AvatarIcon(icon: selectedHelper!.icon, radius: 20.0),
                    title: Text(selectedHelper!.name),
                    subtitle: Text(selectedHelper!.description),
                    trailing: TextButton(child: const Icon(Icons.close), onPressed: () {
                      setState(() { selectedHelper = null; });
                    }),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text("Book a Session")),
                      TextButton.icon(onPressed: () {}, icon: const Icon(Icons.warning), label: const Text("Report")),
                    ],
                  )
                ],
              )
            )
          ),
        );
  }

  Marker createMarker(Helper helper, HelpType type) {
    return Marker(
        point: LatLng(helper.lat, helper.lng),
        builder: (ctx) {
          return TextButton(onPressed: onPressed(helper), child: const Icon(Icons.health_and_safety));
        });
  }

  VoidCallback onPressed(Helper helper) {
    return () {
      setState(() {
        selectedHelper = helper;
      });
    };
  }

  Widget createMap(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(1.308458419820971, 103.77342885504416),
        zoom: 16.0
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
          attributionBuilder: (_) {
            return const Text("© OpenStreetMap contributors");
          },
        ),
        MarkerLayerOptions(markers: markers),
      ],
    );
  }
}
