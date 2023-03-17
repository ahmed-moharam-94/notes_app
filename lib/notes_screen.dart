import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sql/db_helper.dart';
import 'package:flutter_sql/translations/locale_keys.g.dart';

enum Languages { ar, en }

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Map<String, dynamic>> _notes = [];
  bool _isLoading = true;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Languages? _selectedLanguage;
  Future<void> _refreshNotes() async {
    // get notes
    final data = await DBHelper.getItems();
    setState(() {
      _notes = data;
      _isLoading = false;
    });
  }

  Future<void> _addItem() async {
    await DBHelper.createItem(
        _titleController.text, _descriptionController.text);
    _refreshNotes();
  }

  Future<void> _updateItem(int id) async {
    await DBHelper.updateItem(
        id, _titleController.text, _descriptionController.text);
    _refreshNotes();
  }

  Future<void> _deleteItem(int id) async {
    await DBHelper.deleteItem(id);
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(LocaleKeys.delete_text.tr())));
    }
    _refreshNotes();
  }

  void _showForm(int? id) {
    if (id != null) {
      final existingNote = _notes.firstWhere((element) => id == element['id']);
      _titleController.text = existingNote['title'];
      _descriptionController.text = existingNote['description'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.only(
                top: 15, left: 15, right: 15, bottom: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration:
                      InputDecoration(hintText: LocaleKeys.title_text.tr()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                      hintText: LocaleKeys.description_text.tr()),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addItem();
                    } else {
                      await _updateItem(id);
                    }
                    // clear the textFields
                    _titleController.clear();
                    _descriptionController.clear();
                    // close the bottom sheet
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(id == null
                      ? LocaleKeys.create_text.tr()
                      : LocaleKeys.update_text.tr()),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.app_name.tr()), actions: [
        PopupMenuButton(
          initialValue: _selectedLanguage,
          onSelected: (language) {
            if (language == Languages.ar) {
              context.setLocale(const Locale('ar'));
            } else {
              context.setLocale(const Locale('en'));
            }
            setState(() {
              _selectedLanguage = language;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem<Languages>(
                value: Languages.ar, child: Text('العربية')),
            const PopupMenuItem<Languages>(
                value: Languages.en, child: Text('English')),
          ],
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              color: Colors.orangeAccent,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text(_notes[index]['title']),
                subtitle: Text(_notes[index]['description']),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () => _showForm(_notes[index]['id']),
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () => _deleteItem(_notes[index]['id']),
                          icon: const Icon(Icons.delete)),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: _notes.length),
    );
  }
}
