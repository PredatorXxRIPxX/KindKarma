import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppwriteService {
  static final Client _client = Client()
    .setEndpoint(dotenv.env['SET_ENDPOINT']!)
    .setProject(dotenv.env['PROJECT_ID']!);

  static Account get account => Account(_client);
  static Databases get databases => Databases(_client);
  static Storage get storage => Storage(_client);
  static Teams get teams => Teams(_client);
  static Avatars get avatars => Avatars(_client);
  static Messaging get messages => Messaging(_client);
  static Realtime get realtime => Realtime(_client);

  static String get endPointRealtime => dotenv.env['END_POINT_REALTIME']!;
  static String get endPoint => dotenv.env['END_POINT']!;
  static String get projectId => dotenv.env['PROJECT_ID']!;
  static String get setEndpoint => dotenv.env['SET_ENDPOINT']!;
  static String get databaseId => dotenv.env['DATABASE_ID']!;
  static String get userCollectionId => dotenv.env['USER_COLLECTION_ID']!;
  static String get postCollectionId => dotenv.env['POST_COLLECTION_ID']!;
  static String get chatCollectionId => dotenv.env['CHAT_COLLECTION_ID']!;
  static String get storageId => dotenv.env['STORAGE_ID']!;
}