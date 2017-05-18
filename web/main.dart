// Copyright (c) 2017, daftspaniel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'lib/localstorageutil.dart';

DivElement board = querySelector('#board');

class Note {
  String id = "1";
  int x = 0;
  int y = 0;
  DivElement note;

  void loadNote(String id) {
    note.text = getStoredValue(id, "Welcome to Notes board 8080");
    note
      ..style.top = getStoredValue('y-$id', "100px")
      ..style.left = getStoredValue('x-$id', "100px");
  }

  Note() {
    note = querySelector('#output' + id);
    note.onKeyDown.listen((KeyboardEvent k) {
      storeValue(id, note.text);
    });

    note.onMouseDown.listen((MouseEvent e) {
      x = e.client.x - (note.offsetLeft + 200);
      y = e.client.y - (note.offsetTop + 200);
    });
  }
}

Note note1 = new Note();

void main() {
  note1.loadNote(note1.id);

  board.onDragOver.listen((MouseEvent e) {
    e.preventDefault();
  });

  board.onDrop.listen((MouseEvent e) {
    note1.note.style.top = "${e.page.y + note1.x}px";
    note1.note.style.left = "${e.page.x + note1.y}px";

    storeValue('y-${note1.id}', note1.note.style.top);
    storeValue('x-${note1.id}', note1.note.style.left);
  });
}
