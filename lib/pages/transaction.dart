import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
// import 'package:firebase_core/firebase_core.dart'; // Firebase Core
import 'package:login_signup/database/database_helper.dart';
// import 'package:login_signup/database/model.dart';

class TransactionScreen extends StatefulWidget {
  final DatabaseHelper dbHelper;

  TransactionScreen({Key? key, required this.dbHelper}) : super(key: key);
  
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions(); // Fetch transactions when the screen loads
  }

  Future<void> _fetchTransactions() async {
    final snapshot = await FirebaseFirestore.instance.collection(Transaction.collectionName).get();
    setState(() {
      transactions = snapshot.docs.map((doc) {
        final data = doc.data();
        return Transaction(
          description: data[Transaction.colDescription],
          amount: data[Transaction.colAmount],
          date: DateTime.parse(data[Transaction.colDate]),
          isIncome: data[Transaction.colIsIncome],
          referenceId: doc.id, // Store the document ID for reference
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.business_center_rounded),
            SizedBox(width: 8), // Add some space between icon and text
            Text('Transactions'),
          ],
        ),
      ),
      body: transactions.isEmpty
          ? Center(child: Text('No Transactions'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  title: Text(transaction.description),
                  subtitle: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteTransaction(transaction),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddTransactionDialog() async {
    final descriptionController = TextEditingController();
    final amountController = TextEditingController();
    bool isIncome = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SwitchListTile(
                title: Text('Is Income?'),
                value: isIncome,
                onChanged: (value) {
                  setState(() {
                    isIncome = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _insertTransaction(descriptionController.text, double.tryParse(amountController.text) ?? 0.0, isIncome);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _insertTransaction(String description, double amount, bool isIncome) async {
    final newTransaction = Transaction(
      description: description,
      amount: amount,
      date: DateTime.now(),
      isIncome: isIncome,
    );

    await FirebaseFirestore.instance.collection(Transaction.collectionName).add(newTransaction.toJson());
    _fetchTransactions(); // Refresh the transaction list
  }

  Future<dynamic> _showConfirmDialog(BuildContext context, String confirmMsg) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(confirmMsg),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTransaction(Transaction transaction) {
    _showConfirmDialog(context, 'Are you sure you want to delete this transaction?').then((value) {
      if (value) {
        FirebaseFirestore.instance.collection(Transaction.collectionName).doc(transaction.referenceId).delete().then((_) {
          _fetchTransactions(); // Refresh the transaction list after deletion
        });
      }
    });
  }
}

class Transaction {
  String description; // คำอธิบายของการทำธุรกรรม
  double amount; // จำนวนเงินของการทำธุรกรรม
  DateTime date; // วันที่ของการทำธุรกรรม
  bool isIncome; // true สำหรับรายได้, false สำหรับค่าใช้จ่าย
  String? referenceId; // รหัสอ้างอิงที่เป็นทางเลือก

  static const collectionName = 'transactions'; // ชื่อคอลเลกชัน
  static const colDescription = 'description'; // ชื่อคอลัมน์สำหรับคำอธิบาย
  static const colAmount = 'amount'; // ชื่อคอลัมน์สำหรับจำนวนเงิน
  static const colDate = 'date'; // ชื่อคอลัมน์สำหรับวันที่
  static const colIsIncome = 'isIncome'; // ชื่อคอลัมน์สำหรับรายได้หรือค่าใช้จ่าย

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    required this.isIncome,
    this.referenceId,
  });

  Map<String, dynamic> toJson() {
    return {
      colDescription: description, // แปลงคำอธิบายเป็น JSON
      colAmount: amount, // แปลงจำนวนเงินเป็น JSON
      colDate: date.toIso8601String(), // แปลงวันที่เป็นรูปแบบสตริง JSON
      colIsIncome: isIncome, // แปลงสถานะรายได้หรือค่าใช้จ่ายเป็น JSON
    };
  }
}
