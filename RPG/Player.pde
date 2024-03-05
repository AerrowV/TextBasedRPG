class Player {
  String name;
  int health = 100;
  float gold = 0.0f;
  ArrayList<String> inventory = new ArrayList<String>();
  Weapon equippedWeapon;
  ArrayList<Weapon> weaponInventory = new ArrayList<Weapon>();

  Player(String name) {
    this.name = name;
    this.equippedWeapon = new Weapon("Fist", 1, 0f); // Default weapon
  }

  void addToInventory(String item) {
    inventory.add(item);
    println("I the King of Eldoria will bestow upon you a Holy Sword in order for you to defeat the Demon King. We implore you please save us!");
  }

  void addWeaponToInventory(Weapon weapon) {
    weaponInventory.add(weapon);
    println(name + " added " + weapon.name + " to their weapon inventory.");
  }

  void equipWeaponByIndex(int index) {
    if (index >= 0 && index < weaponInventory.size()) {
      equippedWeapon = weaponInventory.get(index);
      println(name + " has equipped " + equippedWeapon.name);
    } else {
      println("Invalid weapon selection.");
    }
  }
  void equipWeaponByName(String weaponName) {
    for (Weapon weapon : weaponInventory) {
      if (weapon.name.equalsIgnoreCase(weaponName)) {
        equippedWeapon = weapon;
        println(name + " has equipped " + weapon.name);
        return;
      }
    }
    println("Weapon not found in inventory.");
  }

  void restoreHealth(int amount) {
    health = Math.min(health + amount, 100);
    println(name + "'s health has been restored to " + health);
  }

  void addGold(float amount) {
    gold += amount;
    println(name + " has found " + amount + " gold.");
  }

  boolean spendGold(float amount) {
    if (gold >= amount) {
      gold -= amount;
      println(name + " has spent " + amount + " gold.");
      return true;
    } else {
      println("Not enough gold!");
      return false;
    }
  }

  String formatInventory() {
    StringBuilder inventoryList = new StringBuilder();
    for (Weapon weapon : weaponInventory) {
      inventoryList.append(weapon.name).append(", ");
    }
    // Remove the last comma and space if necessary
    if (inventoryList.length() > 0) inventoryList.setLength(inventoryList.length() - 2);
    return inventoryList.toString();
  }

  void restart() {
    currentEnemy = null;
    health = 100;
    gold = 0.0f;
    inventory.clear();
    equippedWeapon = new Weapon("Fist", 1, 0f);
    println(name + " has been restarted with default settings.");
  }
}
