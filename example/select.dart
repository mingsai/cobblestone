import 'dart:html';
import 'package:cobblestone/cobblestone.dart';
import 'example_geometry.dart';
import 'example_performance.dart';
import 'example_tilemap.dart';
import 'example_audio.dart';

BaseGame demo;

main() {
	switchDemo(null);
	querySelector("#demo-select").onChange.listen(switchDemo);
}

switchDemo(Event e) {
	if(demo != null) {
		demo.end();
	}
	
	String selection = (querySelector("#demo-select") as SelectElement).value;
	switch(selection) {
		case 'geometry':
			demo = new GeometryExample();
			break;
		case 'performance':
			demo = new PerformanceExample();
			break;
		case 'tilemap':
			demo = new TilemapExample();
			break;
		case 'audio':
			demo = new AudioExample();
			break;
		default:
			demo = new GeometryExample();
			break;
	}
}