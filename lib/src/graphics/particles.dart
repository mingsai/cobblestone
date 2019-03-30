part of cobblestone;

/// Loads a particle effect exported by https://pixijs.io/pixi-particles-editor/
Future<ParticleEffect> loadEffect(
    String effectUrl, Future<Texture> texture) async {
  var effectData = json.decode(await HttpRequest.getString(effectUrl));
  Texture effectTexture = await texture;
  return new ParticleEffect.fromJSON(effectData, effectTexture);
}

enum SpawnType { point, rect, circle, ring, burst }

// All the information needed to emit particles
// Use with [ParticleEmitter]
class ParticleEffect {
  // Particle Properties

  Texture texture;

  Vector2 spawnOffset;

  Vector4 colorStart;
  Vector4 colorEnd;

  double speedStart;
  double speedEnd;
  double speedMultiplier;

  double scaleStart;
  double scaleEnd;
  double scaleMultiplier;

  Vector2 acceleration;
  double maxSpeed;

  double minStartRotation;
  double maxStartRotation;

  bool doRotation;
  double minRotationSpeed;
  double maxRotationSpeed;

  double minLifetime;
  double maxLifetime;

  // Emitter properties

  double spawnFrequency;
  double emitterLifetime;
  int maxParticles;

  SpawnType type;

  Vector2 emitterOffset;

  Vector2 rectPos;
  Vector2 rectSize;

  Vector2 circlePos;
  double circleRadius;

  Vector2 ringPos;
  double minRingRadius;
  double maxRingRadius;

  int burstParticlesPerWave;
  double burstParticleSpacing;
  double burstStartAngle;

  ParticleEffect(this.texture) {
    spawnOffset = Vector2(texture.width / 2, texture.height / 2);
  }

  ParticleEffect.fromJSON(var data, this.texture) {
    spawnOffset = Vector2(texture.width / 2, texture.height / 2);

    colorStart = Vector4.zero();
    Colors.fromHexString(data['color']['start'], colorStart);
    colorStart.a = data['alpha']['start'];

    colorEnd = Vector4.zero();
    Colors.fromHexString(data['color']['end'], colorEnd);
    colorEnd.a = data['alpha']['end'];

    scaleStart = data['scale']['start'];
    scaleEnd = data['scale']['end'];
    scaleMultiplier = data['scale']['minimumScaleMultiplier'];

    speedStart = data['speed']['start'];
    speedEnd = data['speed']['end'];
    speedMultiplier = data['speed']['minimumSpeedMultiplier'];

    acceleration =
        Vector2(data['acceleration']['x'], data['acceleration']['y']);
    maxSpeed = data['maxSpeed'];

    minStartRotation = data['startRotation']['min'];
    maxStartRotation = data['startRotation']['max'];

    doRotation = !data['noRotation'];
    minRotationSpeed = data['rotationSpeed']['min'];
    maxRotationSpeed = data['rotationSpeed']['max'];

    minLifetime = data['lifetime']['min'];
    maxLifetime = data['lifetime']['max'];

    spawnFrequency = data['frequency'];
    emitterLifetime = data['emitterLifetime'];
    maxParticles = data['maxParticles'];

    emitterOffset = Vector2(data['pos']['x'], data['pos']['y']);

    type = SpawnType.values
        .firstWhere((e) => e.toString() == 'SpawnType.' + data['spawnType']);

    switch(type) {
      case SpawnType.point:
        break;
      case SpawnType.burst:
        burstParticlesPerWave = data['particlesPerWave'];
        burstParticleSpacing = data['particleSpacing'];
        burstStartAngle = data['angleStart'];
        break;
      case SpawnType.circle:
        circlePos = Vector2(data['spawnCircle']['x'], data['spawnCircle']['y']);
        circleRadius = data['spawnCircle']['r'];
        break;
      case SpawnType.rect:
        rectPos = Vector2(data['spawnRect']['x'], data['spawnRect']['y']);
        rectSize = Vector2(data['spawnRect']['w'], data['spawnRect']['h']);
        break;
      case SpawnType.ring:
        ringPos = Vector2(data['spawnCircle']['x'], data['spawnCircle']['y']);
        minRingRadius = data['spawnCircle']['minR'];
        maxRingRadius = data['spawnCircle']['r'];
        break;
    }
  }
}

// An emitter for particles, with behavoir controlled by a [ParticleEffect]
class ParticleEmitter {
  ParticleEffect effect;

  Random rand;

  Vector2 pos;

  double _time = 0.0;
  double _totalTime = 0.0;

  List<Particle> particles;

  List<Particle> _toRemove;

  // Creates a particle emitter from the given effect
  ParticleEmitter(this.effect, [this.rand]) {
    if(rand == null) {
      rand = new Random();
    }
    pos = Vector2.zero();
    particles = [];
    _toRemove = [];
  }

