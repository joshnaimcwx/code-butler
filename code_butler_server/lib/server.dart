import 'package:serverpod/serverpod.dart';
import 'package:code_butler_server/src/endpoints/example_endpoint.dart';

// This is the starting point of your server. All server endpoints are referenced from this file.

void main(List<String> args) {
  // Initialize Serverpod and connect to the database.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  pod.start();
}

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    // Register all endpoints here
    // ExampleEndpoint.register(server);
  }
}

