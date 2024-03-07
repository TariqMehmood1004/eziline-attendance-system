import 'package:android_attendance_system/bloc/counter_bloc/counter_event.dart';
import 'package:android_attendance_system/bloc/counter_bloc/counter_state.dart';
import 'package:bloc/bloc.dart';

class CounterBloc extends Bloc<CounterEvents, CounterStates> {
  CounterBloc() : super(const CounterStates()) {
    on<IncrementCounter>(_incrementCounter);
    on<DecrementCounter>(_decrementCounter);
  }

  void _incrementCounter(IncrementCounter event, Emitter<CounterStates> emit) {
    emit(state.copyWith(counter: state.counter + 1));
  }

  void _decrementCounter(DecrementCounter event, Emitter<CounterStates> emit) {
    emit(state.copyWith(counter: state.counter - 1));
  }
}
