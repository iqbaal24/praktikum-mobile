
import 'game_object.dart';

abstract class Obstacle extends GameObject {
  Obstacle(double x, double y) : super(x, y);

  void move();
}
