void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////////////
//////DO NOT COPY ABOVE THIS COMMENT///////////
///////////////////////////////////////////////
//const userError =
class UserError implements Exception {
  String errMsg() => 'New username is invalid';
}


Future changeUsername () async {
  try {
    return await getNewUsername();
  } catch (err) {
    return 'Error: $err';
  }
}

Future getNewUsername() {
  var str = Future.delayed(Duration(seconds: 2), () => throw UserError());
  return str;
}

///////////////////////////////////////////////
//////////////TEST CODE BELOW //////////////////
///////////////////////////////////////////////
const noError = 'NO_ERROR';
const typoMessage = 'Test failed! Check for typos in your return value';
List<String> messages = [];

Map<String, String> readable = {
  typoMessage: typoMessage,
};

main() async {
  try {
    messages
      ..add(await asyncEquals(
        expected: 'Error: New username is invalid',
        actual: await changeUsername(),
      ))
      ..removeWhere((m) => m == noError);

    // TODO: move _result() call into main
    passIfNoMessages(messages, readable);
  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: $e']);
  }
}

void passIfNoMessages(List<String> messages, Map<String, String> readable){
  if (messages.isEmpty) {
    _result(true);
  } else {
    // TODO: move mapping-error-messages logic into separate function
    // ignore: omit_local_variable_types
    List<String> userMessages = messages
        .where((message) => readable.containsKey(message))
        .map((message) => readable[message])
        .toList();
    _result(false, userMessages);
  }
}

// TODO: For readability call a message mapping helper with each assertion
Future<String> asyncEquals({expected, actual}) async {
  try {
    if (expected == actual) {
      return noError;
    } else {
      return actual;
    }
  } catch(e) {
    return e.toString();
  }
}
