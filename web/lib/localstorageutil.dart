import 'dart:html';

String getStoredValue(String key, String defaultValue) {
  String value = window.localStorage[key];
  if (value == null) {
    value = defaultValue;
  }
  return value;
}

void storeValue(String key, String value){
  window.localStorage[key] = value;
}