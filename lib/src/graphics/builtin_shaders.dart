part of cobblestone;

const String batchVertexShaderSrc = '''
attribute vec3 aVertexPosition;
attribute vec2 aTextureCoord;

uniform mat4 uPMatrix;

varying vec2 vTextureCoord;

void main(void) {
    vTextureCoord = aTextureCoord;
    gl_Position = uPMatrix * vec4(aVertexPosition, 1.0);
}
''';

const String batchFragmentShaderSrc = '''
precision highp float;

uniform sampler2D uTexture;
uniform vec4 uColor;

varying vec2 vTextureCoord;

void main(void) {
    gl_FragColor = texture2D(uTexture, vec2(vTextureCoord.s, vTextureCoord.t)) * uColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';

const String wireVertexShaderSrc = '''
attribute vec3 aVertexPosition;
uniform mat4 uPMatrix;

uniform vec4 uColor;

void main(void) {
    gl_Position = uPMatrix * vec4(aVertexPosition, 1.0);
}
''';

const String wireFragmentShaderSrc = '''
precision highp float;

uniform vec4 uColor;

void main(void) {
    gl_FragColor = uColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';

const String pointVertexShaderSrc = '''
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

const String pointFragmentShaderSrc = '''
precision highp float;

varying vec4 vColor;

void main(void) {
    gl_FragColor = vColor;
    if(gl_FragColor.a <= 0.0)
        discard;
}
''';