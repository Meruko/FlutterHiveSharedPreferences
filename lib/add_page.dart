import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'item.dart';
import 'main.dart';

String _hiveName = "hive_items";

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  
  @override
  State<AddPage> createState() => _AddPage();
}

class _AddPage extends State<AddPage> {
  late TextEditingController _controller;
  late final Box<Item> box;

  @override
  void initState() {
    super.initState();

    box = Hive.box(_hiveName);
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          box.add(Item(box.values.length+1, _controller.text));
          needLoading = true;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Добавлено!!!!'))
          );
        },
        child: const Icon(Icons.add),
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
