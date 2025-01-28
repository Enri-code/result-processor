import 'package:equatable/equatable.dart';

class ActivityLog extends Equatable {
  final int id; //, resourceId;
  final String userId, username, action, resource;
  final String details, userAgent;
  final DateTime? time;

  const ActivityLog({
    required this.id,
    required this.userId,
    // required this.resourceId,
    required this.username,
    required this.action,
    required this.resource,
    required this.details,
    required this.userAgent,
    required this.time,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> data) {
    return ActivityLog(
      id: data['id'],
      userId: data['user_id']?.toString() ?? '',
      // resourceId: data['resource_id'],
      username: data['username'] ?? '',
      action: data['action'] ?? '',
      resource: data['resource'] ?? '',
      details: data['details'] ?? '',
      userAgent: data['user_agent'] ?? '',
      time: DateTime.tryParse(data['timestamp'] ?? ''),
    );
  }

  @override
  List<Object?> get props => [id, userId];
}
