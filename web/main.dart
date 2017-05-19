// Copyright (c) 2017, daftspaniel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'lib/board.dart';
import 'lib/note.dart';

DivElement add = querySelector('#addButton');
Board mainBoard = new Board();
List<Note> notes = new List<Note>();

void main() {
//  note1.loadNote(note1.id);
//  note1.board = mainBoard;
//  mainBoard.activeNote = note1;

  add.onClick.listen((MouseEvent me) {
    print("CLICK");

    DivElement newNoteDiv = new DivElement();
    newNoteDiv
      ..text = "ASDF"
      ..classes.add('note')
      ..draggable = true
      ..contentEditable = 'true';

    mainBoard.board.append(newNoteDiv);

    Note newNote = new Note(newNoteDiv, mainBoard.getNewNoteID());
    newNote.board = mainBoard;
    notes.add(newNote);
    //note1.loadNote(note1.id);

    mainBoard.activeNote = newNote;
  });
}
