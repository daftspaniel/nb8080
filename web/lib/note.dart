import 'dart:html';

import 'localstorageutil.dart';

class Note {
  String id = "1";
  int x = 0;
  int y = 0;
  DivElement note;

  void loadNote(String id) {
    note.innerHtml = getStoredValue(id, "Welcome to Notes board 8080");
    note
      ..style.top = getStoredValue('y-$id', "100px")
      ..style.left = getStoredValue('x-$id', "100px");
  }

  Note() {
    note = querySelector('#output' + id);
    note.onKeyDown.listen((KeyboardEvent k) {
      storeValue(id, note.innerHtml);
    });

    note.onMouseDown.listen((MouseEvent e) {
      x = e.client.x - (note.offsetLeft + 200);
      y = e.client.y - (note.offsetTop + 200);
    });
  }
}