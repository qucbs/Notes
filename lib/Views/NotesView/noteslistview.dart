import 'package:flutter/material.dart';
import 'package:notes/Dialogs/delete_dialog.dart';
import 'package:notes/Services/crud/note_services.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final DeleteNoteCallback onDeleteNote;
  final List<DatabaseNote> notes;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return Container(
          alignment: Alignment.centerLeft,
          height: 80.0, // Adjust the height as needed
          width: double.infinity,
          child: Card(
            color: Color.fromRGBO(39, 39, 39, 1),
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: ListTile(
              title: Text(
                note.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
              ),
              onTap: () {
                // Navigate to edit note screen or perform an action
                print('Note tapped');
              },
            ),
          ),
        );
      },
    );
  }
}
