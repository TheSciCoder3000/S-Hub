import 'package:flutter/foundation.dart';
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
    if (user.uid == null) {
      if (state.matchedLocation == RoutePath.dashboard.path) return RoutePath.signin.path;
    } else {
      return RoutePath.dashboard.path;
    }
    return state.matchedLocation;
  } 
}