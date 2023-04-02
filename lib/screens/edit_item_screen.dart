import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/item_service.dart';

class EditItemScreen extends StatefulWidget {
  final String documentId;
  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemDesc = TextEditingController();

  EditItemScreen(this.documentId, String itemName, String itemDesc) {
    _itemName.text = itemName;
    _itemDesc.text = itemDesc;
  }

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final ItemService _itemService = ItemService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: widget._itemName,
              decoration: const InputDecoration(label: Text("Topic")),
            ),
            TextField(
              controller: widget._itemDesc,
              decoration: const InputDecoration(label: Text("Description")),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.redAccent,
    onPrimary: Colors.white,
  ),
  onPressed: _deleteItem,
  child: Row(
    children: [
      const Icon(Icons.delete_forever),
      const SizedBox(width: 8),
      const Text("Delete"),
    ],
  ),
)

                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: Colors.greenAccent,
    onPrimary: Colors.white,
  ),
  onPressed: _editItem,
  child: Row(
    children: [
      const Icon(Icons.edit),
      const SizedBox(width: 8),
      const Text("Edit"),
    ],
  ),
)

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editItem() {
    final String newName = widget._itemName.text;
    final String newDesc = widget._itemDesc.text;

    if (newName.isNotEmpty && newDesc.isNotEmpty) {
      _itemService.updateItem(widget.documentId, {
        'name': newName,
        'desc': newDesc,
      }).then((value) {
        Navigator.pop(context);
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Something wrong.'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Something wrong.'),
          content: const Text('Please complete th information.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    }
  }

  void _deleteItem() {
    _itemService.deleteItem(widget.documentId).then((value) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Successfully deleted'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Somthing wrong'),
          content: Text(error.toString()),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );
    });
  }
}
