part of cobblestone;

class AssetManager {

  Map<String, dynamic> assets;

  List<String> toLoad;

  AssetManager() {
    assets = new Map<String, dynamic>();
    toLoad = [];
  }

  bool allLoaded() {
    for(String asset in toLoad) {
      if(!assets.containsKey(asset)) {
        return false;
      }
    }
    return true;
  }

  void load(String source, Future asset) {
    toLoad.add(source);
    asset.then((data) {
      assets[source] = data;
    });
  }

  get(String asset) {
    return assets[asset];
  }

}