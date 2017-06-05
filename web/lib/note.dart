import 'dart:convert';
import 'dart:html';

import 'board.dart';
import 'localstorageutil.dart';

class Note {
  Map plainNote = new Map();

  String id = "1";
  int x = 0;
  int y = 0;

  TextAreaElement textArea;
  Board board;

  void set backColor(String value) {
    textArea.style.backgroundColor = value;
  }

  void set foreColor(String value) {
    textArea.style.color = value;
  }

  Note(this.textArea, this.id, this.board) {
    textArea.onKeyUp.listen((KeyboardEvent k) {
      print('keyup');
      save();
    });

    textArea.onMouseDown.listen((MouseEvent e) {
      notePickup(e.client.x, e.client.y);
    });

    textArea.onTouchStart.listen((TouchEvent e) {
      notePickup(e.touches.first.client.x, e.touches.first.client.y);
    });

    textArea.onTouchEnd.listen((TouchEvent e) {
      print("end");
    });

    textArea.onTouchMove.listen((TouchEvent e) {
      print("move");
      move(e.touches.first.client.x, e.touches.first.client.y);
    });

    textArea.onDragStart.listen((e) {
      textArea.style.opacity = "0.2";
    });

    textArea.onDragEnd.listen((e) {
      textArea.style.opacity = "1";
      textArea.style.transition = 'top 0.5s, left 0.5s';
    });
  }

  void notePickup(int px, int py) {
    x = px - (textArea.offsetLeft);
    y = py - (textArea.offsetTop);
    textArea.style.transition = 'none';
    board.setActiveNote(this);
    board.putNoteColorsInPicker();
  }

  void load() {
    String stored = getStoredValue(id, null);

    if (stored == null) {
      create();
    } else {
      plainNote = JSON.decode(stored);
      textArea.style.top = plainNote['top'];
      textArea.style.left = plainNote['left'];
      textArea.value = plainNote['text'];

      if (plainNote['color'] == null)
        plainNote['color'] = '#000000';
      if (plainNote['background-color'] == null)
        plainNote['background-color'] = '#ffffff';

      textArea.style.color = plainNote['color'];
      textArea.style.backgroundColor = plainNote['background-color'];
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

    textArea.value = plainNote['text'];
    move(75, 75);
  }

  void save() {
    plainNote['text'] = textArea.value;
    plainNote['left'] = textArea.style.left;
    plainNote['top'] = textArea.style.top;
    plainNote['color'] = textArea.style.color;
    plainNote['background-color'] = textArea.style.backgroundColor;

    storeValue(id, JSON.encode(plainNote));
  }

  void move(int mx, int my) {
    textArea.style.top = "${my}px";
    textArea.style.left = "${mx}px";
    save();
  }

}