import 'dart:html';

import 'localstorageutil.dart';
import 'note.dart';

class Board {
  int newId = -1;
  DivElement board = querySelector('#board');
  Note activeNote;

  Board() {
    setupEventHandlers();
    newId = int.parse(getStoredValue("newId", "1"));
  }

  void setupEventHandlers() {
    board.onDragOver.listen((MouseEvent e) {
      e.preventDefault();
    });

    board.onDrop.listen((MouseEvent e) {
      activeNote.savePosition(e.page.x, e.page.y);
//      activeNote.note.style.top = "${e.page.y + activeNote.x}px";
//      activeNote.note.style.left = "${e.page.x + activeNote.y}px";
//
//      storeValue('y-${activeNote.id}', activeNote.note.style.top);
//      storeValue('x-${activeNote.id}', activeNote.note.style.left);
    });
  }

  String getNewNoteID() {
    int claimedId = newId;
    newId ++;
    storeValue('newId', newId.toString());
    return claimedId.toString();
  }
}

