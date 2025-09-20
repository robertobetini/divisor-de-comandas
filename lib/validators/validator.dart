abstract class Validator<T> {
  Result<T> validate(T obj);
}

class Result<T> {
  Result(this.isSuccess, { this.value });

  final bool isSuccess;
  final T? value; 
}
