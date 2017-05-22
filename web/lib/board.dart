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
      if (id > 0) addNote(id);
    });
  }

  void setupEventHandlers() {
    board.onDragOver.listen((MouseEvent e) {
      e.preventDefault();
    });

    board.onDrop.listen((MouseEvent e) {
      activeNote.saveWithPosition(e.page.x, e.page.y);
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
  }

  void setActiveNote(Note note) {
    activeNote = note;
    notes.forEach((Note note) => note.note.style.zIndex = '10');
    activeNote.note.style.zIndex = '100';
  }
}

