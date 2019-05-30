void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////////////
/////////////// SOLUTION //////////////////////
///////////////////////////////////////////////

Future<String> reportUserRole() async {
  var username = await getRole();
  return 'User role: $username';
}

Future<String> reportLogins() async {
  var logins = await getLoginAmount();
  return 'Total number of logins: $logins';
}

///////////////////////////////////////////////
//////////////TEST CODE BELOW //////////////////
///////////////////////////////////////////////

const role = 'administrator';
const logins = 42;
const noError = 'NO_ERROR';
const typoMessage = 'Test failed! Check for typos in your return value';
const oneSecond = Duration(seconds: 1);
List<String> messages = [];

Map<String, String> readableErrors = {
  typoMessage: typoMessage,
  'User role: Instance of \'Future<String>\'': 'Part 1 Test failed! reportUserRole failed. Did you use the await keyword?',
  'User role: Instance of \'_Future<String>\'': 'Part 1 Test failed! reportUserRole failed. Did you use the await keyword?',
  'Total number of logins: Instance of \'Future<int>\'': 'Part 2 Test failed! reportLogins failed. Did you use the await keyword?',
  'Total number of logins: Instance of \'_Future<int>\'': 'Part 2 Test failed! reportLogins failed. Did you use the await keyword?',
};

Future<String> getRole() => Future.delayed(oneSecond, () => role);
Future<int> getLoginAmount() => Future.delayed(oneSecond, () => logins);

main() async {
  try {
    messages
      ..add(await asyncEquals(
        expected: 'User role: administrator',
        actual: await reportUserRole(),
      ))
      ..add(await asyncEquals(
        expected: 'Total number of logins: 42',
        actual: await reportLogins(),
      ))
      ..removeWhere((m) => m == noError);

    // TODO: move _result() call into main
    passIfNoMessages(messages, readableErrors);
  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: $e']);
  }
}

void passIfNoMessages(List<String> messages, Map<String, String> readableErrors){
  if (messages.isEmpty) {
    _result(true);
  } else {
    // TODO: move mapping-error-messages logic into separate function
    // check for WHICH test failed
    print(messages);
    // ignore: omit_local_variable_types
    List<String> userMessages = messages
        .map((message) => message.contains(role) ? typoMessage : message)
        .map((message) => message.contains(logins.toString()) ? typoMessage : message)
        .where((message) => readableErrors.containsKey(message))
        .map((message) => readableErrors[message])
        .toList();
    _result(false, userMessages);
  }
}

///////////////////////////////////////
//////////// Assertions ///////////////
///////////////////////////////////////

// TODO: call a message mapping function within the assertions
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
