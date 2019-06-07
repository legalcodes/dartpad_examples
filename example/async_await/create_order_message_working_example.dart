
void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////
///////////////////////////////////////


Future<String> createOrderMessage () async {
  var order = await getUserOrder();
  return 'Your order is: $order';
}

Future<String> getUserOrder() {
  // Imagine that this function is more complex and slow
  return Future.delayed(Duration(seconds: 4), () => 'Large Latte');
}

////////////////////////////////////////
////////////////////////////////////////

const order = 'latte';
const passed = 'PASSED';
const typoMessage = 'Test failed! Check for typos in your return value';
const oneSecond = Duration(seconds: 1);
List<String> messages = [];

main() async {
  try {
    messages
      ..add(makeReadable(

          testLabel: '',
          testResult: await asyncEquals(
              expected: 'Your order is: latte after four seconds',
              actual: await createOrderMessage(),
              typoKeyword: order
          ),
          readableErrors: {
            typoMessage: typoMessage,
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

