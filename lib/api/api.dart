import 'package:appwrite/appwrite.dart';

Client client = Client().setEndpoint(setEndpoint).setProject(projectid);
Account account = Account(client);
Databases database = Databases(client);
Storage storage = Storage(client);
Teams teams = Teams(client);
Avatars avatars = Avatars(client);

String projectid = '670d353b0011112ac560';
String setEndpoint = 'https://cloud.appwrite.io/v1';
String databaseid = '670d36f0001969ad8dd1';
String userCollectionid = '670fd5c6000e403109ae';
String postCollectionid = '670fd693000982ee4e07';
String notificationCollection = '672976a600120afda86a';
String storageid = '670fd8670020bedf3fbc';


