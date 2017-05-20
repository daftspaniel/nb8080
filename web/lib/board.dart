import 'dart:convert';
import 'dart:html';

import 'localstorageutil.dart';
import 'note.dart';

class Board {
  int newId = -1;
  DivElement board = querySelector('#board');
  Note activeNote;
  List<int> Ids = new List<int>();
  List<Note> notes = new List<Note>();

  Board() {
    setupEventHandlers();
    newId = int.parse(getStoredValue("newId", "1"));
  }

  void loadNotes() {
    String idJSON = getStoredValue('AllNoteIds', '');
    if (idJSON.length > 0) {
      Ids = JSON.decode(idJSON);
    }
    Ids.forEach((int id) {
      addNote(id);
    });
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
    Ids.add(claimedId);
    storeValue('AllNoteIds', JSON.encode(Ids));
    return claimedId.toString();
  }

  void addNote(int i) {
    print('add note $i');
    DivElement newNoteDiv = new DivElement();
    newNoteDiv
      ..classes.add('note')
      ..draggable = true
      ..contentEditable = 'true';
    board.append(newNoteDiv);

    String id;
    Note newNote;
    if (i < 0) {
      id = getNewNoteID();
      newNote = new Note(newNoteDiv, id);
      newNote.saveNote();
    }
    else {
      id = i.toString();
      newNote = new Note(newNoteDiv, id);
      newNote.loadNote();
    }

    newNote.board = this;
    notes.add(newNote);
    activeNote = newNote;
  }
}

