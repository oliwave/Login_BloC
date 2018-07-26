import 'dart:async';

import 'validators.dart';

import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validator {
  //設為private變數, 其他檔案引入此當按時將看不到該變數
//  final _email = StreamController<String>.broadcast();
//  final _password = StreamController<String>.broadcast();

  // 他會紀錄最新加到controller的event, 並且他默認是一個broadcast controller. 也就是說,
  // stream可已被監聽多次
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();

  // add a sink
  Function(String) get emailChange => _email.sink.add;

  Function(String) get changePassword => _password.sink.add;

  // add a stream
  // email 和 password stream 都已經在login_screen裡面被註冊監聽且消耗掉了, 所以
  // 下面的submitValid就不能在註冊監聽email password stream 一次了, 因為他們是
  // single-subscription stream 不是 broadcast stream.
  // 結論 ： 上面兩個stream就必須改為broadcast stream
  Stream<String> get email => _email.stream.transform(validateEmail);

  Stream<String> get password => _password.stream.transform(validatePassword);

  Stream<bool> get submitValid => Observable.combineLatest2(
        // 為了要清除error event, 因為該方法不會保留error event他只保留data event
        email.transform(withoutError),
        password.transform(withoutError),
        (e, p) {
          return e && p ? true : false;
        },
      );

  // 事件的觸發 處理 輸出 都是當下一連貫的, 所以沒有可延後幾秒才去監聽我想要的stream裡面的事件早就都沒了
  // BehaviorSubject 這種StreamController可以幫忙記錄最新的event以便之後需要使用
  submit() {
    final validEmail = _email.value;
    final validPassword = _password.value;

    print('Email is $validEmail');
    print('Password is $validPassword');
  }

  // 每一個class都有這個方法, 他是用來清理我們在這個class所使用的變數或物件
  dispose() {
    // sink預設是會一直打開接收event, dart不希望這樣. 所以需要手動去關閉它或清理他
    _email.close();
    _password.close();
  }
}

/// Single Global Instance case
//final bloc = Bloc();
