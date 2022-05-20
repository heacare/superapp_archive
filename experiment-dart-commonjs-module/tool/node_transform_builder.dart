import 'dart:async';
import 'package:build/build.dart';
import 'package:node_preamble/preamble.dart';

class _NodeTransformBuilder extends Builder {
  @override
  final Map<String, List<String>> buildExtensions = {
    '.dart.js': ['.dart.node.js'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    var outputId = buildStep.inputId.changeExtension(".node.js");
    var preamble = getPreamble(minified: false);
    var contents = buildStep.readAsString(buildStep.inputId);
    buildStep.writeAsString(outputId, _addPreamble(preamble, contents));
  }

  Future<String> _addPreamble(String preamble, Future<String> contents) async {
    return preamble + await contents;
  }
}

Builder nodeTransformBuilder(BuilderOptions options) => _NodeTransformBuilder();
