part of cobblestone;

/// A manager for loading assets
class AssetManager {
  Map<String, dynamic> assets;

  List<String> toLoad;

  /// Creates an empty asset manager
  AssetManager() {
    assets = new Map<String, dynamic>();
    toLoad = [];
  }

  /// Returns true if all assets are loaded
  bool allLoaded() {
    for (String asset in toLoad) {
      if (!assets.containsKey(asset)) {
        return false;
      }
    }
    return true;
  }

  /// Begins loading an asset
  void load(String source, Future asset) {
    toLoad.add(source);
    asset.then((data) {
      assets[source] = data;
    });
  }

  /// Gets an asset by its source
  get(String asset) {
    return assets[asset];
  }
}
