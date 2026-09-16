import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '設定',
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('アプリについて'),
              subtitle: Text('旅の記録・予定・スタンプなどのデータは端末内に保存されます。'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.tune),
              title: Text('各種設定'),
              subtitle: Text('今後、設定項目を追加できる画面です。'),
            ),
          ),
        ],
      ),
    );
  }
}
