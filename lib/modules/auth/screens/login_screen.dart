// import 'dart:convert';

// import 'package:ecom/config.dart';
import 'package:ecom/modules/auth/services/auth_service.dart';
import 'package:ecom/shared/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:ecom/app/app_state.dart';
import 'package:ecom/app/routes.dart';
import 'package:ecom/redux/actions.dart';
// import 'package:http/http.dart' as http;
import 'package:ecom/shared/services/storage_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isBusiness = false;
  bool _isLoading = false;
  String? _error;
  String? token;

// @override
// void initState() {
//   super.initState();
// }
// Future <void> loginBusiness() async {
//   setState(() {
//     _isLoading = true;
//     _error = null;
//   });
//   final url = Uri.parse('${AppConfig.apiUrl}/auth/business/login');
//   final header = {
//     'Content-Type': 'application/json',
//   };
//   final body = jsonEncode({
//     'identifier': _identifierController.text,
//     'password': _passwordController.text,
//   });

//   try{
//     final response = await http.post(
//       url,
//       headers: header,
//       body: body,
//     );
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       StoreProvider.of<AppState>(context).dispatch(LoginSuccessAction(
//         token: data['token'],
//         user: data['user'],
//         isBusiness: true,
//       ));
//       Navigator.pushReplacementNamed(context,'/dashboard');
//     } else {
//       setState(() {
//         _error = 'Login failed: ${response.reasonPhrase}';
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _error = 'An error occurred: $e';
//     });
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

// // i need a integrate userLogin function here
// Future<void> loginUser() async {
//   setState(() {
//     _isLoading = true;
//     _error = null;
//   }); 
//   final url = Uri.parse('${AppConfig.apiUrl}/api/user/login');
//   final header = {
//     'Content-Type': 'application/json',
//   };
//   final body = jsonEncode({
//     'identifier': _identifierController.text,
//     'password': _passwordController.text,
//   }); 
//   try {
//     final response = await http.post(
//       url,
//       headers: header,
//       body: body,
//     );
//     print('Response status: ${response.statusCode}');
//     print('Response body: ${response.body}');
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       StoreProvider.of<AppState>(context).dispatch(LoginSuccessAction(
//         token: data['token'],
//         user: data['user'],
//         isBusiness: false,
//       ));
//       Navigator.pushReplacementNamed(context, '/dashboard');
//     } else {
//       setState(() {
//         _error = 'Login failed: ${response.reasonPhrase}';
//       });
//     }
//   } catch (e) {
//     setState(() {
//       _error = 'An error occurred: $e';
//     });
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService(ApiService(StorageService()));

    return StoreConnector<AppState, dynamic>(
      converter: (store) => store,
      builder: (context, store) {
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF880E4F)],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: Colors.white.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Please log in using your username or email and password.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          if (_error != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red),
                              ),
                              child: Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          if (_error != null) const SizedBox(height: 16),
                          ToggleButtons(
                            isSelected: [_isBusiness == false, _isBusiness == true],
                            onPressed: (index) {
                              setState(() {
                                _isBusiness = index == 1;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            selectedColor: Colors.white,
                            fillColor: Colors.transparent,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'User Login',
                                  style: TextStyle(
                                    color: !_isBusiness ? Colors.white : Colors.white70,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Business Login',
                                  style: TextStyle(
                                    color: _isBusiness ? Colors.white : Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _identifierController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: _isBusiness ? 'Business Username or Email' : 'Username or Email',
                              prefixIcon: const Icon(Icons.email, color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your identifier';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                            ),
                            style: const TextStyle(color: Colors.white),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                          _error = null;
                                        });

                                        try {
                                          final response = _isBusiness
                                              ? await authService.loginBusiness(
                                                  _identifierController.text,
                                                  _passwordController.text,
                                                )
                                              : await authService.loginUser(
                                                  _identifierController.text,
                                                  _passwordController.text,
                                                );

                                          store.dispatch(LoginSuccessAction(
                                            token: response['token'],
                                            user: response['user'],
                                            isBusiness: _isBusiness,
                                          ));

                                          Navigator.pushReplacementNamed(
                                              context, Routes.dashboard);
                                        } catch (e) {
                                          setState(() {
                                            _error = e.toString();
                                          });
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Login', style: TextStyle(fontSize: 18)),
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.userRegister),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Create User Account'),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, Routes.businessRegister),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Create Business Account'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}