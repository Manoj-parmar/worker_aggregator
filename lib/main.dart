
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'launguage_provider.dart';
import 'login_form.dart';
import 'signup_form.dart';
import 'style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAppCheck.instance.activate();
  runApp(
      ChangeNotifierProvider(
    create: (context)=> LaunguageProvider(),
    child: MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales:const[
        Locale('en'),
        Locale('hi'),
      ] ,

    locale:context.watch<LaunguageProvider>().selectedLocale,

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      title: 'Work Daily',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      home: AuthenticationPage(),
    );
  }
}
//This pattern is commonly used in Flutter applications to create interactive user interfaces where elements can change based on user input or other events.
class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _showLogin = true;
// user wants to switch between the login and signup forms
  void _toggleForm() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showLogin ? 'Work Daily' : 'Work Daily',
          style: AppStyles.appBarTitle,
        ),
        backgroundColor: AppStyles.appBarColor,
        actions: [
          DropdownMenu(
            textStyle:const TextStyle(color: Colors.white),
            initialSelection: context.watch<LaunguageProvider>().selectedLocale,
            onSelected: (value){
              context.read<LaunguageProvider>().changeLanguage(value as String);
            },
            dropdownMenuEntries:  LaunguageProvider.languages.map((language) => DropdownMenuEntry(
                value: language['local'],
                label: language['name']
          )
    ).toList(),)
        ],
      ),
      body: Center(
        child: _showLogin ? LoginForm() : SignupForm(),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.deepPurple,
          ),
          onPressed: _toggleForm,
          child: Text(_showLogin
              ? 'Don\'t have an account? Sign Up'
              : 'Already have an account? Login'),
        ),
      ),
    );
  }
}