  // Updates all the live particles emitted
  update(double delta) {
    _toRemove.clear();
    for (Particle particle in particles) {
      particle.update(delta);
      if(particle._time > particle.lifetime) {
        _toRemove.add(particle);
      }
    }
    for(Particle particle in _toRemove) {
      particles.remove(particle);
    }

    _time += delta;
    _totalTime += delta;
    if (_totalTime < effect.emitterLifetime ||
        effect.emitterLifetime == 0 ||
        effect.emitterLifetime == -1) {
      while(_time >= effect.spawnFrequency) {
        spawnWave();
        _time -= effect.spawnFrequency;
      }
    }
  }

  // Draws all emitted particles in the batch
  draw(SpriteBatch batch) {
    for (Particle particle in particles) {
      batch.color = particle.color;
      batch.draw(particle.texture, particle.position.x - (particle.texture.width * particle.scale * 0.5), particle.position.y - (particle.texture.height * particle.scale * 0.5),
          scaleX: particle.scale,
          scaleY: particle.scale,
          angle: radians(particle.rotation));
    }
  }

  // Spawns a wave of particles, using the effect's spawn type
  spawnWave() {
    switch(effect.type) {
      case SpawnType.point:
        spawnParticle(pos);
        break;
      case SpawnType.burst:
        double angle = 360 - effect.burstStartAngle;
        for(int i = 0; i < effect.burstParticlesPerWave; i++) {
          angle += effect.burstParticleSpacing;
          spawnParticle(pos, angle);
        }
        break;
      case SpawnType.circle:
        double angle = _randBetween(-pi, pi);
        spawnParticle(pos + effect.circlePos + (_angleToVec(angle) * effect.circleRadius * rand.nextDouble()));
        break;
      case SpawnType.rect:
        spawnParticle(pos + effect.rectPos + Vector2(effect.rectSize.x * rand.nextDouble(), effect.rectSize.y * rand.nextDouble()));
        break;
      case SpawnType.ring:
        double angle = _randBetween(-pi, pi);
        spawnParticle(pos + effect.circlePos + (Vector2(cos(angle), sin(angle)) * _randBetween(effect.minRingRadius, effect.maxRingRadius)));
        break;
    }
  }

  // Spawns a single particle at [pos] moving in direction [angle]
  spawnParticle(Vector2 pos, [double angle]) {
    if(particles.length < effect.maxParticles) {
      Particle particle = new Particle(effect);
      particle.texture = effect.texture;
      particle.color = effect.colorStart.clone();
      particle.rotation = -(angle != null ? angle : _randBetween(effect.minStartRotation, effect.maxStartRotation));
      particle.rotationSpeed = _randBetween(effect.minRotationSpeed, effect.maxRotationSpeed);
      particle.scaleMod = _randBetween(1.0, effect.scaleMultiplier);
      particle.scale = effect.scaleStart * particle.scaleMod;
      particle.speedMod = _randBetween(1.0, effect.speedMultiplier);
      particle.speed = effect.speedStart * particle.speedMod;
      particle.lifetime = _randBetween(effect.minLifetime, effect.maxLifetime);
      particle.velocity = _angleToVec(radians(particle.rotation));
      particle.position = pos;
      particles.add(particle);
    }
  }

  double _randBetween(double min, double max) {
    return min + rand.nextDouble() * (max - min);
  }

}

// A single particle. Should generally not be used alone.
class Particle {
  ParticleEffect effect;

  Texture texture;

  Vector4 color;

  Vector2 position;
  Vector2 velocity;

  double scale;
  double scaleMod;

  double speed;
  double speedMod;

  double rotation;
  double rotationSpeed;

  double lifetime;

  double _time = 0;

  Particle(this.effect) {}

  void update(double delta) {
    _time += delta;

    color += (effect.colorEnd - effect.colorStart) * (delta / lifetime);

    rotation -= rotationSpeed * delta;

    scale += (effect.scaleEnd - effect.scaleStart) * scaleMod * (delta / lifetime);

    speed += (effect.speedEnd - effect.speedStart) * speedMod * (delta / lifetime);

    if(effect.acceleration != Vector2.zero()) {
     velocity += effect.acceleration * delta;
     if(velocity.length > effect.maxSpeed) {
       velocity.length = effect.maxSpeed;
     }
    } else {
      velocity = velocity.normalized() * speed;
    }
    position += velocity * delta;
  }
}

// Converts an angle in radians to a vector of length 1
Vector2 _angleToVec(double angle) {
  Vector2 result = Vector2(cos(angle), sin(angle));
  if(result.x.abs() < 0.0001) {
    result.x = 0;
  }
  if(result.y.abs() < 0.0001) {
    result.y = 0;
  }
  return result;
}
