import 'package:chat_app/features/auth/domain/entities/user_entity.dart';

abstract class FirebaseRemoteDataSource {
  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<String> getCurrentUId();
  Future<void> getCreateCurrentUser(UserEntity user);
  // Future<void> addNewNote(NoteEntity note);
  // Future<void> updateNote(NoteEntity note);
  // Future<void> deleteNote(NoteEntity note);
  // Stream<List<NoteEntity>> getNotes(String uid);
}
