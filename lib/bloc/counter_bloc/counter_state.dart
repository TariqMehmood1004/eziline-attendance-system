import 'package:equatable/equatable.dart';

class CounterStates extends Equatable {
  final int counter;

  const CounterStates({this.counter = 0});

  CounterStates copyWith({int? counter}) {
    return CounterStates(counter: counter ?? this.counter);
  }

  @override
  List<Object> get props => [counter];
}
