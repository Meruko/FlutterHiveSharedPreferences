import 'main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_changer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  
  @override
  State<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late TextEditingController _controllerFIO;
  late TextEditingController _controllerPass;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    String? fio = preferences.get('fio')?.toString();
    _controllerFIO = fio == null ? TextEditingController() : TextEditingController(text: fio);

    String? pass = preferences.get('pass')?.toString();
    _controllerPass = pass == null ? TextEditingController(text: 'pass') : TextEditingController(text: pass);

    String? birthDate = preferences.get('birth_date')?.toString();
    selectedDate = birthDate == null ? DateTime.now() : DateTime.parse(birthDate);
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _themeProvider=Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          preferences.setString('fio', _controllerFIO.text);
          preferences.setString('birth_date', selectedDate.toString());
          preferences.setString('pass', _controllerPass.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Сохранено!'))
          );
        },
        child: const Icon(Icons.check),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controllerFIO,
            decoration: const InputDecoration(
              labelText: 'Enter FIO',
            ),
          ),
          TextField(
            controller: _controllerPass,
            decoration: const InputDecoration(
              labelText: 'Enter Password',
            ),
          ),
          Text(
            "${selectedDate.toLocal()}".split(' ')[0],
            style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context), // Refer step 3
            child: const Text('Select birth date',),
          ),
          ElevatedButton(
            child:Text("Change Theme!"), 
            onPressed:(){
              ThemeData theme;
              if (_themeProvider.getTheme==lightTheme){
                theme = darkTheme;
                preferences.setString('theme', 'dark');
              }
              else {
                theme = lightTheme;
                preferences.setString('theme', 'light');
              }
              _themeProvider.setTheme(theme);
            }
          )
        ],
      ),
    );
  }
}
