import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appwrite/appwrite.dart';

Client client = Client().setEndpoint(dotenv.env['END_POINT']??"").setProject(dotenv.env['PROJECT_ID']??"");
