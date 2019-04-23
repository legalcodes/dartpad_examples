void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////////////
//////DO NOT COPY ABOVE THIS COMMENT///////////
///////////////////////////////////////////////

Future<String> reportOrder() async {
  var order = await getUserOrder();
  return 'Thanks! Your order is: $order';
}

Future<String> reportChange() async {
  var change = await getDollarAmount();
  return 'My $change';
}

///////////////////////////////////////////////
//////////////TEST CODE BELOW //////////////////
///////////////////////////////////////////////

const order = 'almond milk';
const change = '3.02';
const noError = 'NO_ERROR';
const oneSecond = Duration(seconds: 1);

Future<String> getUserOrder() =>
    Future.delayed(oneSecond, () => order);

Future<String> getDollarAmount() =>
    Future.delayed(oneSecond, () => change);

main() async {
  try {
    List<String> messages = [];

    // ignore: cascade_invocations
    messages
      ..add(await asyncStringEquals(
        expected: 'Thanks! Your order is: almond milk',
        actual: await reportOrder(),
      ))
      ..add(await asyncStringEquals(
        expected: 'My 3.02',
        actual: await reportChange(),
      ))
      ..removeWhere((m) => m == noError);

    // ignore: omit_local_variable_types
     Map<String, String> readable = {
      'Change due: Instance of \'Future<String>\'': 'reportChange failed. Did you use the await keyword?',
      'Change due: Instance of \'_Future<String>\'': 'reportChange failed. Did you use the await keyword?',
      'Thanks! Your order is: Instance of \'Future<String>\'': 'reportOrder failed. Did you use the await keyword?',
      'Thanks! Your order is: Instance of \'_Future<String>\'': 'reportOrder failed. Did you use the await keyword?',
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
//        .where((message) => readable.containsKey(message))
//        .map((message) => readable[message])
        .toList();
    _result(false, userMessages);
  }
}

Future<String> asyncStringEquals({String expected, String actual}) async {
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
