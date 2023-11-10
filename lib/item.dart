import 'package:hive/hive.dart';

part 'item.g.dart'; 

@HiveType(typeId: 1)
class Item extends HiveObject{
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String name;

 get getId => this.id;

 set setId(id) => this.id = id;

  get getName => this.name;

 set setName( name) => this.name = name;

  Item(this.id,this.name);
}