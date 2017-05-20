import 'dart:html';

import 'board.dart';
import 'localstorageutil.dart';

class Note {
  String id = "1";
  int x = 0;
  int y = 0;
  DivElement note;
  Board board;

  void loadNote() {

    note.innerHtml = getStoredValue(id, "Welcome to Notes Board 8080");
    note
      ..style.top = getStoredValue('y-$id', "100px")
      ..style.left = getStoredValue('x-$id', "100px");
  }

  Note(DivElement newNote, String newId) {
    id = newId;
    note = newNote;

    note.onKeyUp.listen((KeyboardEvent k) {
      storeValue(id, note.innerHtml);
    });

    note.onMouseDown.listen((MouseEvent e) {
      x = e.client.x - (note.offsetLeft + 200);
      y = e.client.y - (note.offsetTop + 200);
      board.activeNote = this;
    });
  }

  void saveNote(){
    storeValue(id, note.innerHtml);
    savePosition(75, 75);
  }

  void savePosition(int pageX, int pageY) {
    note.style.top = "${pageY + x}px";
    note.style.left = "${pageX + y}px";

    storeValue('y-${id}', note.style.top);
    storeValue('x-${id}', note.style.left);
  }
}