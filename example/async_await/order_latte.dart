
Future<String> getLatteOrder() async {
  var order = await getUserOrder();
  return 'Your order is: $order';
}

Future<String> prepareLatte() async {
  return await makeLatte();
}

Future<String> getChange() async {
  var change = await getDollarAmount();
  return 'Your change is: $change';
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

Future<String> makeLatte() =>
    Future.delayed(threeSeconds, () => 'Thank you! Your $order latte is ready!');


main() async {
  try {
    List<String> messages = [];

    var getLatteResult = await asyncStringEquals(
        expected: 'Your order is: almond milk',
        actual: await getLatteOrder(),
        messages: messages
    );

    var prepareLatteResult = await asyncStringEquals(
        expected: 'Thank you! Your almond milk latte is ready!',
        actual: await prepareLatte(),
        messages: messages
    );

    var getChangeResult = await asyncStringEquals(
        expected: 'Your change is: 3.02',
        actual: await getChange(),
        messages: messages
    );

    var passed =
      (getLatteResult[0] == true) &&
      (prepareLatteResult[0] == true) &&
      (getChangeResult[0] == true);

    if (passed) {
      _result(true);
    } else {
      _result(false, messages);
    }

  } catch (e) {
    _result(false, ['Tried to run solution, but received an exception: ${e.runtimeType}']);
  }
}

// returns true for success, false for failure and/or error
Future<List> asyncStringEquals({String expected, String actual, List<String> messages}) async {
  try {
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

