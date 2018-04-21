part of cobblestone;

class ExternalConst {
  const ExternalConst();
}

final Matrix4 identityMatrix = new Matrix4.identity();

const String projMatUni = 'uPMatrix';
const String transMatUni = 'uMVMatrix';

const String colorUni = 'uColor';
const String samplerUni = 'uSampler';

const String vertPosAttrib = 'aVertexPosition';
const String textureCoordAttrib = 'aTextureCoord';
const String colorAttrib = 'aColor';

@ExternalConst()
const String defaultShader = "/const_data.dart";


