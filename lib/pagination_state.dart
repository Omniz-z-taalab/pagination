part of 'pagination_bloc.dart';

@immutable
abstract class PaginationState {}

class PaginationInitial extends PaginationState {}
class PaginationSuccess extends PaginationState {}
