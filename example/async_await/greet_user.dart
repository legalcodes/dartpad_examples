void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////
///////////////////////////////////////
///////////////////////////////////////
///////////////////////////////////////

String addHello(user) => 'Hello $user!';

Future<String> greetUser() async {
  var username = await getUsername();
  addHello(username);
}

///////////////////////////////////////
///////////////////////////////////////
///////////////////////////////////////
///////////////////////////////////////


const noError='NO_ERROR';

Future<String> getUsername() =>
    Future.delayed(Duration(seconds: 1), () => 'Jean');

main() async {
  try {
    List<String> messages = [];

    // ignore: cascade_invocations
    messages
      ..add(await asyncStringEquals(
        expected: 'Hello Jean!',
        actual: await greetUser(),
      ))
      ..add(await asyncStringEquals(
        expected: 'Hello Jerry!',
        actual: await addHello('Jerry'),
      ))
      ..forEach((m) => print(m))
      ..removeWhere((m) => m == noError);

    // ignore: omit_local_variable_types
    Map<String, String> readable = {
      'HelloJean' : 'Looks like you forgot the space between \'Hello\' and \'Jean\'!',
      'Hello Instance of \'Future<String>\'!': 'Looks like you forgot to use the \'await\' keyword!',
      'Hello Jerry': 'Your user greeting is missing an exclamation mark',
      'null': 'Woops! Did you forget to return a value in one of your functions?',
    };

    passIfNoMessages(messages, readable);

  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: $e']);
  }
}

void passIfNoMessages(List<String> messages, Map<String, String> readable){
  if (messages.isEmpty) {
    _result(true);
  } else {

    // ignore: omit_local_variable_types
    List<String> userMessages = messages
        .where((message) => readable.containsKey(message))
        .map((message) => readable[message])
        .toList();

    _result(false, userMessages);
  }
}


Future<String> asyncStringEquals({String expected, String actual}) async {
  try {
    if (expected == actual) {
      return noError;
    } else {
      return actual.toString();
    }
  } catch (e) {
    return e.toString();
  }
}
