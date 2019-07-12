part of cobblestone;

/// A manager that loads assets in the background while the main loop continues.
class AssetManager {
  Map<String, dynamic> _assets;

  List<String> _toLoad;

  /// Creates an empty asset manager.
  AssetManager() {
    _assets = new Map<String, dynamic>();
    _toLoad = [];
  }

  /// Returns true if all assets are loaded.
  bool allLoaded() {
    for (String asset in _toLoad) {
      if (!_assets.containsKey(asset)) {
        return false;
      }
    }
    return true;
  }

  /// Begins loading an asset. Assets can later be retrieved by [get]
  void load(String source, Future asset) {
    _toLoad.add(source);
    asset.then((data) {
      _assets[source] = data;
    });
  }

  /// Gets an asset by its source.
  get(String asset) {
    return _assets[asset];
  }
}
