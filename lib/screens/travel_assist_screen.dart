import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/washi_surface.dart';
import '../services/app_repository.dart';
import 'split_bill_screen.dart';
import 'ticket_storage_screen.dart';
import 'travel_expense_screen.dart';

class TravelAssistScreen extends StatelessWidget {
  const TravelAssistScreen({super.key, required this.repository});
  final AppRepository repository;

  void _push(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: '旅の手助け',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/home/card_assist.jpg',
              height: 190,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          WashiCard(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.folder_copy_outlined, size: 36),
              title: const Text('電子チケット保存', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('旅行ごとにフォルダを作り、QRコードや電子チケットの画像をまとめて保存します。'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _push(context, const TicketStorageScreen()),
            ),
          ),
          const SizedBox(height: 10),
          WashiCard(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.receipt_long_outlined, size: 36),
              title: const Text('割り勘計算', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('金額と人数を手入力し、端数処理・商品ごとの担当を指定して計算します。'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _push(context, SplitBillScreen(repository: repository)),
            ),
          ),
          const SizedBox(height: 10),
          WashiCard(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.savings_outlined, size: 36),
              title: const Text('旅の支出記録', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('食事・交通・宿泊などの支出を記録し、月別・カテゴリ別・旅ごとに確認できます。'),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _push(context, TravelExpenseScreen(repository: repository)),
            ),
          ),
        ],
      ),
    );
  }
}
