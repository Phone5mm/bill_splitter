import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NamesScreen extends StatefulWidget {
  const NamesScreen({super.key});

  @override
  State<NamesScreen> createState() => _NamesScreenState();
}

class _NamesScreenState extends State<NamesScreen> {
  final List<String> _names = [];
  final TextEditingController _nameController = TextEditingController();

  void _addName() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }
    if (_names.contains(name)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name already added')));
      return;
    }
    setState(() {
      _names.add(name);
      _nameController.clear();
    });
  }

  void _editName(int index) {
    _nameController.text = _names[index];
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Edit Name',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: _nameController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter name',
            border: OutlineInputBorder(),
          ),
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
            onPressed: () {
              _nameController.clear();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              'Save',
              style: GoogleFonts.poppins(color: Colors.teal.shade600),
            ),
            onPressed: () {
              final newName = _nameController.text.trim();
              if (newName.isEmpty ||
                  (_names.contains(newName) && newName != _names[index])) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Name is invalid or already exists'),
                  ),
                );
                return;
              }
              setState(() {
                _names[index] = newName;
                _nameController.clear();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _deleteName(int index) {
    setState(() {
      _names.removeAt(index);
    });
  }

  void _goToExpenses() {
    if (_names.length < 2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Add at least two people')));
      return;
    }
    Navigator.pushReplacementNamed(context, '/expenses', arguments: _names);
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = Colors.teal.shade600;
    final borderRadius = BorderRadius.circular(15);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Enter Names',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: accentColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: Colors.teal),
            tooltip: 'Start Over',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/names',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter name',
                      labelStyle: GoogleFonts.poppins(color: accentColor),
                      border: OutlineInputBorder(borderRadius: borderRadius),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(color: accentColor, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                    ),
                    style: GoogleFonts.poppins(fontSize: 15),
                    onSubmitted: (_) => _addName(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addName,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    minimumSize: const Size(90, 48),
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  ),
                  child: Text(
                    'Add',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'People added',
                style: GoogleFonts.poppins(
                  color: accentColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _names.isEmpty
                  ? Center(
                      child: Text(
                        'No names added yet.',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _names.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final name = _names[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: borderRadius,
                          ),
                          elevation: 3,
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: accentColor,
                              child: Text(
                                name[0].toUpperCase(),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: accentColor),
                                  tooltip: 'Edit',
                                  onPressed: () => _editName(index),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  ),
                                  tooltip: 'Delete',
                                  onPressed: () => _deleteName(index),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            ElevatedButton(
              onPressed: _goToExpenses,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: Text(
                'Next',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
