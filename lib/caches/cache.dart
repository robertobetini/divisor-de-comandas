import 'package:divisao_contas/models/order.dart';

class Cache<TKey, TValue> {
  final _cache = <TKey, TValue> {};

  void set(TKey key, TValue? value) {
    if (value == null) {
      return;
    }

    _cache[key] = value;
  }

  TValue? get(TKey? key) => key != null && _cache.containsKey(key) ? _cache[key] : null;
  TValue? remove(TKey key) => _cache.remove(key);
  void clear() => _cache.clear();
}

final orderCache = Cache<int, Order>();
