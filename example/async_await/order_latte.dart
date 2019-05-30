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
  return 'Change due: $change';
}

///////////////////////////////////////////////
//////////////TEST CODE BELOW //////////////////
///////////////////////////////////////////////

const order = 'almond milk';
const change = '3.02';
const noError = 'NO_ERROR';
const typoMessage = 'Test failed! Check for typos in your return value';
const oneSecond = Duration(seconds: 1);

Map<String, String> readable = {
  typoMessage: typoMessage,
  'Change due: Instance of \'Future<String>\'': 'Test failed! reportChange failed. Did you use the await keyword?',
  'Change due: Instance of \'_Future<String>\'': 'Test failed! reportChange failed. Did you use the await keyword?',
  'Thanks! Your order is: Instance of \'Future<String>\'': 'Test failed! reportOrder failed. Did you use the await keyword?',
  'Thanks! Your order is: Instance of \'_Future<String>\'': 'Test failed! reportOrder failed. Did you use the await keyword?',
};
List<String> messages = [];

Future<String> getUserOrder() => Future.delayed(oneSecond, () => order);
Future<String> getDollarAmount() => Future.delayed(oneSecond, () => change);

main() async {
  try {
    messages
      ..add(await asyncStringEquals(
        expected: 'Thanks! Your order is: almond milk',
        actual: await reportOrder(),
      ))
      ..add(await asyncStringEquals(
        expected: 'Change due: 3.02',
        actual: await reportChange(),
      ))
      ..removeWhere((m) => m == noError);

    // TODO: move _result() call into main function
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
        .map((message) => message.contains(order) ? typoMessage : message)
        .map((message) => message.contains(change) ? typoMessage : message)
        .where((message) => readable.containsKey(message))
        .map((message) => readable[message])
        .toList();
    _result(false, userMessages);
  }
}

// TODO: call a message mapping function within the assertion
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
