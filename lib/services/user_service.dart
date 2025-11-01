import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:myapp/pages/sign-up-pages/SignUpData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Normal User
  Future<String?> addUser(SignUpData signUpData) async {
  try {
    // Create the user account with email and password
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
      email: signUpData.email,
      password: signUpData.password,
    );

    final user = credential.user;
    if (user == null) {
      return 'Failed to create user account.';
    }

    await saveUserIdToPrefs(user.uid);
    String uid = user.uid;

    // Store user data in Firestore
    await _firestore.collection('Users').doc(uid).set({
      'email': signUpData.email,
      'emergencyPhone': signUpData.emergencyPhone,
      'firstName': signUpData.firstName,
      'lastName': signUpData.lastName,
      'birthDate': signUpData.birthDate,
      'gender': signUpData.gender,
      'A1C': signUpData.a1c ?? 0,  // Default to 0 if null
      'averageGlucose': signUpData.averageGlucose ?? 0,  // Default to 0 if null
      'shortActingDose': signUpData.shortActingDose ?? 0,  // Default to 0 if null
      'longActingDose': signUpData.longActingDose ?? 0,  // Default to 0 if null
      'TIR': 0,  // Initial value for Time in Range (TIR)
      'PumpID': null,
      'relationship': null,
    });

    return null;
  } on FirebaseAuthException catch (e) {
    return e.message;
  } catch (e) {
    return 'An unexpected error occurred';
  }
}


  // Add Guardian
  Future<String?> addGuardian({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserIdToPrefs(credential.user!.uid);
      String uid = credential.user!.uid;

      await _firestore.collection('Guardians').doc(uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'members': [], // Updated field name
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Add Member (Link User to Guardian)
Future<void> addMember(Map<String, dynamic> userData) async {
  try {
    final guardianId = _auth.currentUser?.uid;
    if (guardianId == null) throw Exception("No logged-in guardian");

    // 1. Create new user document with individual fields
    DocumentReference userRef = await _firestore.collection('Users').add(userData);

    // 2. Add reference to Guardian's "members" array
    await _firestore.collection('Guardian').doc(guardianId).update({
      'members': FieldValue.arrayUnion([userRef])
    });
  } catch (e) {
    rethrow;
  }
}


Future<String> loginGuardian({required String email, required String password}) async {
  try {
    // Attempt to log in the guardian using email and password
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;  // Get the user ID after successful login
    await saveUserIdToPrefs(uid); // Save the user ID to SharedPreferences

    return uid;  // Return the user ID
  } catch (e) {
    throw Exception("Login failed: $e"); // If login fails, throw an error
  }
}


  // In user_service.dart
Future<String> loginUser({required String email, required String password}) async {
  try {
    // Attempt to log in the user using email and password
    UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;  // Get the user ID after successful login
    await saveUserIdToPrefs(uid); // Save the user ID to SharedPreferences

    return uid;  // Return the user ID
  } catch (e) {
    throw Exception("Login failed: $e"); // If login fails, throw an error
  }
}

Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> saveUserIdToPrefs(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
}

Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

Future<Map<String, dynamic>?> getGuardianData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('Guardian').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }
  
Future<Map<String, dynamic>> fetchUserGlucoseData(String userId) async {
  final userDocRef = FirebaseFirestore.instance.collection('Users').doc(userId);
  final querySnapshot = await FirebaseFirestore.instance
      .collection('Daily_Data')
      .where('user_id', isEqualTo: userDocRef)
      .orderBy('current_time', descending: true) // Order by time to get the latest data
      .limit(10) // Fetch the latest 10 documents
      .get();

  if (querySnapshot.docs.isEmpty) {
    return {
      'glucoseSpots': [],
      'predicted_gl': 'N/A',
      'predicted_event': 'None',
      'additional_doses': 0,
    };
  }

  List<FlSpot> glucoseData = [];

  for (var doc in querySnapshot.docs) {
    final time = (doc['current_time'] as Timestamp).toDate();
    final hour = time.hour.toDouble();
    final level = (doc['glucose_level'] as num).toDouble();

    glucoseData.add(FlSpot(hour, level));
  }

  final lastDoc = querySnapshot.docs.first;

  return {
    'glucoseSpots': glucoseData,
    'predicted_gl': lastDoc['predicted_gl'] ?? 'N/A',
    'predicted_event': lastDoc['predicted_event'] ?? 'None',
    'additional_doses': lastDoc['additional_doses'] ?? 0,
  };
}


Future<List<PredictedEvent>> fetchPredictedEvents(String userId) async {
  try {
    final userRef = FirebaseFirestore.instance.collection('Users').doc(userId);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Daily_Data')
        .where('user_id', isEqualTo: userRef)
        .orderBy('current_time', descending: true)
        .get();

    final events = querySnapshot.docs.map((doc) {
      final Timestamp currentTime = doc['current_time'];
      final DateTime predictedTime = currentTime.toDate().add(const Duration(minutes: 30));

      return PredictedEvent(
        predictedTime: predictedTime,
        predictedGlucose: (doc['predicted_gl'] ?? 0).toDouble(), // Changed to double
        eventType: doc['predicted_event'] ?? '',
      );
    }).where((event) =>
        event.predictedTime.isAfter(DateTime.now().subtract(const Duration(minutes: 2))))
      .toList();

    events.sort((a, b) => a.predictedTime.compareTo(b.predictedTime));

    return events;
  } catch (e) {
    print('Error fetching predicted events: $e');
    rethrow;
  }
}


static Future<void> saveAdditionalDose(double dose, String userId) async {
  try {
    final timestamp = Timestamp.now();

    await FirebaseFirestore.instance.collection('Daily_Data').add({
      'user_id': FirebaseFirestore.instance.collection('Users').doc(userId),
      'current_time': timestamp,
      'additional_doses': dose,
      'carbs_amount': 0,
      'glucose_level': 0,
      'high_event': 0,
      'injected_insulin_amount': 0,
      'low_event': 0,
      'predicted_event': null,
      'predicted_gl': 0,
    });

    print('Dose saved successfully for user: $userId');
  } catch (e) {
    print('Error saving dose: $e');
  }
}


static Future<void> saveNewInjectedDose(String userId, double injectedDose) async {
  try {
    print('Saving new injected dose for user $userId...');
    final timestamp = Timestamp.now();

    await FirebaseFirestore.instance.collection('Daily_Data').add({
      'user_id': FirebaseFirestore.instance.collection('Users').doc(userId),
      'current_time': timestamp,
      'additional_doses': 0,
      'carbs_amount': 0,
      'glucose_level': 0,
      'high_event': 0,
      'injected_insulin_amount': injectedDose,
      'low_event': 0,
      'predicted_event': null,
      'predicted_gl': 0,
    });

    print('New injected dose saved successfully for user: $userId at $timestamp');
  } catch (e) {
    print('Error saving new injected dose: $e');
  }
}

  Future<Map<String, int>> fetchCarbsLast10Days(String userId) async {
  DateTime today = DateTime.now();
  DateTime tenDaysAgo = today.subtract(Duration(days: 9)); // Include today

  // Query for documents in the range from tenDaysAgo to today
  QuerySnapshot snapshot = await _firestore
      .collection('Daily_Data')
      .where('user_id', isEqualTo: userId)
      .where('current_time', isGreaterThanOrEqualTo: Timestamp.fromDate(tenDaysAgo))
      .where('current_time', isLessThanOrEqualTo: Timestamp.fromDate(today))
      .get();

  Map<String, int> dailyCarbs = {};

  for (var doc in snapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;

    if (data['carbs_amount'] != null && data['current_time'] != null) {
      DateTime date = (data['current_time'] as Timestamp).toDate();
      String dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      int carbs = data['carbs_amount'];

      if (dailyCarbs.containsKey(dateString)) {
        dailyCarbs[dateString] = dailyCarbs[dateString]! + carbs;
      } else {
        dailyCarbs[dateString] = carbs;
      }
    }
  }

  return dailyCarbs;
}

  Future<void> addCarbEntry(String userId, int carbs) async {
  await _firestore.collection('Daily_Data').add({
    'user_id': userId,
    'carbs_amount': carbs,
    'current_time': Timestamp.now(),
    'additional_doses': 0,
    'glucose_level': 0,
    'high_event': 0,
    'injected_insulin_amount': 0, 
    'low_event': 0,
    'predicted_event': null,
    'predicted_gl': 0,
  });
}

static Future<List<Map<String, dynamic>>> fetchFamilyMembers(String guardianId) async {
  final doc = await FirebaseFirestore.instance.collection('Guardian').doc(guardianId).get();

  if (!doc.exists) return [];

  List<dynamic> memberRefs = doc.data()?['members'] ?? [];

  List<Map<String, dynamic>> members = [];

  for (var ref in memberRefs) {
    if (ref is DocumentReference) {
      final snap = await ref.get();
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        members.add({
          'id': snap.id,
          'name': snap['firstName'],
        });
      }
    }
  }

  return members;
}
static Future<List<Map<String, dynamic>>> fetchFamilyMembersWithRelationship(String guardianId) async {
  final doc = await FirebaseFirestore.instance.collection('Guardian').doc(guardianId).get();

  if (!doc.exists) return [];

  List<dynamic> memberRefs = doc.data()?['members'] ?? [];

  List<Map<String, dynamic>> members = [];

  for (var ref in memberRefs) {
    if (ref is DocumentReference) {
      final snap = await ref.get();
      if (snap.exists) {
        final data = snap.data() as Map<String, dynamic>;
        members.add({
          'name': '${data['firstName']} ${data['lastName']}',
          'relationship': data['relationship'] ?? 'N/A',
        });
      }
    }
  }

  return members;
}
}

class PredictedEvent {
  final DateTime predictedTime;
  final double predictedGlucose; // Ensure this is a double
  final String eventType;

  PredictedEvent({
    required this.predictedTime,
    required this.predictedGlucose,
    required this.eventType,
  });

  factory PredictedEvent.fromFirestore(DocumentSnapshot doc) {
    return PredictedEvent(
      predictedTime: (doc['predicted_time'] as Timestamp).toDate(),
      predictedGlucose: (doc['predicted_glucose'] as num).toDouble(), // Convert to double
      eventType: doc['event_type'] ?? '',
    );
  }
}
