import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:step_counter/core/error/failures.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
