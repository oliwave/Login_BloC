import 'package:flutter/material.dart';
import '../blocs/bloc.dart';
import '../blocs/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          emailField(bloc),
          passwordField(bloc),
          Container(
            margin: EdgeInsets.only(top: 25.0),
          ),
          submitButton(bloc)
        ],
      ),
    );
  }

  /// 沒有傳入bloc參數是使用第一種state management的方法 ＝> Single Global Instance

  Widget emailField(Bloc bloc) {
    // bloc 參數
    return StreamBuilder(
      //綁定一個stream, 讓StreamBuilder來監測從stream來的新事件
      stream: bloc.email,
      // 當stream有改變時, 就調用builder function而該方法返回一個新的
      builder: (context, snapshot) {
        // snapshot 儲存stream所射出的event(error或data)
        return TextField(
          keyboardType: TextInputType.emailAddress,
          // 當textField的數據(String)有改變時, 就將數據加入到sink當中
          onChanged: bloc.emailChange, // callback function
          decoration: InputDecoration(
              hintText: 'you@gmail.com',
              labelText: 'Email Address',
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget passwordField(Bloc bloc) {
    // 用來包裝會重新渲的widget, 取代先前用的statefulWidget的setState方法
    return StreamBuilder(
      // 監聽該stream, 當有新的event進來就調用builder function
      stream: bloc.password,
      // 重新渲染畫面返回一個新的widget
      builder: (context, snapshot) {
        // snapshot 持有該StreamBuilder所監聽的stream所射出的event
        return TextField(
          // 將改變的資料加入到sink當中
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
              labelText: 'Password', errorText: snapshot.error // 取出事件
              ),
//          obscureText: true,
        );
      },
    );
  }

  Widget submitButton(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.blue,
          // 如果 snapshot.data 不等於 null (代表已經輸入過) 就進行正確資料或錯誤資料的判斷(決定按鈕可不可以案)
          // 如果 snapshot.data 等於 null 就傳null(不能按按鈕)
          onPressed: snapshot.data != null
              ? (snapshot.data ? bloc.submit : null)
              : null,
        );
      },
    );
  }
}
