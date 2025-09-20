import 'validator.dart';

class PixValidator implements Validator<String> {
  static final _chain = [ PixCpfValidator(), PixPhoneValidator(), PixRandomKeyValidator() ];

  @override
  Result<String> validate(String pixKey) {
    for (var handler in _chain) {
      var result = handler.validate(pixKey);
      if (result.isSuccess) {
        return result;
      }
    }

    return Result(false);
  }
}

class PixCpfValidator implements Validator<String> {
  static final _regexes = [
    RegExp(r"^(\d{11})"),
    RegExp(r"^(\d{3})\.(\d{3})\.(\d{3})-(\d{2})")
  ];

  @override
  Result<String> validate(String pixKey) {
    for (var regex in _regexes) {
      var match = regex.firstMatch(pixKey);
      if (match != null) {
        var groupIndices = List.generate(match.groupCount, (i) => i + 1);
        var groups = match.groups(groupIndices);
        return Result<String>(true, value: groups.join());
      }
    }

    return Result(false);
  }
}

class PixPhoneValidator implements Validator<String> {
  static final _regexes = [
    RegExp(r"^(?:\+55)?\s*(\d{11})"),
    RegExp(r"^(?:\+55)?\s*\((\d{2})\)\s*(\d{5})-?(\d{4})")
  ];

  @override
  Result<String> validate(String pixKey) {
    for (var regex in _regexes) {
      var match = regex.firstMatch(pixKey);
      if (match != null) {
        var groupIndices = List.generate(match.groupCount, (i) => i + 1);
        var groups = match.groups(groupIndices);
        return Result<String>(true, value: "+55${groups.join()}");
      }
    }

    return Result(false);
  }
}

class PixRandomKeyValidator implements Validator<String> {
  static final _regex = RegExp(r"[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}");

  @override
  Result<String> validate(String pixKey) {
    if (_regex.hasMatch(pixKey)) {
      return Result<String>(true, value: pixKey);
    }

    return Result(false);
  }
}
