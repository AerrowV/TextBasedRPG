PImage goblinAscii, shopAscii, townAscii, ogreAscii, startAscii, innAscii;
Player player = new Player("Hero");
Town town = new Town();
String gameState = "start";
String playerAction = "";
Enemy currentEnemy;

void setup() {
  size(800, 600);
  println("Welcome Hero from another world!");
  player.addToInventory("Holy Sword"); // Adding as an item, not as a weapon. Ensure to add correctly.

  // Add "Holy Sword" to weapon inventory directly if not already done
  Weapon holySword = new Weapon("Holy Sword", 10, 99999.0f); // Assuming 10 is the damage value
  player.addWeaponToInventory(holySword);
  goblinAscii = loadImage("asciigoblin.png");
  shopAscii = loadImage("asciishop.png");
  townAscii = loadImage("asciitown.png");
  ogreAscii = loadImage("ogreascii.png");
  startAscii = loadImage("asciistart.png");
  innAscii = loadImage("asciiinn.png");
}
void draw() {
  background(0);
  fill(255);
  displayGameInfo();
  displayCurrentAction();
  handleGameState();
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    processPlayerAction();
    playerAction = ""; // Reset action after processing
  } else if (key == BACKSPACE && playerAction.length() > 0) {
    playerAction = playerAction.substring(0, playerAction.length() - 1);
  } else if (key >= 32 && key <= 126) {
    playerAction += key; // Append character to player action
  }
}

void processPlayerAction() {
  switch (gameState) {
  case "start":
  case "gameOver":
    processStartOrGameOverState();
    break;
  case "encounter":
    processEncounterState();
    break;
  case "inTown":
    processInTownState();
    break;
  case "atShop":
    processAtShopState();
    break;
    // Consider adding other states here as necessary
  }
  postProcessAction();
}

void processStartOrGameOverState() {
  if (playerAction.equalsIgnoreCase("explore")) {
    if (gameState == "gameOver") {
      player.restart();
      gameState = "start";
    } else {
      gameState = "exploring";
    }
  } else if (playerAction.equalsIgnoreCase("town")) gameState = "inTown";
  else if (playerAction.equalsIgnoreCase("quit")) exit();
}

void processEncounterState() {
  if (playerAction.equalsIgnoreCase("fight")) {
    gameState = "combat";
  } else if (playerAction.equalsIgnoreCase("run")) {
    escapeEncounter();
  }
}

void processInTownState() {
  if (playerAction.equalsIgnoreCase("shop")) gameState = "atShop";
  else if (playerAction.equalsIgnoreCase("inn")) {
    town.inn.stayAtInn();
  } else if (playerAction.equalsIgnoreCase("guild")) {
    town.adventureGuild.postQuest();
  } else if (playerAction.equalsIgnoreCase("leave")) {
    gameState = "start";
    println("Leaving town...");
  }
}

void processAtShopState() {
  if (playerAction.matches("\\d+")) {
    buyWeaponByIndex();
  } else if (playerAction.startsWith("equip ")) {
    equipWeaponByName();
  } else if (playerAction.equalsIgnoreCase("leave")) {
    gameState = "inTown";
    println("Leaving weapon shop...");
    shopDisplayed = false; // Ensure the shop display is refreshed next time
  }
}

void buyWeaponByIndex() {
  int weaponIndex = Integer.parseInt(playerAction) - 1; // Convert input to 0-based index
  if (weaponIndex >= 0 && weaponIndex < town.shop.weaponsForSale.length) {
    Weapon selectedWeapon = town.shop.weaponsForSale[weaponIndex];
    if (player.gold >= selectedWeapon.price) { // Assuming there is a price field
      player.addWeaponToInventory(selectedWeapon);
      player.spendGold(selectedWeapon.price);
      println("Bought " + selectedWeapon.name + " for " + selectedWeapon.price + " gold.");
    } else {
      println("Not enough gold.");
    }
  } else {
    println("Invalid weapon.");
  }
}

void equipWeaponByName() {
  String weaponName = playerAction.substring(6); // Extract the weapon name
  player.equipWeaponByName(weaponName);
}

void postProcessAction() {
  if (playerAction.equalsIgnoreCase("town"))
    println("Welcome to the peaceful town of Eldoria. The air is fresh, and the people greet you with smiles.");

  playerAction = ""; // Clear action after processing to prepare for the next input
}


boolean shopDisplayed = false;

