
import 'game_object.dart';
import 'dino.dart';
import 'cactus.dart';

void main() {
  var dino = Dino(0, 0);
  var cactus = Cactus(10, 0);

  List<GameObject> gameObjects = [dino, cactus];

  for (var obj in gameObjects) {
    obj.update();
    obj.render();
  }

  dino.jump();
}
