part of cobblestone;

Future<Map<String, GameTexture>> loadAtlas(String atlasUrl, Future<GameTexture> texture) async {
  var atlasData = JSON.decode(await HttpRequest.getString(atlasUrl));
  GameTexture atlasTexture = await texture;

  Map<String, GameTexture> atlas = new Map<String, GameTexture>();
  atlasData.forEach((name, data) {
    atlas[name] = new GameTexture.clone(atlasTexture);
    atlas[name].setRegion(data["rect"][0],
      atlasTexture.height - data["rect"][3] - data["rect"][1],
      data["rect"][2],
      data["rect"][3]);
  });
  return atlas;
}