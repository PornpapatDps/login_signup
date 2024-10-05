import 'package:flutter/material.dart';
import '../database/auth.dart';
import '../database/database_helper.dart';
import 'transaction.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _passwd = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final Color primaryColor = const Color(0xFF1E88E5); // สีฟ้าสว่าง
  final Color secondaryColor = const Color(0xFF1565C0); // สีกรมท่าเข้ม
  final Color backgroundColor = const Color(0xFF1C2833); // พื้นหลังโทนกรมท่าไล่สีเข้มไปอ่อน
  final Color cardStartColor = const Color(0xFF0A2342); // ไล่สีการ์ดเริ่มต้น (เข้ม)
  final Color cardEndColor = const Color(0xFF1E3A5F); // ไล่สีการ์ด (อ่อนกว่า)

  Future _showAlert(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero, // ใช้เป็น 0 เพื่อให้ใช้ได้ทั้ง Container
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0)),
        ),
        content: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0A2342), Color(0xFF1E3A5F)], // ไล่สีการ์ดใน Alert
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(18.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ขนาดของ Alert ใหญ่ตามเนื้อหา
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C2833), Color(0xFF2C3E50)], // ไล่สีพื้นหลัง กรมท่าเข้มไปอ่อน
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cardStartColor, cardEndColor], // ไล่สีการ์ด
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(25.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Wallets +',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buildTextField(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    isPassword: false,
                    icon: Icons.email,
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 25.0),
                  _buildPasswordField(),
                  const SizedBox(height: 35.0),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: primaryColor,
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });

                              await UserAuthenticator()
                                  .signInWithEmailAndPassword(_email, _passwd)
                                  .then((res) {
                                setState(() {
                                  _isLoading = false;
                                });
                                if (res == true) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => TransactionScreen(
                                          dbHelper: DatabaseHelper())));
                                  setState(() {
                                    _email = '';
                                    _passwd = '';
                                  });
                                } else {
                                  _showAlert(context,
                                      'Invalid login credentials!');
                                }
                              });
                            },
                            child: const Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  // const SizedBox(height: 20.0),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Add Forgot Password Logic
                  //   },
                  //   child: const Text(
                  //     "Forgot your password?",
                  //     style: TextStyle(
                  //       color: Colors.white70,
                  //       decoration: TextDecoration.underline,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required bool isPassword,
    required IconData icon,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          obscureText: !_isPasswordVisible,
          onChanged: (value) => _passwd = value,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: Colors.white),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            hintText: "Enter your password",
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
