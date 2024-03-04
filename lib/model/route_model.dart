class Directions {
  List<Route> routes;

  Directions({required this.routes});

  factory Directions.fromJson(Map<String, dynamic> json) {
    return Directions(
      routes: (json['routes'] as List<dynamic>)
          .map((r) => Route.fromJson(r))
          .toList(),
    );
  }
}

class Route {
  List<Leg> legs;
  Route({required this.legs});
  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      legs:
          (json['legs'] as List<dynamic>).map((r) => Leg.fromJson(r)).toList(),
    );
  }
}

class Leg {
  List<Step> steps;
  Distance distance;
  Duration duration;
  StartLocation start_location;
  EndLocation end_location;
  String end_address;
  String start_address;
  Leg({
    required this.steps,
    required this.distance,
    required this.duration,
    required this.start_location,
    required this.end_location,
    required this.start_address,
    required this.end_address,
  });
  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      steps: List<Step>.from(json["steps"].map((x) => Step.fromJson(x))),
      distance: Distance.fromJson(json["distance"]),
      duration: Duration.fromJson(json["duration"]),
      start_location: StartLocation.fromJson(json["start_location"]),
      end_location: EndLocation.fromJson(json["end_location"]),
      start_address: json["start_address"],
      end_address: json["end_address"],
    );
  }
}

class Step {
  Distance distance;
  Duration duration;
  StartLocation start_location;
  EndLocation end_location;

  Step(
      {required this.distance,
      required this.duration,
      required this.start_location,
      required this.end_location});

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      distance: Distance.fromJson(json["distance"]),
      duration: Duration.fromJson(json["duration"]),
      start_location: StartLocation.fromJson(json["start_location"]),
      end_location: EndLocation.fromJson(json["end_location"]),
    );
  }
}

class Distance {
  String text;
  int value;

  Distance({required this.text, required this.value});

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(
      text: json['text'],
      value: json['value'],
    );
  }
}

class Duration {
  String text;
  int value;

  Duration({required this.text, required this.value});

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      text: json['text'],
      value: json['value'],
    );
  }
}

class StartLocation {
  double lat;
  double lng;

  StartLocation({required this.lat, required this.lng});

  factory StartLocation.fromJson(Map<String, dynamic> json) {
    return StartLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class EndLocation {
  double lat;
  double lng;

  EndLocation({required this.lat, required this.lng});

  factory EndLocation.fromJson(Map<String, dynamic> json) {
    return EndLocation(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
