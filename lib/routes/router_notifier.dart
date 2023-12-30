import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:s_hub/models/user.dart';
import 'package:s_hub/routes/constants.dart';

class RouterNotifier extends ChangeNotifier {
  final Stream<SUser> _authChanges;
  SUser user = SUser(initializing: true);

  RouterNotifier(this._authChanges) {
    _authChanges.listen((event) {
      user = event;
      notifyListeners();
    });
  }


  String? redirect (BuildContext context, GoRouterState state) {
    if (state.matchedLocation == RoutePath.dashboard.path && user.uid == null) {
      return RoutePath.signin.path;
    }

    return state.matchedLocation;
  } 
}