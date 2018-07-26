import 'dart:async';

class Validator {
  // StreamTransformer 定義好他可以接受的event類型以及輸出的類型
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Enter a valid email');
    }
  });

  final validatePassword = StreamTransformer.fromHandlers<String, String>(
      handleData: (password, sink) {
    if (password.length > 3) {
      sink.add(password);
    } else {
      sink.addError('password must be at least 4 characters');
    }
  });

  final withoutError =
  StreamTransformer.fromHandlers<String, bool>(
      handleError: (error, stackTrace, sink) {
    sink.add(false);
  }, handleData: (correct, sink) {
    sink.add(true);
  });

}
