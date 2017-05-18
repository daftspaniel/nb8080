// Copyright (c) 2017, daftspaniel. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'lib/board.dart';
import 'lib/note.dart';

Note note1 = new Note();
Board mainBoard = new Board();

void main() {
  note1.loadNote(note1.id);
  mainBoard.note1 = note1;
}
