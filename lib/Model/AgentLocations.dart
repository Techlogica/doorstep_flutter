// ignore_for_file: file_names, constant_identifier_names, non_constant_identifier_names

const String agent_locations = 'agent_location';

class AgentLocationsFields {
  static final List<String> values = [
    /// Add all fields
    agent_location_id,
    agent_name,
    agent_latitude,
    agent_longitude
  ];

  static const String agent_location_id = 'location_id';
  static const String agent_name = "agent_name";
  static const String agent_latitude = "agent_latitude";
  static const String agent_longitude = "agent_longitude";
}

class AgentLocations {
  final int? agent_location_id;
  final String? agent_name;
  final String agent_latitude;
  final String agent_longitude;

  const AgentLocations({
    required this.agent_location_id,
    required this.agent_name,
    required this.agent_latitude,
    required this.agent_longitude,
  });

  AgentLocations copy(
          {int? agent_location_id,
          String? agent_name,
          String? agent_latitude,
          String? agent_longitude}) =>
      AgentLocations(
        agent_location_id: agent_location_id ?? this.agent_location_id,
        agent_name: agent_name ?? this.agent_name,
        agent_latitude: agent_latitude ?? this.agent_latitude,
        agent_longitude: agent_longitude ?? this.agent_longitude,
      );

  static AgentLocations fromJson(Map<String, Object?> json) => AgentLocations(
        agent_location_id: json[AgentLocationsFields.agent_location_id] as int?,
        agent_name: json[AgentLocationsFields.agent_name] as String?,
        agent_latitude: json[AgentLocationsFields.agent_latitude] as String,
        agent_longitude: json[AgentLocationsFields.agent_longitude] as String,
      );

  Map<String, Object?> toJson() => {
        AgentLocationsFields.agent_location_id: agent_location_id,
        AgentLocationsFields.agent_name: agent_name,
        AgentLocationsFields.agent_latitude: agent_latitude,
        AgentLocationsFields.agent_longitude: agent_longitude,
      };
}
