import 'package:flutter/material.dart';
import 'package:notes/Services/Auth/auth_service.dart';
import 'package:notes/Services/crud/note_services.dart';
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
  late final NoteServices noteServices;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    noteServices = NoteServices();
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
                    await AuthService.firebase().logOut();
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil(loginRoute, (context) => false);
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
      body: FutureBuilder(
        future: noteServices.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: noteServices.allNotes,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return NotelistView(
                          notes: allNotes,
                          onDeleteNote: (note) async {
                            await noteServices.deleteNote(id: note.id);
                          },
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                              createorupdatenoteroute,
                              arguments: note,
                            );
                          },
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
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
