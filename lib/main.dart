import 'package:ecom/app/app_state.dart';
import 'package:ecom/app/routes.dart';
import 'package:ecom/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [thunkMiddleware],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Ecom Redux App',
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.home,
        routes: Routes.all,
        theme: ThemeData(fontFamily: 'Roboto'),
      ),
    );
  }
}