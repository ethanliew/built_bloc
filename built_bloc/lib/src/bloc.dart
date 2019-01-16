import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:meta/meta.dart';

class Bloc {

  Bloc();

  @protected
  final List<StreamSubscription<dynamic>> subscriptions = [];

  @protected
  final List<Subject<dynamic>> subjects = [];

  @protected
  Subject<T> subject<T>(Subject<T> subject, {void onData(T newValue), Function onError, void onDone(), bool cancelOnError}) {
    this.subjects.add(subject);
    if(onData != null) {
      this.subscriptions.add(subject.stream.listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError));
    }
    return subject;
  }

  PublishSubject<T> publish<T>({void onData(T newValue), Function onError, void onDone(), bool cancelOnError}) {
    return this.subject(PublishSubject<T>(sync: true), onData: onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  BehaviorSubject<T> behavior<T>(T seedValue, {void onData(T newValue), Function onError, void onDone(), bool cancelOnError}) {
    return this.subject(BehaviorSubject<T>(sync: true, seedValue: seedValue), onData: onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @mustCallSuper
  void dispose() {
    this.subscriptions.forEach((s) => s.cancel());
    this.subjects.forEach((s) => s.close());
  }
}
