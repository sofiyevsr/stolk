import 'dart:collection';
import 'dart:math';

const _contentCount = 10;
final _rnd = Random();

HashSet<int> getRandomAdPlaces(
  int length,
) {
  final randomOffset = _rnd.nextInt(_contentCount - 3) + 3;
  final hash = HashSet<int>();
  for (int index = 0; index < length; index++) {
    hash.add(_rnd.nextInt(index * _contentCount + randomOffset));
  }
  return hash;
}
