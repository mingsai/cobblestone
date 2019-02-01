part of cobblestone;

/// Compiles a new shader form code at the [vertex] and [fragment] URLS
Future<ShaderProgram> loadProgram(GLWrapper wrapper, String vertex, String fragment) {
  return Future.wait([
    HttpRequest.getString(vertex),
    HttpRequest.getString(fragment)
  ]).then((List<String> sources) =>
      wrapper.compileShader(sources[0], sources[1]));
}

/// A compiled WebGL shader
class ShaderProgram {
  GLWrapper wrapper;
  GL.RenderingContext context;

  Map<String, int> attributes = new Map<String, int>();
  Map<String, GL.UniformLocation> uniforms =
      new Map<String, GL.UniformLocation>();
  GL.Program program;

  GL.Shader fragShader, vertShader;

  /// Compiles a new shader with the text content of [vertexSource] and [fragmentSource]
  ShaderProgram.compile(this.wrapper, String vertexSource, String fragmentSource) {
    context = wrapper.context;
    
    fragShader = context.createShader(WebGL.FRAGMENT_SHADER);
    context.shaderSource(fragShader, fragmentSource);
    context.compileShader(fragShader);

    vertShader = context.createShader(WebGL.VERTEX_SHADER);
    context.shaderSource(vertShader, vertexSource);
    context.compileShader(vertShader);

    program = context.createProgram();
    context.attachShader(program, vertShader);
    context.attachShader(program, fragShader);
    context.linkProgram(program);

    if (!context.getProgramParameter(program, WebGL.LINK_STATUS)) {
      print("Could not initialise shaders");
    }

    int activeAttributes =
        context.getProgramParameter(program, WebGL.ACTIVE_ATTRIBUTES);
    int activeUniforms = context.getProgramParameter(program, WebGL.ACTIVE_UNIFORMS);

    for (int i = 0; i < activeAttributes; i++) {
      GL.ActiveInfo a = context.getActiveAttrib(program, i);
      int attributeLocation = context.getAttribLocation(program, a.name);
      attributes[a.name] = attributeLocation;
    }

    for (int i = 0; i < activeUniforms; i++) {
      GL.ActiveInfo a = context.getActiveUniform(program, i);
      uniforms[a.name] = context.getUniformLocation(program, a.name);
    }
  }

  startProgram() {
    attributes
        .forEach((name, location) => context.enableVertexAttribArray(location));
    context.useProgram(program);
  }

  setUniform(String name, dynamic value) {
    if (value is int) {
      context.uniform1i(uniforms[name], value);
    } else if (value is double) {
      context.uniform1f(uniforms[name], value);
    } else if (value is Vector2) {
      context.uniform2f(uniforms[name], value.x, value.y);
    } else if (value is Vector3) {
      context.uniform3f(uniforms[name], value.x, value.y, value.z);
    } else if (value is Vector4) {
      context.uniform4f(uniforms[name], value.x, value.y, value.z, value.w);
    } else if (value is Matrix4) {
      context.uniformMatrix4fv(uniforms[name], false, value.storage);
    } else if(value is List) {
      name = name + '[0]'; //Really weird way an array uniform is distinguished
      if (value[0] is int) {
        context.uniform1iv(uniforms[name], value);
      } else if (value[0] is double) {
        context.uniform1fv(uniforms[name], value);
      } else if (value[0] is Vector2) {
        var array = [];
        for(var vector in value) {
          array.add(vector.x);
          array.add(vector.y);
        }
        context.uniform2fv(uniforms[name], array);
      } else if (value[0] is Vector3) {
        var array = [];
        for(var vector in value) {
          array.add(vector.x);
          array.add(vector.y);
          array.add(vector.z);
        }
        context.uniform3fv(uniforms[name], array);
      } else if (value[0] is Vector4) {
        var array = [];
        for(var vector in value) {
          array.add(vector.x);
          array.add(vector.y);
          array.add(vector.z);
          array.add(vector.w);
        }
        context.uniform4fv(uniforms[name], array);
      } else if (value[0] is Matrix4) {
        var array = [];
        for(var matrix in value) {
          array.addAll(matrix.storage);
        }
        context.uniformMatrix4fv(uniforms[name], false, array);
      }
    }
  }

  endProgram() {
    attributes
        .forEach((name, location) => context.disableVertexAttribArray(location));
  }
}
