import 'dart:convert';
import 'dart:html';

import 'htmlutil.dart';
import 'localstorageutil.dart';
import 'note.dart';

class Board {

  final DivElement board = querySelector('#board');
  final InputElement backColor = querySelector('#backColorPick');
  final InputElement foreColor = querySelector('#foreColorPick');
  final List<Note> notes = new List<Note>();

  final int noteWidth = 200;
  int newId = -1;
  Note activeNote;
  List<int> Ids = new List<int>();

  Board() {
    setupEventHandlers();
    initState();
  }

  void initState() {
    newId = int.parse(getStoredValue("newId", "1"));
    backColor.value = getStoredValue('noteBackColor', '#f1f555');
    foreColor.value = getStoredValue('foreBackColor', '#000000');
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

    backColor.onChange.listen((Event e) {
      storeValue('noteBackColor', backColor.value);
      activeNote.backColor = backColor.value;
      activeNote.save();
    });

    foreColor.onChange.listen((Event e) {
      storeValue('foreBackColor', foreColor.value);
      activeNote.foreColor = foreColor.value;
      activeNote.save();
    });
  }

  void putNoteColorsInPicker() {
    backColor.value = getHexColor(activeNote.note.style.backgroundColor);
    foreColor.value = getHexColor(activeNote.note.style.color);
  }

  String get selectedBackColor {
    return backColor.value;
  }

  String get selectedForeColor {
    return foreColor.value;
  }

  String getNewNoteID() {
    int claimedId = newId;
    newId ++;
    storeValue('newId', newId.toString());
    Ids.add(claimedId);
    storeValue('AllNoteIds', JSON.encode(Ids));
    return claimedId.toString();
  }

  void addNote([int i = -1]) {
    DivElement newNoteDiv = new DivElement();
    newNoteDiv
      ..classes.add('note')
      ..draggable = true
      ..contentEditable = 'true'
      ..style.backgroundColor = backColor.value
      ..style.color = foreColor.value;
    board.append(newNoteDiv);
    newNoteDiv.focus();

    String id;
    Note newNote;
    if (i < 0) {
      id = getNewNoteID();
      newNote = new Note(newNoteDiv, id, this);
      newNote
        ..move(75, 75)
        ..save();
    }
    else {
      id = i.toString();
      newNote = new Note(newNoteDiv, id, this);
      newNote.load();
    }

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
    if (window.confirm(
        "Are you sure you want to delete this note?")) {
      if (activeNote != null) {
        Ids.remove(int.parse(activeNote.id));
        storeValue('AllNoteIds', JSON.encode(Ids));
        activeNote.delete();
        activeNote.note.remove();
        notes.remove(activeNote);
      }

      if (notes.length > 0) {
        activeNote = notes[0];
      }
    }
  }

  void arrangeNotes() {
    int x = 60;
    int y = 30;
    int sx = 60;
    int z = 0;
    notes.forEach((Note note) {
      note.move(x, y);
      x = x + noteWidth + 30;
      if (x + noteWidth > board.clientWidth) {
        y += 100 + 30;
        sx += 10;
        x = sx;
      }
      note.note.focus();
      note.note.style.zIndex = z.toString();
      z++;
    });
  }
}

