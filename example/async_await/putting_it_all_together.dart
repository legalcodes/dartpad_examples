void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////////////
/////////////// SOLUTION //////////////////////
///////////////////////////////////////////////

String addHello(user) => 'Hello $user!';

Future<String> greetUser() async {
  var username = await getUsername();
  return addHello(username);
}

Future<String>sayGoodbye() async {
  try {
    var result = await logoutUser();
    return '$result Thanks, see you next time';
  } catch (e) {
    return 'Failed to logout user: $e';
  }
}

///////////////////////////////////////////////
//////////////TEST CODE //////////////////
///////////////////////////////////////////////

List<String> messages = [];
bool logoutSucceeds = false;
const passed = 'PASSED';
const noCatch = 'NO_CATCH';
const typoMessage = 'Test failed! Check for typos in your return value';
const oneSecond = Duration(seconds: 1);

Future<String> getUsername() => Future.delayed(oneSecond, () => 'Jean');
String failOnce () {
  if (logoutSucceeds) {
    return 'Success!';
  } else {
    logoutSucceeds = true;
    throw Exception('Logout failed');
  }
}

logoutUser() => Future.delayed(oneSecond, failOnce);

main() async {
  try {
    // ignore: cascade_invocations
    messages
      ..add(makeReadable(

        testLabel: 'Part 1',
        testResult: await asyncEquals(
          expected: 'Hello Jean!',
          actual: await greetUser(),
          typoKeyword: 'Jean'
        ),
        readableErrors: {
          typoMessage: typoMessage,
          'HelloJean' : 'Looks like you forgot the space between \'Hello\' and \'Jean\'!',
          'Hello Instance of \'Future<String>\'!': 'Looks like you forgot to use the \'await\' keyword!',
          'Hello Instance of \'_Future<String>\'!': 'Looks like you forgot to use the \'await\' keyword!',
        }))
    ..add(makeReadable(

      testLabel: 'Part 2',
      testResult: await asyncEquals(
        expected: 'Hello Jerry!',
        actual: addHello('Jerry'),
        typoKeyword: 'Jerry'
      ),
      readableErrors: {
        typoMessage: typoMessage,
        'Hello Instance of \'Future<String>\'!': 'Looks like you forgot to use the \'await\' keyword!',
        'Hello Instance of \'_Future<String>\'!': 'Looks like you forgot to use the \'await\' keyword!',
      }))
      ..add(makeReadable(
        testLabel: 'Part 3',
        testResult: await asyncDidCatchException(sayGoodbye),
        readableErrors: {
          typoMessage: typoMessage,
          noCatch: 'Did you remember to call logoutUser within a try/catch block?',
          'Instance of \'Future<String>\' Thanks, see you next time':'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
        }
      ))
      ..add(makeReadable(
        testLabel: 'Part 3',
        testResult: await asyncEquals(
          expected: 'Success! Thanks, see you next time',
          actual: await sayGoodbye(),
          typoKeyword: 'Success'
        ),
        readableErrors: {
          typoMessage: typoMessage,
          noCatch: 'Did you remember to call logoutUser within a try/catch block?',
          'Instance of \'Future<String>\' Thanks, see you next time':'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
          }
      ))
    ..removeWhere((m) => m.contains(passed))
    ..toList();

    if (messages.isEmpty) {
      _result(true);
    } else {
      _result(false, messages);
    }
  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: ${e}']);
  }
}

////////////////////////////////////////
///////////// Test Helpers /////////////
////////////////////////////////////////
String makeReadable({ String testResult, Map readableErrors, String testLabel }) {
  if (readableErrors.containsKey(testResult)) {
    var readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
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
    print(messages);

    _result(false, userMessages);
  }
}
///////////////////////////////////////
//////////// Assertions ///////////////
///////////////////////////////////////

Future<String> asyncEquals({expected, actual, String typoKeyword}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return passed;
    } else if (strActual.contains(typoKeyword)) {
      return typoMessage;
    } else {
      return strActual;
    }
  } catch(e) {
    return e;
  }
}

Future<String> asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on Exception catch(e) {
    caught = false;
  }

  if (caught == true) {
    return passed;
  } else {
    return noCatch;
  }
}
