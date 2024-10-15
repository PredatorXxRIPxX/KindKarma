import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appwrite/appwrite.dart';

Client client = Client().setEndpoint(dotenv.env['END_POINT']??"").setProject(dotenv.env['PROJECT_ID']??"");
Account account = Account(client);
Databases database = Databases(client);
Storage storage = Storage(client);
Teams teams = Teams(client);
Avatars avatars = Avatars(client);



