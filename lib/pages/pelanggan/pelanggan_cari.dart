import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/helper/db_helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FindCustomer extends StatefulWidget {
  const FindCustomer({Key? key}) : super(key: key);

  @override
  _FindCustomerState createState() => _FindCustomerState();
}

class _FindCustomerState extends State<FindCustomer> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  List listData = [];

  void pencarian(String keyWord) async {
    final _db = await DBHelper.db();
    final sql = 'SELECT * FROM pelanggan WHERE nama LIKE ?';
    listData = (await _db?.rawQuery(sql, ['%$keyWord%']))!;
    _refreshController.refreshCompleted();
    setState(() {});
  }

  Widget item(Map d) => ListTile(
        title: Text('${d['nama']}'),
        subtitle: Text('${d['tgl_lahir']}'),
        leading: Text('${d['gender']}'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(color: Colors.black54),
          backgroundColor: Colors.white,
          elevation: 1,
          title: CupertinoSearchTextField(
            placeholder: 'search customer',
            onSubmitted: (s) {
              pencarian(s);
            },
          )),
      body: ListView(
        children: [for (Map d in listData) item(d)],
      ),
    );
  }
}
