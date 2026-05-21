import 'package:equatable/equatable.dart';

class ActivityItem extends Equatable {
  const ActivityItem({required this.title, required this.subtitle, required this.at});

  final String title;
  final String subtitle;
  final DateTime at;

  @override
  List<Object?> get props => [title, subtitle, at];
}

