import 'dart:convert';
import 'dart:html';

const String nb8080 = 'nb8080';

String get getNb8080Store {
  String result = window.localStorage[nb8080];
  return result == null ? "{}" : result;
}

void saveStore(Map store) {
  window.localStorage[nb8080] = JSON.encode(store);
}

String getStoredValue(String key, String defaultValue) {
  Map store = JSON.decode(getNb8080Store);
  String value = store[key];
  if (value == null) {
    value = defaultValue;
  }
  return value;
}

void deleteStoredValue(String key) {
  Map store = JSON.decode(getNb8080Store);
  store.remove(key);
  saveStore(store);
}

void storeValue(String key, String value) {
  Map store = JSON.decode(getNb8080Store);
  store[key] = value;
  saveStore(store);
}