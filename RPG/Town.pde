class Town {

  Shop shop = new Shop();
  Inn inn = new Inn();
  AdventureGuild adventureGuild = new AdventureGuild();
  
  class Shop {
    Weapon[] weaponsForSale = {
      new Weapon("Rusty Sword", 3, 40.0f), // Name, damage, price
      new Weapon("Iron Sword", 8, 250.0f),
      new Weapon("Katana", 15, 1500.0f),
      new Weapon("Death Scythe", 23, 3000.0f),
      new Weapon("Zeus' Dual-Axe", 29, 5000.0f)
    };

    void displayWeapons() {
      println("Weaponsmith James: Hello there young lad whatcha looking for");
      println("Weaponsmith James: I've got these weapons for sale");
      for (int i = 0; i < weaponsForSale.length; i++) {
        println((i + 1) + ". " + weaponsForSale[i].name + " - Attack: " + weaponsForSale[i].damage + " - Price: " +weaponsForSale[i].price);
      }
    }

    void buyWeapon(int weaponIndex) {
      if (weaponIndex >= 0 && weaponIndex < town.shop.weaponsForSale.length) {
        Weapon selectedWeapon = town.shop.weaponsForSale[weaponIndex];
        if (player.gold >= selectedWeapon.price) {
          player.addWeaponToInventory(selectedWeapon); // Adds the weapon to the inventory
          player.spendGold(selectedWeapon.price); // Deducts the weapon's cost from the player's gold
          println("You've bought a " + selectedWeapon.name + " for " + selectedWeapon.price + " gold.");
          println("Gold remaining: " + player.gold);
        } else {
          println("You don't have enough gold.");
        }
      } else {
        println("Invalid weapon choice.");
      }
    }
  }

  class Inn {
    final float INN_COST = 10.0f;

    void stayAtInn() {
      if (player.gold >= INN_COST) {
        player.spendGold(INN_COST);
        player.restoreHealth(100); // Assuming this restores the player's health to full.
        println("You have rested at the inn. Your health is fully restored.");
        println("Gold remaining: " + player.gold);
      } else {
        println("You do not have enough gold to stay at the inn.");
      }
    }
  }

  class AdventureGuild {
    void postQuest() {
      System.out.println("Quest posted: Defeat the Goblin King!");
    }
  }
}
