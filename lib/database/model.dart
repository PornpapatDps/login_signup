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

  Map<String, dynamic> toMap() {
    return {
      colDescription: description, // แปลงคำอธิบายเป็น Map
      colAmount: amount, // แปลงจำนวนเงินเป็น Map
      colDate: date.toIso8601String(), // แปลงวันที่เป็นรูปแบบสตริง
      colIsIncome: isIncome, // แปลงสถานะรายได้หรือค่าใช้จ่ายเป็น Map
    };
  }

  Map<String, dynamic> toJson() {
    return {
      colDescription: description, // แปลงคำอธิบายเป็น JSON
      colAmount: amount, // แปลงจำนวนเงินเป็น JSON
      colDate: date.toIso8601String(), // แปลงวันที่เป็นรูปแบบสตริง JSON
      colIsIncome: isIncome, // แปลงสถานะรายได้หรือค่าใช้จ่ายเป็น JSON
      'referenceId': referenceId, // รหัสอ้างอิงในรูปแบบ JSON
    };
  }
}
