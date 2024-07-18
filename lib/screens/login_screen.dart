import 'package:comments_viewer_application/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../services/alert_services.dart';
import '../services/auth_services.dart';

import '../services/navigator_services.dart';
import '../widgets/custome_button.dart';
import '../widgets/custome_input_fiield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email, password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final GetIt _getIt = GetIt.instance;
  late AuthServices _authServices;
  late AlertServices _alertServices;
  late NavigatorServices _navigatorServices;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    _navigatorServices = _getIt.get<NavigatorServices>();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                if (!_isLoading) _buildLoginForm(),
                if (!_isLoading) _buildLoginButtonAndSwitchToSignupLink(),
                if (_isLoading)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Text(
        'Comments',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          CostumeInputField(
            hintText: 'Email',
            obscureText: false,
            regExp: emailValidationRegex,
            onSave: (inputValue) {
              setState(() {
                email = inputValue;
              });
            },
          ),
          CostumeInputField(
            hintText: 'Password',
            obscureText: true,
            regExp: passwordValidationRegex,
            onSave: (inputValue) {
              setState(() {
                password = inputValue;
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButtonAndSwitchToSignupLink() {
    return Column(
      children: [
        CostumeButton(
          text: 'Login',
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            if (_globalKey.currentState!.validate()) {
              _globalKey.currentState!.save();
              //   call the services
              bool result =
                  await _authServices.logIn(email: email, password: password);
              if (result) {
                _alertServices.showToastBar(
                  title: 'Logged In successfully !',
                );
                _navigatorServices.pushReplacementNamed('/home');
              } else {
                _alertServices.showToastBar(
                  title: 'Unable to login user! Please try again.',
                );
              }
            }
            setState(() {
              _isLoading = false;
            });
          },
        ),
        _buildSwitchToSignUpLink(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildSwitchToSignUpLink() {
    return GestureDetector(
      onTap: () {
        _navigatorServices.pushNamed('/sign-up');
      },
      child: RichText(
        text: TextSpan(
          text: 'New here?',
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: ' Signup',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
