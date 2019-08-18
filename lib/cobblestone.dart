// Copyright (c) 2016, Ethan Tucker. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A 2D-Game library
///
/// Includes a rendering engine, audio playing, and asset management
library cobblestone;

import 'dart:web_gl' show WebGL;
import 'dart:web_gl' as GL;
import 'dart:typed_data';
import 'dart:html';
import 'dart:math';
import 'dart:collection';
import 'dart:async';
import 'package:vector_math/vector_math.dart';
import 'dart:convert';
import 'package:path/path.dart' as Path;
import 'dart:web_audio' as WebAudio;
import 'package:xml/xml.dart' as XML;
import 'package:petitparser/petitparser.dart';

export 'dart:html' show KeyCode, HttpRequest;
export 'dart:math';
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
part 'package:cobblestone/src/graphics/vertex_batch.dart';
part 'package:cobblestone/src/graphics/point_batch.dart';
part 'package:cobblestone/src/graphics/debug_batch.dart';
part 'package:cobblestone/src/map/tile.dart';
part 'package:cobblestone/src/assets/texture_atlas.dart';
part 'package:cobblestone/src/graphics/framebuffer.dart';
part 'package:cobblestone/src/audio/music.dart';
part 'package:cobblestone/src/state/state.dart';
part 'package:cobblestone/src/input/keyboard.dart';
part 'package:cobblestone/src/input/mouse.dart';
part 'package:cobblestone/src/graphics/builtin_shaders.dart';
part 'package:cobblestone/src/graphics/gl_wrapper.dart';
part 'package:cobblestone/src/audio/audio_wrapper.dart';
part 'package:cobblestone/src/tween/tween.dart';
part 'package:cobblestone/src/tween/tween_manager.dart';
part 'package:cobblestone/src/tween/easings.dart';
part 'package:cobblestone/src/graphics/bitmap_font.dart';
part 'package:cobblestone/src/graphics/particles.dart';
part 'package:cobblestone/src/map/objects.dart';
part 'package:cobblestone/src/map/xml.dart';
part 'package:cobblestone/src/map/properties.dart';
part 'package:cobblestone/src/assets/parsers.dart';
part 'package:cobblestone/src/map/tileset.dart';