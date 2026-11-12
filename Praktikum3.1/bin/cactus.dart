
import 'obstacle.dart';

class Cactus extends Obstacle {
  Cactus(double x, double y) : super(x, y);

  @override
  void move() {
    print('Cactus is moving to the left...');
  }

  @override
  void render() {
    print('Rendering Cactus at position ($x, $y)');
  }

  @override
  void update() {
    move();
  }
}
