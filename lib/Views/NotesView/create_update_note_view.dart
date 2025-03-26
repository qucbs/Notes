import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/Services/crud/note_services.dart';
import 'package:notes/Utilities/Generics/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? note;
  late final NoteServices noteService;
  late final TextEditingController _textController;

  @override
  void initState() {
    noteService = NoteServices();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    deleteNoteIfTextIsEmpty();
    saveNoteIfTextIsNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  Future<DatabaseNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<DatabaseNote>();

    if (widgetNote != null) {
      note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await noteService.getUser(email: email);
    final newNote = await noteService.createNote(owner: owner);
    note = newNote;
    return newNote;
  }

  void textControllerListener() async {
    final note = this.note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await noteService.updateNote(note: note, text: text);
  }

  void setupTextControllerListener() {
    _textController.removeListener(textControllerListener);
    _textController.addListener(textControllerListener);
  }

  void deleteNoteIfTextIsEmpty() {
    final _note = note;
    if (_textController.text.isEmpty && _note != null) {
      noteService.deleteNote(id: _note.id);
    }
  }

  void saveNoteIfTextIsNotEmpty() async {
    final note = this.note;
    if (_textController.text.isNotEmpty && note != null) {
      await noteService.updateNote(note: note, text: _textController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromRGBO(29, 29, 29, 1),
        title: const Text('New Notes', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              setupTextControllerListener();
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: 'Start typing your note here...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'Failed to create note. Please try again.',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
