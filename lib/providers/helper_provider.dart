
import 'package:hea/models/helper.dart';

class HelperProvider {
  // TODO make this rely on server
  Future<List<Helper>> getProviders(HelpType type) async {
    return [
      Helper(name: "Wei Lim", icon: "", description: "Top-in-class neurosurgeon", lat: 1.290270, lng: 103.851959, type: HelpType.PHYSICAL),
      Helper(name: "Shin Mei", icon: "", description: "Best services", lat: 1.379198, lng: 103.804417, type: HelpType.PHYSICAL),
      Helper(name: "Ong Whee Teck", icon: "", description: "Top massager", lat: 1.397198, lng: 103.710027, type: HelpType.PHYSICAL),
      Helper(name: "Grandma Lim", icon: "", description: "Grandma vibes to cure loneliness", lat: 1.340653, lng: 103.699660, type: HelpType.PHYSICAL),
      Helper(name: "Lee Wei", icon: "", description: "Organizer of ideas", lat: 1.315743, lng: 103.796051, type: HelpType.PHYSICAL),
      Helper(name: "Encik Fadly", icon: "", description: "Encik vibes to wake your idea up", lat: 1.382107, lng: 103.876255, type: HelpType.PHYSICAL),
    ];
  }
}