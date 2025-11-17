import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Particle effect that shows when player taps
class TapParticle extends PositionComponent {
  static const double _lifetime = 0.5;
  static const int _particleCount = 8;

  final List<_Particle> _particles = [];
  double _elapsed = 0.0;

  TapParticle({
    required Vector2 position,
  }) : super(position: position, size: Vector2.all(100));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create particles in a burst pattern
    final random = Random();
    for (int i = 0; i < _particleCount; i++) {
      final angle = (i / _particleCount) * 2 * pi;
      final speed = 100.0 + random.nextDouble() * 50.0;

      _particles.add(
        _Particle(
          velocity: Vector2(
            cos(angle) * speed,
            sin(angle) * speed,
          ),
          color: _getRandomColor(),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _elapsed += dt;

    // Update all particles
    for (final particle in _particles) {
      particle.position.add(particle.velocity * dt);
      particle.velocity.scale(0.95); // Slow down
    }

    // Remove when lifetime exceeded
    if (_elapsed >= _lifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final alpha = (1.0 - (_elapsed / _lifetime)).clamp(0.0, 1.0);

    for (final particle in _particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(alpha)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        particle.position.toOffset(),
        4.0,
        paint,
      );
    }
  }

  Color _getRandomColor() {
    final colors = [
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.pink,
      Colors.purple,
    ];
    return colors[Random().nextInt(colors.length)];
  }
}

class _Particle {
  Vector2 position = Vector2.zero();
  Vector2 velocity;
  Color color;

  _Particle({
    required this.velocity,
    required this.color,
  });
}
