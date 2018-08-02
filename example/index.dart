import 'dart:html';

import 'example_lib.dart';

var example;

var featureDemoNames = [
  'geometry',
  'atlas',
  'batches',
  'fbo',
  'tilemap',
  'shaders',
  'tweens',
  'audio'
];
var featureDemoConstructors = [
  () => new GeometryExample(),
  () => new AtlasExample(),
  () => new BatchExample(),
  () => new FBOExample(),
  () => new TilemapExample(),
  () => new ShaderExample(),
  () => new TweenExample(),
  () => new AudioExample()
];

var advancedDemoNames = [
  'performance',
  'handpainted',
  'lighting'
];
var advancedDemoConstructors = [
      () => new PerformanceExample(),
      () => new HandpaintedExample(),
      () => new LightingExample()
];

main() {
  var featureList = querySelector('#features');
  for (var demo in featureDemoNames) {
    featureList.append(makeDemoLink(demo));
  }

  var advancedList = querySelector('#advanced');
  for (var demo in advancedDemoNames) {
    advancedList.append(makeDemoLink(demo));
  }

  example = featureDemoConstructors[0]();
}

makeDemoLink(String demo) {
  AnchorElement demoLink = new AnchorElement()
    ..onClick.listen((e) => switchTo(demo))
    ..href = "#${demo}"
    ..text = demo;

  AnchorElement sourceLink = new AnchorElement()
    ..href =
        'https://github.com/specialcode/cobblestone/tree/master/example/${demo}/example_${demo}.dart'
    ..text = 'source';

  Element group = new ParagraphElement()
    ..append(demoLink)
    ..appendText(" - ")
    ..append(sourceLink);

  Element li = new Element.li()
    ..append(group);

  return li;
}

switchTo(String demo) {
  example.stop();
  if(featureDemoNames.indexOf(demo) != -1) {
    example = featureDemoConstructors[featureDemoNames.indexOf(demo)]();
  } else {
    example = advancedDemoConstructors[advancedDemoNames.indexOf(demo)]();
  }
}
