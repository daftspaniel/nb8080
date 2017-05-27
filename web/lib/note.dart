import 'dart:convert';
import 'dart:html';

import 'board.dart';
import 'localstorageutil.dart';

class Note {
  Map plainNote = new Map();

  String id = "1";
  int x = 0;
  int y = 0;

  DivElement note;
  Board board;

  void set backColor(String value) {
    note.style.backgroundColor = value;
  }

  void set foreColor(String value) {
    note.style.color = value;
  }

  Note(DivElement newNote, String newId, Board newBoard) {
    id = newId;
    note = newNote;
    board = newBoard;

    note.onKeyUp.listen((KeyboardEvent k) {
      save();
    });

    note.onMouseDown.listen((MouseEvent e) {
      x = e.client.x - (note.offsetLeft);
      y = e.client.y - (note.offsetTop);
      note.style.transition = 'none';
      board.setActiveNote(this);
      board.putNoteColorsInPicker();
    });

    note.onDragStart.listen((e) {
      note.style.opacity = "0.2";
    });

    note.onDragEnd.listen((e) {
      note.style.opacity = "1";
      note.style.transition = 'top 0.5s, left 0.5s';
    });
  }

  void load() {
    String stored = getStoredValue(id, null);

    if (stored == null) {
      create();
    } else {
      plainNote = JSON.decode(stored);
      note.innerHtml = plainNote['text'];
      note.style.top = plainNote['top'];
      note.style.left = plainNote['left'];

      if (plainNote['color'] == null)
        plainNote['color'] = '#000000';
      if (plainNote['background-color'] == null)
        plainNote['background-color'] = '#ffffff';

      note.style.color = plainNote['color'];
      note.style.backgroundColor = plainNote['background-color'];
    }
  }

  void delete() {
    deleteStoredValue(id);
  }

  void create() {
    plainNote['text'] = "Welcome to Notes Board 8080";
    plainNote['top'] = "100px";
    plainNote['left'] = "100px";
    plainNote['color'] = board.selectedForeColor;
    plainNote['background-color'] = board.selectedBackColor;
    note.innerHtml = plainNote['text'];

    move(75, 75);
  }

  void save() {
    plainNote['text'] = note.innerHtml;
    plainNote['left'] = note.style.left;
    plainNote['top'] = note.style.top;
    plainNote['color'] = note.style.color;
    plainNote['background-color'] = note.style.backgroundColor;
    storeValue(id, JSON.encode(plainNote));
  }

  void move(int mx, int my) {
    note.style.top = "${my}px";
    note.style.left = "${mx}px";
    save();
  }

}