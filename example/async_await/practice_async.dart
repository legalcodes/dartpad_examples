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
const passed = 'PASSED';
const typoMessage = 'Test failed! Check for typos in your return value';
const oneSecond = Duration(seconds: 1);
List<String> messages = [];
Future<String> getRole() => Future.delayed(oneSecond, () => role);
Future<int> getLoginAmount() => Future.delayed(oneSecond, () => logins);

main() async {
  try {
    messages
      ..add(makeReadable(

        testLabel: 'Part 1',
        testResult: await asyncEquals(
          expected: 'User role: administrator',
          actual: await reportUserRole(),
          typoKeyword: role
        ),
        readableErrors: {
          typoMessage: typoMessage,
          'User role: Instance of \'Future<String>\'': 'Test failed! reportUserRole failed. Did you use the await keyword?',
          'User role: Instance of \'_Future<String>\'': 'Test failed! reportUserRole failed. Did you use the await keyword?',
        }))

      ..add(makeReadable(

        testLabel: 'Part 2',
        testResult: await asyncEquals(
          expected: 'Total number of logins: 42',
          actual: await reportLogins(),
          typoKeyword: logins.toString()
        ),
        readableErrors: {
          typoMessage: typoMessage,
          'Total number of logins: Instance of \'Future<int>\'': 'Test failed! reportLogins failed. Did you use the await keyword?',
          'Total number of logins: Instance of \'_Future<int>\'': 'Test failed! reportLogins failed. Did you use the await keyword?',
        }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      _result(true);
    } else {
      _result(false, messages);
    }
  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: $e']);
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