void handleGameState() {
  switch (gameState) {
  case "start":
    displayPrompt("Type 'explore' to start exploring the mysteries of the world, 'town' to visit the town, or 'quit' to exit game.");
    break;
  case "exploring":
    explore();
    break;
  case "encounter":
    encounter();
    break;
  case "combat":
    combat();
    break;
  case "gameOver":
    displayPrompt("Game Over. Type 'explore' to restart or 'quit' to exit game.");
    break;
  case "inTown":
    displayPrompt("You are in the town. Type 'shop' to visit the shop, 'inn' to rest, 'guild' to visit the guild, or 'leave' to explore.");
    break;
  case "atShop":
    if (!shopDisplayed) {
      town.shop.displayWeapons();
      shopDisplayed = true;
    }
    displayPrompt("Type the number of the weapon to buy, 'equip (weapon name)' to equip weapon, or 'leave' to return to town.");
    break;
  }
}

void explore() {
  float chance = random(1);
  if (chance < 0.5) {
    float foundGold = random(1, 99);
    player.addGold(foundGold);
    println("You found " + foundGold + " gold!");
    gameState = "start";
  } else {
    currentEnemy = (chance < 0.75) ? new Enemy("Goblin", 20) : new Enemy("Ogre", 50);
    currentEnemy = (chance < 0.1) ? new Enemy("Goblin King *", 100) : currentEnemy;
    println("You've encountered a " + currentEnemy.name + "! Type 'fight' to engage or 'run' to escape.");
    gameState = "encounter";
  }
}

void encounter() {
  displayPrompt("You've encountered a " + currentEnemy.name + "! Type 'fight' to engage or 'run' to escape.");
}

void combat() {
  if (currentEnemy.isDefeated()) {
    println(currentEnemy.name + " is defeated!");
    player.addGold(5);
    println("You found 5 gold on the enemy.");
    gameState = "start";
  } else {
    fightEnemy();
    if (player.health <= 0) gameState = "gameOver";
  }
}

void gameOver() {
  displayPrompt("Game Over. Type 'explore' to restart or 'quit' to exit game.");
  if (playerAction.equalsIgnoreCase("explore")) restartGame();
}

void restartGame() {
  player.restart(); // Assuming restart method resets player stats and inventory
  gameState = "start";
}

void displayGameInfo() {
  // Assuming the display is at the top-left corner. Adjust x, y coordinates as needed.
  textSize(16); // Adjust text size as needed
  fill(0, 255, 0); // White text
  text("| Health: " + player.health + " |", 10, 20);
  text("| Gold: " + player.gold + " |", 10, 40);
  text("| Equipped Weapon: " + player.equippedWeapon.name + ", Attack: " + player.equippedWeapon.damage + " |", 10, 60);
  text("| Inventory: " + player.formatInventory() + " |", 10, 80);

  if (gameState.equals("start")) {
    image(startAscii, 140, 110);
  }
  if (gameState.equals("inTown")) {
    image(townAscii, 60, 100);
  }
  if (gameState.equals("atShop")) {
    image(shopAscii, 260, 100);
  } else if (currentEnemy != null && currentEnemy.name.equals("Goblin")) {
    image(goblinAscii, 300, 140); // Display the image at the specified location
  } else if (currentEnemy != null && currentEnemy.name.equals("Ogre")) {
    image(ogreAscii, 240, 90); // Display the image at the specified location
  }
}

void displayPrompt(String message) {
  // Display prompt at the bottom of the window. Adjust positioning as necessary.
  textSize(16); // Adjust text size as needed
  fill(255, 0, 0); // Red text for emphasis
  text(message, 10, height - 30); // Adjust positioning as needed
}
void displayCurrentAction() {
  String inputDisplay = "Current Input: " + playerAction;
  text(inputDisplay, 10, height - 50);
}

void escapeEncounter() {
  float escapeChance = random(1);
  if (escapeChance < 0.5) {
    println("You successfully escaped from the " + currentEnemy.name + "!");
    gameState = "exploring"; // Ensure this state allows for a brief respite or decision on what to do next
  } else {
    println("You failed to escape and must fight the " + currentEnemy.name + "!");
    // gameState remains "combat" or similar to reflect the ongoing fight
  }
}

void fightEnemy() {

  int playerDamage = player.equippedWeapon.damage;
  currentEnemy.health -= playerDamage;
  println("You attack the " + currentEnemy.name + " dealing " + playerDamage + " damage.");

  // Check if enemy is defeated
  if (currentEnemy.isDefeated()) {
    println(currentEnemy.name + " is defeated!");
    currentEnemy = null;
    player.addGold(random(5, 39));
    println("You find 10 gold on the enemy.");
    gameState = "start";
    return;
  }

  // Enemy attacks player
  int enemyDamage = (int)random(9, 24); 
  player.health -= enemyDamage; 
  println("The " + currentEnemy.name + " attacks you back dealing " + enemyDamage + " damage.");

  // Check if player is defeated
  if (player.health <= 0) {
    player.health = 0;
    println("You have been defeated by the " + currentEnemy.name + ".");
    gameState = "gameOver";
  }
}
