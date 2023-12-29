enum RoutePath {
  signin(path: "/signin"),
  register(path: "/register"),
  dashboard(path: "/dashboard"),
  splash(path: "/splash");

  const RoutePath({ required this.path });
  final String path;
}