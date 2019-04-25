Future<String> getUser() =>
    Future.delayed(new Duration(seconds: 1), () => 'Jerry');

//String getUser() => 'Jerry';

greetUser () {
//  String user = getUser();
  print('Well hello');
}

main() async {
  var result = greetUser();
  print(result);
}
