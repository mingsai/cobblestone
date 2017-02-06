// Copyright (c) 2016, Ethan Tucker. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library cobblestone;

import 'dart:web_gl' as WebGL;
import 'dart:typed_data';
import 'dart:html';
import 'dart:math';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'dart:convert';
import 'dart:web_audio' as WebAudio;
import 'package:tweenengine/tweenengine.dart' as Tween;

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