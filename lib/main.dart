import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyAppGetX());
}

// 1. Controller لإدارة الحالة ودورة الحياة
class CounterController extends SuperController {
  var count = 0.obs;
  var isPaused = false.obs;

  void increment() {
    if (!isPaused.value) {
      count++;
    }
  }

  void decrement() {
    if (!isPaused.value && count.value > 0) {
      count--;
    }
  }

  void togglePause() {
    isPaused.value = !isPaused.value;
  }

  void reset() {
    count.value = 0;
    isPaused.value = false;
  }

  @override
  void onDetached() {
    print("GetX Lifecycle: onDetached");
  }

  @override
  void onInactive() {
    print("GetX Lifecycle: onInactive");
  }

  @override
  void onPaused() {
    print("GetX Lifecycle: onPaused");
  }

  @override
  void onResumed() {
    print("GetX Lifecycle: onResumed");
  }

  @override
  void onHidden() {
    print("GetX Lifecycle: onHidden");
  }
}

// 2. الواجهة الرئيسية
class MyAppGetX extends StatelessWidget {
  const MyAppGetX({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetX Counter Assignment',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('واجب الأسبوع 3 - GetX'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    controller.isPaused.value ? 'العداد متوقف مؤقتاً (Paused)' : 'العداد يعمل',
                    style: TextStyle(
                      fontSize: 18,
                      color: controller.isPaused.value ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              const SizedBox(height: 20),
              Obx(() => Text(
                    '${controller.count.value}',
                    style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: "dec",
                    onPressed: controller.decrement,
                    child: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 20),
                  FloatingActionButton(
                    heroTag: "inc",
                    onPressed: controller.increment,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.togglePause,
                    icon: Obx(() => Icon(controller.isPaused.value ? Icons.play_arrow : Icons.pause)),
                    label: Obx(() => Text(controller.isPaused.value ? 'استئناف' : 'إيقاف مؤقت')),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton.icon(
                    onPressed: controller.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة تعيين'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}