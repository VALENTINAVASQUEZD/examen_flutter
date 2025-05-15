import 'package:appwrite/appwrite.dart';
import 'package:application_medicines/appwrite_constants.dart';

class AppwriteConfig {
  static String get endpoint => AppwriteConstants.endpoint;
  static String get projectId => AppwriteConstants.projectId;

  static Client getClient() {
    Client client = Client();
    client
        .setEndpoint(endpoint)
        .setProject(projectId)
        .setSelfSigned(status: true);
    return client;
  }
}