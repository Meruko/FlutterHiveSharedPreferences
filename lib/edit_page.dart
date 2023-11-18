import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lists_nav/item.dart';
import 'package:provider/provider.dart';
import 'main.dart';

String _hiveName = "hive_items";

class EditPage extends StatefulWidget {
  const EditPage({super.key});
  
  @override
  State<EditPage> createState() => _EditPage();
}

late Item item;

class _EditPage extends State<EditPage> {
  late TextEditingController _controller;
  late final Box<Item> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box(_hiveName);
  }

  @override
  Widget build(BuildContext context) {
    item = currentItem!;
    _controller = TextEditingController(text: item.name);

    return Scaffold(
    appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          item.setName = _controller.text;
          context.read<BoxHelper>().edit(item);
          needLoading = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Именено!!!!'))
          );
        },
        child: const Icon(Icons.edit),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter text',
            ),
          ),
        ],
      ),
    );
  }
}