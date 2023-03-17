// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "app_name": "Notes App",
  "title_text": "Title",
  "description_text": "Description",
  "create_text": "Create note",
  "update_text": "Update note",
  "delete_text": "Note deleted"
};
static const Map<String,dynamic> ar = {
  "app_name": "تطبيق الملاحظات",
  "title_text": "العنوان",
  "description_text": "التفاصيل",
  "create_text": "انشاء الملاحظة",
  "update_text": "تحديث الملاحظة",
  "delete_text": "تم حذف الملاحطة"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "ar": ar};
}
