import 'package:comments_viewer_application/models/user_model.dart';
import 'package:comments_viewer_application/services/alert_services.dart';
import 'package:comments_viewer_application/services/auth_services.dart';
import 'package:comments_viewer_application/services/database_services.dart';
import 'package:comments_viewer_application/services/navigator_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../consts.dart';
import '../widgets/custome_button.dart';
import '../widgets/custome_input_fiield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? name, email, password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final GetIt _getIt = GetIt.instance;
  late AuthServices _authServices;
  late AlertServices _alertServices;
  late NavigatorServices _navigatorServices;
  late DatabaseServices _databaseServices;

  @override
  void initState() {
    super.initState();
    _authServices = _getIt.get<AuthServices>();
    _alertServices = _getIt.get<AlertServices>();
    _navigatorServices = _getIt.get<NavigatorServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                if (!_isLoading) _buildSignupForm(),
                if (!_isLoading) _buildSignupButton(),
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

  Widget _buildSignupForm() {
    return Form(
      key: _globalKey,
      child: Column(
        children: [
          CostumeInputField(
            hintText: 'Name',
            obscureText: false,
            regExp: nameValidationRegex,
            onSave: (inputValue) {
              setState(() {
                name = inputValue;
              });
            },
          ),
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

  Widget _buildSignupButton() {
    return Column(
      children: [
        CostumeButton(
          text: 'Signup',
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            if (_globalKey.currentState!.validate()) {
              _globalKey.currentState!.save();
              //   call the services
              bool result =
                  await _authServices.signUp(email: email, password: password);
              if (result) {
                _databaseServices.createUserProfile(
                  userModel: UserModel(
                    name: name,
                    email: email,
                    uid: _authServices.user!.uid,
                  ),
                );
                _alertServices.showToastBar(
                  title: 'User Account Created Successfully!',
                );
                _navigatorServices.goBack();
              } else {
                throw Exception('Unable to Register User');
              }
            }

            setState(() {
              _isLoading = false;
            });
          },
        ),
        _buildSwitchToLoginLink(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildSwitchToLoginLink() {
    return GestureDetector(
      onTap: () {
        _navigatorServices.goBack();
      },
      child: RichText(
        text: TextSpan(
          text: 'Already have an account?',
          style: Theme.of(context).textTheme.bodySmall,
          children: [
            TextSpan(
              text: ' Login',
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
