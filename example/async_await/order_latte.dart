const order = 'almond milk';
const change = '\$3.02';
const oneSecond = Duration(seconds: 1);
const twoSeconds = Duration(seconds: 2);
const threeSeconds = Duration(seconds: 3);

Future<String> getLatteOrder() async {
  var order = await getUserOrder(); // Can take a while
  return 'Your order is: $order';
}

Future<String> prepareLatte() async {
  return await makeLatte();
}

Future<String> getChange() async {
  var change = await getDollarAmount(); // Can take a while
  return 'Your change is: $change';
}

Future<String> getUserOrder() =>
    Future.delayed(oneSecond, () => order);

Future<String> getDollarAmount() =>
    Future.delayed(twoSeconds, () => change);

Future<String> makeLatte() =>
    Future.delayed(threeSeconds, () => 'Thank you! Your $order latte is ready!');

main() async {
  await asyncStringEquals(
      '==Should get Latte Order==',
      'Your order is: almond milk',
      await getLatteOrder());

  await asyncStringEquals(
      '==Should get Prepare Latte==',
      'Thank you! Your almond milk latte is ready!',
      await prepareLatte());

  await asyncStringEquals(
      '==Should make Change==',
      'Your change is: \$3.02',
      await getChange());
}

Future<void> asyncStringEquals(msg, expected, actual) async {
  print(msg);
  if (expected == actual) {
    print('PASS: $actual');
    return true;
  } else {
    print("FAILED: ");
    print("Expected: $expected");
    print("Actual: $actual");
    return false;
  }
}

