part of cobblestone;

/// An object in a tilemap.
abstract class MapObject {
  /// The object group this map object is part of.
  ObjectGroup parent;

  /// The name of this map object.
  String name;

  /// The type of this map object.
  String type;

  /// The position of this map object.
  Vector2 pos;

  /// The rotation of this map object.
  double rotation;

  /// The visibility of this map object.
  bool visible;

  /// Custom user properties for this map object.
  MapProperties properties;

  /// Creates a new map object from TMX data.
  ///
  /// The specific type of the object is determined by the data.
  static MapObject load(ObjectGroup parent, XML.XmlElement object) {
    String name = _parseAttrib(object, "name", (str) => str, "");
    String type = _parseAttrib(object, "type", (str) => str, "");

    double x = double.parse(object.getAttribute("x"));
    double y = double.parse(object.getAttribute("y"));
    // Default sizes for rectangles and ellipses
    double width = _parseAttrib(object, "width", double.parse, 20);
    double height = _parseAttrib(object, "height", double.parse, 20);
    double rotation = _parseAttrib(object, "rotation", double.parse, 0);

    bool visible = _parseAttrib(object, "visible", (str) => str == "1", true);

    y = parent.map.height * parent.map.tileHeight - y;

    MapProperties props = MapProperties.fromChild(object);

    if (object.findElements("point").isNotEmpty) {
      // Points need to be raised 20 to compensate for assumed default height.
      return MapPoint(parent, name, type, Vector2(x, y), visible, props);
    } else if (object.findElements("ellipse").isNotEmpty) {
      y -= height;
      return MapEllipse(parent, name, type, Vector2(x, y), width, height,
          rotation, visible, props);
    } else if (object.findElements("polygon").isNotEmpty) {
      String pointData =
          object.findElements("polygon").first.getAttribute("points");
      List<Vector2> parsedPoints = pointData.split(" ").map((String pair) {
        List<String> coord = pair.split(",");
        return Vector2(double.parse(coord.first), -double.parse(coord.last));
      }).toList();

      return MapPolygon(parent, name, type, Vector2(x, y), parsedPoints,
          rotation, visible, props);
    } else if (object.findElements("text").isNotEmpty) {
      String text = object.findElements("text").first.text;

      // TODO more text properties
      return MapText(
          parent, name, type, Vector2(x, y), text, rotation, visible, props);
    } else {
      // Tiled objects default to rectangle (or maybe tile)
      // TODO support Tile objects
      y -= height;
      return MapRect(parent, name, type, Vector2(x, y), width, height, rotation,
          visible, props);
    }
  }
}

/// A map object consisting of a single point.
class MapPoint extends MapObject {
  ObjectGroup parent;

  String name;
  String type;

  Vector2 pos;

  bool visible;

  final double rotation = 0.0;

  MapProperties properties;

  /// Creates a new MapPoint from the given data.
  MapPoint(this.parent, this.name, this.type, this.pos, this.visible,
      this.properties);
}

/// A map object consisting of a rectangle.
class MapRect extends MapObject {
  ObjectGroup parent;

  String name;
  String type;

  Vector2 pos;

  /// The width of the rectangle, in pixels.
  double width;

  /// The height of the rectangle, in pixels.
  double height;

  double rotation;

  bool visible;

  MapProperties properties;

  /// Creates a new MapRect from the given data.
  MapRect(this.parent, this.name, this.type, this.pos, this.width, this.height,
      this.rotation, this.visible, this.properties);
}

/// A map object consisting of an ellipse.
class MapEllipse extends MapObject {
  ObjectGroup parent;

  String name;
  String type;

  Vector2 pos;

  /// The width of the ellipse, in pixels.
  double width;

  /// The height of the ellipse, in pixels.
  double height;

  double rotation;

  bool visible;

  MapProperties properties;

  /// Creates a new MapEllipse from the given data.
  MapEllipse(this.parent, this.name, this.type, this.pos, this.width,
      this.height, this.rotation, this.visible, this.properties);
}

/// A map object consisting of a polygon.
class MapPolygon extends MapObject {
  ObjectGroup parent;

  String name;
  String type;

  Vector2 pos;

  /// The list of points that make up this polygon.
  List<Vector2> points;

  double rotation;

  bool visible;

  MapProperties properties;

  /// Creates a new MapPolygon from the given data.
  MapPolygon(this.parent, this.name, this.type, this.pos, this.points,
      this.rotation, this.visible, this.properties);
}

/// A map object consisting of a string of text.
class MapText extends MapObject {
  ObjectGroup parent;

  String name;
  String type;

  Vector2 pos;

  /// The string that makes up this map text.
  String text;

  double rotation;

  bool visible;

  MapProperties properties;

  /// Creates a new MapText from the given data.
  MapText(this.parent, this.name, this.type, this.pos, this.text, this.rotation,
      this.visible, this.properties);
}
