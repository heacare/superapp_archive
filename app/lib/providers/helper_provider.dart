
import 'dart:math';

import 'package:hea/models/helper.dart';

class HelperProvider {
  // TODO make this rely on server
  Future<List<Helper>> getProviders(HelpType type) async {
    final centerLat = 1.308458419820971;
    final centerLng = 103.77342885504416;
    final rng = Random.secure();
    final diffLat = () => centerLat + (rng.nextDouble()-0.5) * 0.005;
    final diffLng = () => centerLng + (rng.nextDouble()-0.5) * 0.005;

    return [
      Helper(name: "Wei Lim", icon: "", description: "Top-in-class neurosurgeon", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
      Helper(name: "Shin Mei", icon: "", description: "Best services", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
      Helper(name: "Ong Whee Teck", icon: "", description: "Top massager", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
      Helper(name: "Grandma Lim", icon: "", description: "Grandma vibes to cure loneliness", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
      Helper(name: "Lee Wei", icon: "", description: "Organizer of ideas", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
      Helper(name: "Encik Fadly", icon: "", description: "Encik vibes to wake your idea up", lat: diffLat(), lng: diffLng(), type: HelpType.PHYSICAL),
    ];
  }
}