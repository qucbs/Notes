import 'package:flutter/material.dart';
import 'package:notes/Utilities/Dialogs/delete_dialog.dart';
import 'package:notes/Services/cloud/cloud_note.dart';


typedef NoteCallBack = void Function(CloudNote note);

class NotelistView extends StatefulWidget {
  final NoteCallBack onDeleteNote;
  final Iterable<CloudNote> notes;
  final NoteCallBack onTap;

  const NotelistView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  State<NotelistView> createState() => _NotelistViewState();
}

class _NotelistViewState extends State<NotelistView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.notes.length,
      itemBuilder: (context, index) {
        final note = widget.notes.elementAt(index);
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
                    widget.onDeleteNote(note);
                  }
                },
              ),
              onTap: () {
                widget.onTap(note);
              },
            ),
          ),
        );
      },
    );
  }
}
