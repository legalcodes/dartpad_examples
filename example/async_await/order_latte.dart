void _result(bool success, [List<String> messages]) {
  final joinedMessages = messages?.map((m) => m.toString())?.join(',') ?? '';
  print('success: $success, "messages": $joinedMessages');
}

///////////////////////////////////////////////
//////DO NOT COPY ABOVE THIS COMMENT///////////
///////////////////////////////////////////////

Future<String> reportOrder() async {
  var order = getUserOrder();
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
const NO_ERROR = 'NO_ERROR';
const oneSecond = Duration(seconds: 1);

Future<String> getUserOrder() =>
    Future.delayed(oneSecond, () => order);

Future<String> getDollarAmount() =>
    Future.delayed(oneSecond, () => change);

main() async {
  try {
    List<String> messages = [];

    messages
      ..add(await asyncStringEquals(
        expected: 'Thanks! Your order is: almond milk',
        actual: await reportOrder(),
      ))
      ..add(await asyncStringEquals(
        expected: 'Change due: 3.02',
        actual: await reportChange(),
      ))
      ..removeWhere((m) => m == NO_ERROR);

     Map<String, String> readable = {
      'Change due: Instance of \'Future<String>\'': 'reportChange failed. Did you use the await keyword?',
      'Change due: Instance of \'_Future<String>\'': 'reportChange failed. Did you use the await keyword?',
      'Thanks! Your order is: Instance of \'Future<String>\'': 'reportOrder failed. Did you use the await keyword?',
      'Thanks! Your order is: Instance of \'_Future<String>\'': 'reportOrder failed. Did you use the await keyword?',
    };

    passIfNoMessages(messages, readable);

  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: ${e}']);
  }
}

void passIfNoMessages(List<String> messages, Map<String, String> readable){
  if (messages.isEmpty) {
    _result(true);
  } else {
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
      return NO_ERROR;
    } else {
      return actual;
    }
  } catch(e) {
    return e.toString();
  }
}
