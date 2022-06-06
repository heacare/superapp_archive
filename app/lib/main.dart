import 'old/old.dart';

const devel = String.fromEnvironment("DEVEL", defaultValue: "");

void main() async {
  if (devel != "playground") {
    await oldMain();
    return;
  }
}
