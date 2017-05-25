// Copyright (c) 2017, daftspaniel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';

import 'lib/board.dart';

DivElement add = querySelector('#addButton');
DivElement minus = querySelector('#minusButton');
DivElement arrange = querySelector('#arrangeButton');
Board mainBoard = new Board();

void main() {
  mainBoard.loadNotes();

  add.onClick.listen((MouseEvent me) {
    mainBoard.addNote(-1);
  });
  minus.onClick.listen((MouseEvent me) {
    mainBoard.removeActiveNote();
  });
  arrange.onClick.listen((MouseEvent me) {
    mainBoard.arrange();
  });
}
