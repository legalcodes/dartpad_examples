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

const order = 'almond milk';
const change = '3.02';
const oneSecond = Duration(seconds: 1);
const twoSeconds = Duration(seconds: 1);
const threeSeconds = Duration(seconds: 1);

Future<String> getUserOrder() =>
    Future.delayed(oneSecond, () => order);

Future<String> getDollarAmount() =>
    Future.delayed(twoSeconds, () => change);

main() async {
  try {
    List<String> messages = [];
    var reportOrderResult = await asyncStringEquals(
        expected: 'Thanks! Your order is: almond milk',
        actual: await reportOrder(),
        messages: messages
    );

    var getChangeResult = await asyncStringEquals(
        expected: 'Change due: 3.02',
        actual: await reportChange(),
        messages: messages
    );

//    print(getChangeResult);
//    print(reportOrderResult);

    var passed =
      (reportOrderResult[0] == true) &&
      (getChangeResult[0] == true);

    if (passed) {
      _result(true);
    } else {
      // convert potentially confusing errors to more user-friendly messages
      var readable = {
        'Change due: Instance of \'Future<String>\'': 'Looks like you forgot to use the await keyword!',
        'Change due: Instance of \'_Future<String>\'': 'Looks like you forgot to use the await keyword!'
      };

      var userMessages = messages
      ..where((message) => readable.containsKey(message))
      ..map((message) => readable[message]).toList();

      _result(false, userMessages);
    }

  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: ${e}']);
  }
}

Future<List> asyncStringEquals({String expected, String actual, List<String> messages}) async {
  try {
//    print("Actual: $actual");
    if (expected == actual) {
      return [true];
    } else {
      messages.add(actual);
      return [false, messages];
    }
  } catch(e) {
    messages.add(e.toString());
    return [false, messages];
  }
}
