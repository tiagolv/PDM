import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ubi/firebase_auth_implementation/models/review_model.dart';
import '../firebase_auth_implementation/models/user_model.dart';
import '../common/Utils.dart';

class UserFirestore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> saveUserData(UserModel user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var id = user.uid;
    String currTime = Utils.currentTime();
    Utils.MSG_Debug(currTime);

    users
        .doc(user.uid)
        .set({
          'uid': user.uid,
          'email': user.email,
          'username': user.username,
          'fullName': user.fullName,
          'registerDate': user.registerDate,
          'lastChangedDate': user.lastChangedDate,
          'location': user.location,
          'image': user.image,
          'online': user.online,
          'lastLogInDate': user.lastLogInDate,
          'lastSignOutDate': user.lastSignOutDate,
        })
        .then((value) => Utils.MSG_Debug("User $id Added"))
        .catchError((error) => Utils.MSG_Debug("Failed to add user: $error"));
  }

  Future<UserModel?> getUserData(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        return UserModel(
          uid: userDoc['uid'],
          email: userDoc['email'],
          username: userDoc['username'],
          fullName: userDoc['fullName'],
          registerDate: userDoc['registerDate'],
          lastChangedDate: userDoc['lastChangedDate'],
          location: userDoc['location'],
          image: userDoc['image'],
          online: userDoc['online'],
          lastLogInDate: userDoc['lastLogInDate'],
          lastSignOutDate: userDoc['lastSignOutDate'],
        );
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
        return null;
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user data: $error");
      return null;
    }
  }

  /// New function that returns a Json scheme of the User
  Future<String?> getUserDataJson(String uid) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        UserModel user = UserModel(
          uid: userDoc['uid'],
          email: userDoc['email'],
          username: userDoc['username'],
          fullName: userDoc['fullName'],
          registerDate: userDoc['registerDate'],
          lastChangedDate: userDoc['lastChangedDate'],
          location: userDoc['location'],
          image: userDoc['image'],
          online: userDoc['online'],
          lastLogInDate: userDoc['lastLogInDate'],
          lastSignOutDate: userDoc['lastSignOutDate'],
        );

        // Convert UserModel to JSON string
        String userJson = jsonEncode(user.toJson());

        return userJson;
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
        return null;
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user data: $error");
      return null;
    }
  }

  /// to get a certain attribute
  Future<String> getUserAttribute(String uid, String attribute) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        String attributeFinal = userDoc[attribute];
        return attributeFinal;
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
        return "??";
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user data: $error");
      return "??";
    }
  }

  /// Update a user attribute, given the attribute (useful for the online/offline mode)
  Future<void> updateUserAttribute(String uid, String attribute, String newValue) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    try {
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        await users.doc(uid).update({attribute: newValue});
        Utils.MSG_Debug("User attribute '$attribute' updated successfully for UID $uid");
      } else {
        Utils.MSG_Debug("User with UID $uid not found");
      }
    } catch (error) {
      Utils.MSG_Debug("Error updating user attribute: $error");
    }
  }


  Future<void> updateUserData(UserModel user) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String currTime = Utils.currentTimeUser();

      users
          .doc(user.uid)
          .update({
            'uid': user.uid,
            'email': user.email,
            'username': user.username,
            'fullName': user.fullName,
            'registerDate': user.registerDate,
            'lastChangedDate': currTime,
            'location': user.location,
            'image': user.image,
            'online': user.online,
            'lastLogInDate': user.lastLogInDate,
            'lastSignOutDate': user.lastSignOutDate,
          })
          .then((value) => Utils.MSG_Debug("User $user.uid Updated"))
          .catchError(
              (error) => Utils.MSG_Debug("Failed to update user: $error"));
    } catch (error) {
      Utils.MSG_Debug("Error updating user data: $error");
    }
  }

  Future<void> updateUserOnline(UserModel user, bool type) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      String currTime = Utils.currentTimeUser();

      if (type) {
        users
            .doc(user.uid)
            .update({
              'uid': user.uid,
              'email': user.email,
              'username': user.username,
              'fullName': user.fullName,
              'registerDate': user.registerDate,
              'lastChangedDate': currTime,
              'location': user.location,
              'image': user.image,
              'online': "1",
              'lastLogInDate': user.lastLogInDate,
              'lastSignOutDate': user.lastSignOutDate,
            })
            .then((value) => Utils.MSG_Debug("User ${user.uid} Updated"))
            .catchError(
                (error) => Utils.MSG_Debug("Failed to update user: $error"));
      } else {
        users
            .doc(user.uid)
            .update({
              'uid': user.uid,
              'email': user.email,
              'username': user.username,
              'fullName': user.fullName,
              'registerDate': user.registerDate,
              'lastChangedDate': currTime,
              'location': user.location,
              'image': user.image,
              'online': "0",
              'lastLogInDate': user.lastLogInDate,
              'lastSignOutDate': user.lastSignOutDate,
            })
            .then((value) => Utils.MSG_Debug("User ${user.uid} Updated"))
            .catchError(
                (error) => Utils.MSG_Debug("Failed to update user: $error"));
      }
    } catch (error) {
      Utils.MSG_Debug("Error updating user data: $error");
    }
  }

  Future<bool> isUserOnline(String uid) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('users');
      DocumentSnapshot userDoc = await users.doc(uid).get();

      if (userDoc.exists) {
        return userDoc['online'] == "1";
      } else {
        Utils.MSG_Debug("User with UID ${uid} not found");
        return false; // Assuming offline if user not found
      }
    } catch (error) {
      Utils.MSG_Debug("Error checking user online status: $error");
      return false; // Assume offline in case of an error
    }
  }

  Future<List<ReviewModel>> getUserReviews(String uid) async {
    List<ReviewModel> reviews = [];
    try {

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('reviews')
          .get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
        var data = doc.data();
        ReviewModel review = ReviewModel(
          uid: data['uid'],
          rid: data['rid'],
          date: data['date'],
          rating: data['rating'],
          comment: data['comment']
        );
        reviews.add(review);
      }
    } catch (error) {
      Utils.MSG_Debug("Error getting user reviews: $error");
      return [];
    }

    return reviews;
  }
  
  Future<void> saveReview(ReviewModel data) async{
    try{
      await _firestore.collection('users').doc(data.uid).collection('reviews').doc(data.rid)
          .set({
            'uid': data.uid,
            'rid': data.rid,
            'rating': data.rating,
            'date': data.date,
            'comment': data.comment
          });
    }catch (error) {
      Utils.MSG_Debug("Error saving user review: $error");
    }
  }

  Future<void> deleteUserData(String uid) async {
    try {
      // Obter todos os posts do usuário
      QuerySnapshot postsSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('posts')
          .get();

      // Excluir os posts e seus comentários e notificações associadas
      for (QueryDocumentSnapshot postDoc in postsSnapshot.docs) {
        String pid = postDoc.id;

        // Excluir os comentários associados ao post
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .doc(pid)
            .collection('comments')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });

        // Excluir as notificações relacionadas ao post
        await _firestore
            .collection('notifications')
            .doc(uid)
            .collection('user_notifications')
            .where('pid', isEqualTo: pid)
            .get()
            .then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs) {
            ds.reference.delete();
          }
        });

        // Excluir o documento de likes associado ao post
        await _firestore.collection('likes').doc('$pid' + '_' + '$uid').delete();

        // Excluir o documento do post
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('posts')
            .doc(pid)
            .delete();
      }

      // Excluindo as revisões do usuário
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('reviews')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      // Excluir o documento do usuário
      await _firestore.collection('users').doc(uid).delete();
      Utils.MSG_Debug("User data for UID $uid deleted successfully");
    } catch (error) {
      Utils.MSG_Debug("Error deleting user data: $error");
    }
  }
}
