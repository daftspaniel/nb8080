import 'dart:convert';
import 'dart:html';

import 'board.dart';
import 'localstorageutil.dart';

class Note {
  String id = "1";
  int x = 0;
  int y = 0;
  DivElement note;
  Board board;
  Map plainNote = new Map();

  Note(DivElement newNote, String newId) {
    id = newId;
    note = newNote;

    note.onKeyUp.listen((KeyboardEvent k) {
      save();
    });

    note.onMouseDown.listen((MouseEvent e) {
      x = e.client.x - (note.offsetLeft);
      y = e.client.y - (note.offsetTop);
      board.setActiveNote(this);
    });

    note.onDragStart.listen((e) {
      note.style.opacity = "0.2";
    });
    note.onDragEnd.listen((e) {
      note.style.opacity = "1";
    });
  }

  void saveNote() {
    saveWithPosition(75, 75);
  }

  void loadNote() {
    String stored = getStoredValue(id, null);

    if (stored == null) {
      createAndSaveDefaultNote();
    } else {
      plainNote = JSON.decode(stored);
      note.innerHtml = plainNote['text'];
      note.style.top = plainNote['top'];
      note.style.left = plainNote['left'];
    }
  }

  void deleteNote() {
    deleteStoredValue(id);
  }

  void createAndSaveDefaultNote() {
    plainNote['text'] = "Welcome to Notes Board 8080";
    plainNote['top'] = "100px";
    plainNote['left'] = "100px";
    note.innerHtml = plainNote['text'];

    saveWithPosition(75, 75);
  }

  void save() {
    plainNote['text'] = note.innerHtml;
    plainNote['left'] = note.style.left;
    plainNote['top'] = note.style.top;
    storeValue(id, JSON.encode(plainNote));
  }

  void saveWithPosition(int pageX, int pageY) {
    note.style.top = "${pageY - y}px";
    note.style.left = "${pageX - x}px";
    save();
  }
}