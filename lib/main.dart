import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lists_nav/login.dart';
import 'package:lists_nav/theme_changer.dart';
import 'package:provider/provider.dart';
import 'item.dart';
import 'add_page.dart';
import 'edit_page.dart';
import 'settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _hiveName = "hive_items";

late List<Item> items;
bool needLoading = true;
Item? currentItem;
late final SharedPreferences preferences;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox<Item>(_hiveName);
  preferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    late ThemeData theme;
    String? themeStr = preferences.get('theme')?.toString();

    if (themeStr == null){
      theme = lightTheme;
    }

    if (themeStr == 'light'){
      theme = lightTheme;
    }
    else if (themeStr == 'dark') {
      theme = darkTheme;
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeChanger(theme),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => BoxHelper(Hive.box(_hiveName)),
          lazy: true,
        )
      ],
      child: const MaterialAppWithTheme(),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme ({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      theme: theme.getTheme,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'My Items'),
      initialRoute: '',
      onGenerateRoute: (settings) {
        return switch (settings.name){
          'home' => MaterialPageRoute(
            builder: (context) {
              return const MyHomePage(title: 'My Items');
            } 
          ),
          'add' => MaterialPageRoute(
            builder: (context) {
              return const AddPage();
            } 
          ),
          'edit' => MaterialPageRoute(
            builder: (context) {
              return const EditPage();
            } 
          ),
          'settings' => MaterialPageRoute(
            builder: (context) {
              return const SettingsPage();
            } 
          ),
          _ => MaterialPageRoute(builder: (_) => const LoginPage(pass: '',))
        };
      },
    );
  }
}

class BoxHelper with ChangeNotifier{
  late final Box<Item> box;

  void replace(int oldIndex, int newIndex){
    if (newIndex > oldIndex){
      newIndex -= 1;
    }
    
    Item item = box.values.toList().removeAt(oldIndex);
    box.values.toList().insert(newIndex, item);
    notifyListeners();
  }

  List<Item> get(){
    return box.values.toList();
  }

  void add(Item item){
    box.add(item);
    notifyListeners();
  }

  void edit(Item item){
    box.put(item.key, item);
    notifyListeners();
  }

  void delete(int index){
    box.delete(box.values.toList()[index].key);
  }

  BoxHelper(this.box);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, 'settings');
              },
              child: const Icon(
                Icons.settings,
                size: 26.0,
              ),
            )
          ),
        ],
      ),
      body: ReorderableListView.builder(
        itemCount: context.watch<BoxHelper>().get().length,
        itemBuilder: (context, index) {
          final Item item = context.watch<BoxHelper>().get()[index];

          return Card(
            key: Key(index.toString()),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.outline
              ),
              borderRadius: const BorderRadius.all(Radius.circular(12))
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(item.name),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.create),
                    color: Colors.purple[300],
                    onPressed: () {
                      currentItem = item;
                      Navigator.pushNamed(context, 'edit');
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red[300],
                    onPressed: () {
                      context.read<BoxHelper>().delete(index);
                    },
                  ),
                ),
              ],
            ),
          );
        },
        onReorder: ((oldIndex, newIndex) {
          context.read<BoxHelper>().replace(oldIndex, newIndex);
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'add');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}