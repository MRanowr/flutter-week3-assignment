import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyAppRiverpod()));
}

// 1. تعريف حالة العداد (State)
class CounterState {
  final int count;
  final bool isPaused;

  CounterState({this.count = 0, this.isPaused = false});

  CounterState copyWith({int? count, bool? isPaused}) {
    return CounterState(
      count: count ?? this.count,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}

// 2. Notifier لإدارة العمليات
class CounterNotifier extends StateNotifier<CounterState> {
  CounterNotifier() : super(CounterState());

  void increment() {
    if (!state.isPaused) {
      state = state.copyWith(count: state.count + 1);
    }
  }

  void decrement() {
    if (!state.isPaused && state.count > 0) {
      state = state.copyWith(count: state.count - 1);
    }
  }

  void togglePause() {
    state = state.copyWith(isPaused: !state.isPaused);
  }

  void reset() {
    state = CounterState(count: 0, isPaused: false);
  }
}

// 3. ربط الـ Provider
final counterProvider = StateNotifierProvider<CounterNotifier, CounterState>(
  (ref) => CounterNotifier(),
);

// 4. الواجهة الرئيسية
class MyAppRiverpod extends StatelessWidget {
  const MyAppRiverpod({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'واجب الأسبوع 3 - Riverpod',
      home: const CounterScreen(),
    );
  }
}

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterState = ref.watch(counterProvider);
    final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('واجب الأسبوع 3 - Riverpod 2.x'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              counterState.isPaused ? 'العداد متوقف مؤقتاً (Paused)' : 'العداد يعمل',
              style: TextStyle(
                fontSize: 18,
                color: counterState.isPaused ? Colors.red : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${counterState.count}',
              style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: "riverpod_dec",
                  onPressed: counterNotifier.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: "riverpod_inc",
                  onPressed: counterNotifier.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: counterNotifier.togglePause,
                  icon: Icon(counterState.isPaused ? Icons.play_arrow : Icons.pause),
                  label: Text(counterState.isPaused ? 'استئناف' : 'إيقاف مؤقت'),
                ),
                const SizedBox(width: 15),
                ElevatedButton.icon(
                  onPressed: counterNotifier.reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة تعيين'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}