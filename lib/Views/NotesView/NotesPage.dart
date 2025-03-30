import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/Services/Auth/bloc/auth_bloc.dart';
import 'package:notes/Services/Auth/bloc/auth_events.dart';
import 'package:notes/Services/cloud/firebase_cloud_storage.dart';
import 'package:notes/Utilities/Dialogs/logout_dialog.dart';
import 'package:notes/Views/NotesView/notes_list_view.dart';
import 'package:notes/routes.dart';

// Definning the menu action
enum MenuAction { logout }

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late final FirebaseCloudStorage noteServices;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    noteServices = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(29, 29, 29, 1),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createorupdatenoteroute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogoutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
        title: Text('Notes', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(29, 29, 29, 1),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: noteServices.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              final allNotes = snapshot.data ?? [];

              if (allNotes.isEmpty) {
                return const Center(
                  child: Text(
                    'No notes yet. Click + to add one.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                );
              }

              return NotelistView(
                notes: allNotes,
                onDeleteNote: (note) async {
                  await noteServices.deleteNote(documentId: note.documentId);
                },
                onTap: (note) {
                  Navigator.of(
                    context,
                  ).pushNamed(createorupdatenoteroute, arguments: note);
                },
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
