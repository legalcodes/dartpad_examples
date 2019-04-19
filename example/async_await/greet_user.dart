Future<String> greetUser() async {
  var username = await getUsername(); // Can take a while
  return 'Hello $username';
}

Future<String> getUsername() =>
    Future.delayed(Duration(seconds: 2), () => 'Jean');

main() async {
  await asyncStringEquals(
      '==Should get User Name==',
      'Hello Jean',
      await greetUser()
  );
}

Future<void> asyncStringEquals(msg, expected, actual) async {
  print(msg);
  if (expected == actual) {
    print('PASS: $actual');
    return true;
  } else {
    print("FAILED: ");
    print("Expected: $expected");
    print("Actual: $actual");
    return false;
  }
}
