class Enemy {
  String name;
  int health;

  Enemy(String name, int health) {
    this.name = name;
    this.health = health;
  }

  boolean isDefeated() {
    return health <= 0;
  }
}
