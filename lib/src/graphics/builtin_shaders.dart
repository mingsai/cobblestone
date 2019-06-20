part of cobblestone;

const String _batchVertexShaderSrc = '''
attribute vec3 aVertexPosition;
attribute vec2 aTextureCoord;
attribute vec4 aColor;

uniform mat4 uPMatrix;

varying vec2 vTextureCoord;
varying vec4 vColor;

void main(void) {
    vTextureCoord = aTextureCoord;
    vColor = aColor;
    gl_Position = uPMatrix * vec4(aVertexPosition, 1.0);
}
''';

const String _batchFragmentShaderSrc = '''
precision highp float;

uniform sampler2D uTexture;

varying vec2 vTextureCoord;
varying vec4 vColor;

void main(void) {
    gl_FragColor = texture2D(uTexture, vec2(vTextureCoord.s, vTextureCoord.t)) * vColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';

const String _wireVertexShaderSrc = '''
attribute vec3 aVertexPosition;
uniform mat4 uPMatrix;

uniform vec4 uColor;

void main(void) {
    gl_Position = uPMatrix * vec4(aVertexPosition, 1.0);
}
''';

const String _wireFragmentShaderSrc = '''
precision highp float;

uniform vec4 uColor;

void main(void) {
    gl_FragColor = uColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';

const String _pointVertexShaderSrc = '''
attribute vec3 aVertexPosition;
attribute vec4 aColor;

uniform mat4 uPMatrix;

varying vec4 vColor;

void main(void) {
    vColor = aColor;
    gl_Position = uPMatrix * vec4(aVertexPosition, 1.0);
    gl_PointSize = 10.0;
}
''';

const String _pointFragmentShaderSrc = '''
precision highp float;

varying vec4 vColor;

void main(void) {
    gl_FragColor = vColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';