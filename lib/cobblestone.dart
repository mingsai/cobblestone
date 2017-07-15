// Copyright (c) 2016, Ethan Tucker. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A 2D-Game library
///
/// Includes a rendering engine, audio playing, and asset management
library cobblestone;

import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'dart:convert';
import 'package:path/path.dart' as Path;
import 'dart:web_audio' as WebAudio;
import 'package:tweenengine/tweenengine.dart' as Tween;
import 'package:xml/xml.dart' as XML;
export 'dart:html';
export 'dart:math';
export 'dart:async';
export 'package:vector_math/vector_math.dart';

part 'package:cobblestone/src/state/base_game.dart';
part 'package:cobblestone/src/graphics/gl_program.dart';
part 'package:cobblestone/src/graphics/const_data.dart';
part 'package:cobblestone/src/graphics/gl_util.dart';
part 'package:cobblestone/src/math/scale.dart';
part 'package:cobblestone/src/graphics/texture.dart';
part 'package:cobblestone/src/math/camera.dart';
part 'package:cobblestone/src/math/transform.dart';
part 'package:cobblestone/src/assets/asset_manager.dart';
part 'package:cobblestone/src/graphics/sprite_batch.dart';
part 'package:cobblestone/src/map/tilemap.dart';
part 'package:cobblestone/src/audio/sound.dart';
part 'package:cobblestone/src/tween/vector2_accessor.dart';
part 'package:cobblestone/src/tween/vector3_accessor.dart';
part 'package:cobblestone/src/tween/vector4_accessor.dart';
part 'package:cobblestone/src/tween/num_accessor.dart';
part 'package:cobblestone/src/graphics/vertex_batch.dart';
part 'package:cobblestone/src/graphics/point_batch.dart';
part 'package:cobblestone/src/graphics/physbox_batch.dart';
part 'package:cobblestone/src/map/tile.dart';
part 'package:cobblestone/src/assets/texture_atlas.dart';
part 'package:cobblestone/src/graphics/framebuffer.dart';
part 'package:cobblestone/src/audio/music.dart';
part 'package:cobblestone/src/state/state.dart';
part 'package:cobblestone/src/input/keyboard.dart';
part 'package:cobblestone/src/input/mouse.dart';
