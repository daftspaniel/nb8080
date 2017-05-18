import 'dart:html';

import 'localstorageutil.dart';
import 'note.dart';

class Board {
  DivElement board = querySelector('#board');

  Note note1;

  Board() {
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
}

