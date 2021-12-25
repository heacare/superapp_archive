import 'dart:convert';
import 'package:hea/models/content/lesson.dart';
import 'package:hea/models/content/module.dart';
import 'package:hea/models/content/page.dart';
import 'package:hea/services/api_manager.dart';
import 'package:hea/services/service_locator.dart';
import 'api_endpoint.dart';

abstract class ContentService {
  Future<List<Module>> getModules();
  Future<List<Lesson>> getLessons(int moduleId);
  Future<List<Page>> getPages(int lessonId);
}

class ContentServiceImpl implements ContentService {
  ApiManager api = serviceLocator<ApiManager>();

  @override
  Future<List<Module>> getModules() async {
    final resp = await api.get(ApiEndpoint.contentModule);
    if (resp.statusCode == 200) {
      final moduleList = jsonDecode(resp.body) as List<Map<String, dynamic>>;
      return moduleList.map((e) => Module.fromJson(e)).toList();
    } else {
      throw ApiManagerException(
          message: "Failure in getModules: ${resp.statusCode}");
    }
  }

  @override
  Future<List<Lesson>> getLessons(int moduleId) {
    // TODO: implement getLessons
    throw UnimplementedError();
  }

  @override
  Future<List<Page>> getPages(int lessonId) {
    // TODO: implement getPages
    throw UnimplementedError();
  }
}
