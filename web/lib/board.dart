import 'dart:convert';
import 'dart:html';

import 'localstorageutil.dart';
import 'note.dart';

class Board {

  final int noteWidth = 200;

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
      if (id > 0) addNote(id);
    });
  }

  void setupEventHandlers() {
    board.onDragOver.listen((MouseEvent e) {
      e.preventDefault();
    });

    board.onDrop.listen((MouseEvent e) {
      activeNote.move(e.page.x - activeNote.x, e.page.y - activeNote.y);
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
    DivElement newNoteDiv = new DivElement();
    newNoteDiv
      ..classes.add('note')
      ..draggable = true
      ..contentEditable = 'true';
    board.append(newNoteDiv);
    newNoteDiv.focus();

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
    setActiveNote(newNote);
    newNote.note.focus();
  }

  void setActiveNote(Note note) {
    activeNote = note;
    notes.forEach((Note note) => note.note.style.zIndex = '10');
    activeNote.note.style.zIndex = '100';
  }

  void removeActiveNote() {
    if (activeNote != null) {
      Ids.remove(int.parse(activeNote.id));
      storeValue('AllNoteIds', JSON.encode(Ids));
      activeNote.deleteNote();
      activeNote.note.remove();
      notes.remove(activeNote);
    }

    if (notes.length > 0) {
      activeNote = notes[0];
    }
  }

  void arrange() {
    int x = 60;
    int y = 30;
    int sx = 60;
    notes.forEach((Note note) {
      note.move(x, y);
      x = x + noteWidth + 30;
      if (x + noteWidth > board.clientWidth) {
        y += 100 + 30;
        sx += 10;
        x = sx;
      }
    });
  }
}

