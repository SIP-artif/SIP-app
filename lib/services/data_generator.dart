import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class FakeDataGenerator {
  final String uid;
  static final Map<String, Timer> _activeTimers = {};
  static final Map<String, int> _lastGlucose = {}; // Added to track last glucose for each user

  FakeDataGenerator({required this.uid});

  void startGenerating() {
    // Avoid duplicate timers for the same user
    if (_activeTimers.containsKey(uid)) return;

    final timer = Timer.periodic(Duration(minutes: 1), (_) {
      _generateFakeData();
    });

    _activeTimers[uid] = timer;
    _generateFakeData(); // Generate once immediately
  }

  void _generateFakeData() async {
    final firestore = FirebaseFirestore.instance;
    final userRef = firestore.collection('Users').doc(uid);
    final now = DateTime.now();

    // Retrieve last glucose or default to 120
    int lastGlucose = _lastGlucose[uid] ?? 120;

    // Apply a small change to glucose (-5 to +5 mg/dL)
    int glucoseChange = Random().nextInt(11) - 5;
    int newGlucose = (lastGlucose + glucoseChange).clamp(70, 180);

    // Store the new glucose value for the next round
    _lastGlucose[uid] = newGlucose;

    // Parameters for insulin dose calculation
    const int targetGlucose = 100; // Target glucose level (mg/dL)
    const int correctionFactor = 50; // 1 unit of insulin lowers glucose by 50 mg/dL

    // Calculate the suggested correction dose
    double correctionDose = 0;
    if (newGlucose > targetGlucose) {
      correctionDose = (newGlucose - targetGlucose) / correctionFactor;
      correctionDose = double.parse(correctionDose.toStringAsFixed(1)); // Round to 1 decimal place
    }

    // Predict glucose 10–30 minutes later
    int predictedChange = Random().nextInt(21) - 10; // Random change between -10 and +10
    int predictedGlucose = (newGlucose + predictedChange).clamp(60, 200);

    // Determine the event based on predicted glucose
    String event;
    if (predictedGlucose < 70) {
      event = 'Hypoglycemia';
    } else if (predictedGlucose > 180) {
      event = 'Hyperglycemia';
    } else {
      event = 'Normal';
    }

    // Add data to Firestore
    await firestore.collection('Daily_Data').add({
      'user_id': userRef,
      'current_time': now,
      'glucose_level': newGlucose,
      'additional_doses': correctionDose,
      'predicted_gl': predictedGlucose,
      'predicted_event': event,
    });

    print('Fake data for $uid | GL: $newGlucose | Suggested Dose: $correctionDose | Predicted: $predictedGlucose');
  }

  void stopGenerating() {
    _activeTimers[uid]?.cancel();
    _activeTimers.remove(uid);
    _lastGlucose.remove(uid); // Clean up last glucose when stopping
  }

  static void stopAll() {
    _activeTimers.forEach((_, timer) => timer.cancel());
    _activeTimers.clear();
    _lastGlucose.clear(); // Clear all stored glucose values
  }
}

