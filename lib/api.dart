import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:final_640710516/helper/api_caller.dart';
import 'package:final_640710516/helper/dialog_utils.dart';
import 'package:final_640710516/helper/my_list_tile.dart';
import 'package:final_640710516/helper/my_text_field.dart';
import 'package:final_640710516/Web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Web> _Webs = [];
  final TextEditingController myController = TextEditingController();
  final TextEditingController myController2 = TextEditingController();
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    _loadWebs();
  }

  Future<void> _loadWebs() async {
    try {
      final data = await ApiCaller().get("web_types");
      // ข้อมูลที่ได้จาก API นี้จะเป็น JSON array ดังนั้นต้องใช้ List รับค่าจาก jsonDecode()
      List list = jsonDecode(data);
      setState(() {
        _Webs = list.map((json) => Web.fromJson(json)).toList();
      });
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  void _handleClickButton(int x) {
    setState(() {
      _selectedIndex = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Webby Fondue"),
        centerTitle: true,
        backgroundColor: Colors.red,
        bottom: PreferredSize(
          child: Text('ระบบรายงานเว็บเลวๆ'),
          preferredSize: Size.zero,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('*ต้องกรอกข้อมูล', style: textTheme.titleMedium),
            MyTextField(
              controller: myController,
              hintText: 'URL*',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8.0),
            MyTextField(
              controller: myController2,
              hintText: 'รายละเอียด',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 8.0),
            Text('ระบุประเภทเว็บเลว*', style: textTheme.titleMedium),
            Expanded(
              child: ListView.builder(
                itemCount: _Webs.length,
                itemBuilder: (context, index) {
                  final item = _Webs[index];
                  return Card(
                    child: MyListTile(
                      title: item.title,
                      subtitle: item.subtitle,
                      imageUrl: ('https://cpsu-api-49b593d4e146.herokuapp.com' +
                          item.image),
                      selected: false,
                      onTap: () {
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
                onPressed: () async {
                  print('URL: ${myController.text}');
                  print('รายละเอียด: ${myController2.text}');

                  final data1 = await ApiCaller().post('ส่งข้อมูล', params: {
                    'url': myController.text,
                    'detail': myController2.text,
                    'Result': true,
                  });
                  Map map = jsonDecode(data1);
                  String text =
                      'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
                  showOkDialog(
                      context: context, title: "Success", message: text);
                },
                child: const Text('ส่งข้อมูล')),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApiPost() async {
    try {
      final data = await ApiCaller().post(
        "todos",
        params: {
          "userId": 1,
          "title": "ทดสอบๆๆๆๆๆๆๆๆๆๆๆๆๆๆ",
          "completed": true,
        },
      );
      // API นี้จะส่งข้อมูลที่เรา post ไป กลับมาเป็น JSON object ดังนั้นต้องใช้ Map รับค่าจาก jsonDecode()
      Map map = jsonDecode(data);
      String text =
          'ส่งข้อมูลสำเร็จ\n\n - id: ${map['id']} \n - userId: ${map['userId']} \n - title: ${map['title']} \n - completed: ${map['completed']}';
      showOkDialog(context: context, title: "Success", message: text);
    } on Exception catch (e) {
      showOkDialog(context: context, title: "Error", message: e.toString());
    }
  }

  Future<void> _handleShowDialog() async {
    await showOkDialog(
      context: context,
      title: "This is a title",
      message: "This is a message",
    );
  }
}
