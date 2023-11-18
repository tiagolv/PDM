import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'firebase_auth_implementation/firebase_auth_services.dart';
import 'windowGeneral.dart';
import 'windowRegister.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'Management.dart';
import 'windowHome.dart';
import 'Utils.dart';
import 'database_help.dart';

void main() async {
  DatabaseHelper.db();

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class SelectableButton extends StatefulWidget {
  const SelectableButton({
    super.key,
    required this.selected,
    this.style,
    required this.onPressed,
    required this.child,
  });

  final bool selected;
  final ButtonStyle? style;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  State<SelectableButton> createState() => _SelectableButtonState();
}

class _SelectableButtonState extends State<SelectableButton> {
  late final MaterialStatesController statesController;

  @override
  void initState() {
    super.initState();
    statesController = MaterialStatesController(
        <MaterialState>{if (widget.selected) MaterialState.selected});
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      statesController: statesController,
      style: widget.style,
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Management appManagement = Management("APP-RideWME");
    appManagement.Load();
    return MaterialApp(
      title: 'RideWME',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 20, 39, 61),
        // body background
        primaryColor: Color.fromARGB(130, 9, 21, 27),
        // appbar top
         secondaryHeaderColor: Color.fromARGB(255, 201, 128, 94),
        //secondaryHeaderColor: Color.fromARGB(255,85, 126, 167),
        //secondaryHeaderColor: Color.fromARGB(230, 199, 60, 18),
        // details, like buttons
        useMaterial3: true,
      ),
      home: MyHomePage(appManagement,
          appManagement.GetDefinicao("TITULO_APP", "TITULO_APP ??")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Management Ref_Management;

  MyHomePage(this.Ref_Management, this.title);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(Ref_Management);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    DatabaseHelper.db();
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _pass.dispose();

    super.dispose();
  }

  bool selected = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // _formKey
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  final FirebaseAuthService _auth = FirebaseAuthService();

  int _counter = 0;
  Management Ref_Management;

  _MyHomePageState(this.Ref_Management);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Widget Create_Button_New_Window_Register() {
    double TAM = double.parse(
        Ref_Management.GetDefinicao("TAMANHO_TEXTO_BTN_NEW_REGISTER", "10"));
    return SelectableButton(
        selected: selected,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return null; // defer to the defaults
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.white;
              }
              return null; // defer to the defaults
            },
          ),
        ),
        onPressed: () {
          setState(
            () {
              selected = !selected;
              UtilsFlutter.MSG(Ref_Management.GetDefinicao(
                  "TEXT_NEW_WINDOW_REGISTER",
                  "Accao-TEXT_NEW_WINDOW_REGISTER ??"));
              NavigateTo_Window_Register(context);
            },
          );
        },
        child: Text(
          Ref_Management.GetDefinicao(
              "TEXT_OF_BUTTON_REGISTER", "TEXT_NEW_WINDOW_REGISTER ??"),
          style: TextStyle(
              fontFamily: 'Lato',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(240, 85, 126, 167)),
        ));
  }

  /// -----------------------------------
  ///            WINDOW FUNCTIONS
  /// -----------------------------------
  //--------- Janela Register
  Future NavigateTo_Window_Register(context) async {
    windowRegister win = new windowRegister(Ref_Management);
    await win.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => win));
  }

  //--------- Janela Home
  Future NavigateTo_Window_Home(context) async {
    windowHome Jan = new windowHome(Ref_Management);
    await Jan.Load();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Jan));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            widget.title,
            style: TextStyle(
                fontFamily: 'Lato', fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(140),
                            /*boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 0,
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],*/
                          ),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Color.fromARGB(0, 0, 0, 0),
                            backgroundImage: AssetImage('assets/LOGO.png'),
                          ),
                        ),
                        SizedBox(
                          height:
                              40, // meter isto responsivo e meter no management
                        ),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            icon: Icon(Icons.alternate_email),
                            iconColor: Colors.white,
                            labelText: Ref_Management.SETTINGS
                                .Get("WND_LOGIN_HINT_1", "WND_LOGIN_HINT_1 ??"),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0), // Set the border color here
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent, width: 3.0), // Set the border color here
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return value;
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: _pass,
                          obscureText: bool.parse(Ref_Management.SETTINGS
                              .Get("WND_REGISTER_OBSTEXT_3", "true")),
                          decoration: InputDecoration(
                            icon: Icon(Icons.password_outlined),
                            iconColor: Colors.white,
                            labelText: Ref_Management.SETTINGS
                                .Get("WND_LOGIN_HINT_2", "WND_LOGIN_HINT_2 ??"),
                            labelStyle: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0), // Set the border color here
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent, width: 3.0), // Set the border color here
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Lato',
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).secondaryHeaderColor,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              minimumSize: Size(double.infinity, 0),
                            ),
                            onPressed: () {
                              _signIn();
                              if (_formKey.currentState!.validate()) {
                              } else {
                                Utils.MSG_Debug("ERROR");
                              }
                            },
                            child: Text(
                              Ref_Management.SETTINGS
                                  .Get("WND_LOGIN_BTN_1", "WND_LOGIN_BTN_1 ??"),
                              style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ), // adicionar aqui isto Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        // CriarButton_New_Window_Login(),
                        Create_Button_New_Window_Register(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //--------------
  void _signIn() async {
    String username = _username.text;
    String email = _email.text;
    String password = _pass.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      Utils.MSG_Debug("User is signed");
      NavigateTo_Window_Home(context);
      _email.clear();
      _username.clear();
      _pass.clear();
    } else {
      Utils.MSG_Debug("ERROR");
    }
  }
}
