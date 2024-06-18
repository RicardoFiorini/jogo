class SpaceBattlePhase {
  int playerX, playerY;
  int playerSize = 40;
  int playerSpeed = 5;
  int bulletSpeed = 10;
  int missileSpeed = 5;
  int ammo = 10;
  int missiles = 3;
  int playerHealth = 100;
  int zarakHealth = 100;
  boolean finalBattle = false;
  boolean zarakDefeated = false;
  ArrayList<Bullet> bullets;
  ArrayList<Missile> missilesList;
  ArrayList<Enemy> enemies;
  ArrayList<Shockwave> shockwaves;
  ArrayList<Item> items;
  int enemySpawnRate = 60; // A cada 60 frames (1 segundo)
  int frameCount = 0;
  int enemiesKilled = 0;
  int enemiesToKill = 5; // Número de inimigos que precisam ser mortos para iniciar a luta com Zarak

  boolean showPopup = false;
  boolean showGameOverPopup = false;
  String popupMessage = "";
  String buttonText = "";

  Zarak zarak;
  ArrayList<Bullet> zarakBullets;

  PImage playerImage;
  PImage enemyImage;
  PImage zarakImage;

  void init() {
    playerX = width / 2;
    playerY = height - 100;
    bullets = new ArrayList<Bullet>();
    missilesList = new ArrayList<Missile>();
    enemies = new ArrayList<Enemy>();
    shockwaves = new ArrayList<Shockwave>();
    items = new ArrayList<Item>();
    zarakBullets = new ArrayList<Bullet>();

    // Carregar imagens
    playerImage = loadImage("nave.png");
    enemyImage = loadImage("nave-inimiga.png");
    zarakImage = loadImage("zarak.png");
  }

  void start() {
    loop();
  }

  void draw() {
    background(0);
    drawBackground();
    drawPlayer();
    drawBullets();
    drawMissiles();
    drawEnemies();
    drawShockwaves();
    drawItems();
    drawScore();
    drawAmmo();
    drawHealth();
    drawMissilesCount();

    if (finalBattle && !zarakDefeated) {
      drawZarak();
      drawZarakBullets();
    }

    if (showPopup) {
      drawPopup(popupMessage, buttonText);
    } else if (showGameOverPopup) {
      drawGameOverPopup("Game Over! Você foi destruído.");
    } else {
      updatePlayer();
      updateBullets();
      updateMissiles();
      updateEnemies();
      updateShockwaves();
      updateItems();
      checkCollisions();
      frameCount++;
      if (frameCount % enemySpawnRate == 0 && !finalBattle) {
        spawnEnemy();
      }
      if (finalBattle) {
        updateZarak();
        checkZarakCollisions();
        updateZarakBullets();
      }
    }
  }

  void keyPressed() {
    if (key == 'a' || key == 'A') {
      shoot();
    } else if (key == 's' || key == 'S') {
      shootMissile();
    }
  }

  void mousePressed() {
    if (showPopup) {
      if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showPopup = false;
        goToMainMenu();
      }
    } else if (showGameOverPopup) {
      if (mouseX > width / 2 - 150 && mouseX < width / 2 - 50 &&
          mouseY > height / 2 + 50 && mouseX < height / 2 + 100) {
        showGameOverPopup = false;
        resetGame();
      }
      if (mouseX > width / 2 + 50 && mouseX < width / 2 + 150 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showGameOverPopup = false;
        goToMainMenu();
      }
    }
  }

  void drawBackground() {
    fill(0, 0, 50);
    rect(0, 0, width, height); // Background azul escuro
  }

  void drawPlayer() {
    image(playerImage, playerX - playerSize / 2, playerY - playerSize / 2, playerSize, playerSize);
  }

  void drawBullets() {
    fill(255, 255, 0);
    for (Bullet bullet : bullets) {
      bullet.display();
    }
  }

  void drawMissiles() {
    fill(255, 0, 0);
    for (Missile missile : missilesList) {
      missile.display();
    }
  }

  void drawEnemies() {
    for (Enemy enemy : enemies) {
      enemy.display();
    }
  }

  void drawShockwaves() {
    for (Shockwave shockwave : shockwaves) {
      shockwave.display();
    }
  }

  void drawItems() {
    for (Item item : items) {
      item.display();
    }
  }

  void drawZarak() {
    image(zarakImage, zarak.x - 50, zarak.y - 50, 100, 100); // Nave maior de Zarak
  }

  void drawZarakBullets() {
    fill(255, 0, 0);
    for (Bullet bullet : zarakBullets) {
      bullet.display();
    }
  }

  void drawScore() {
    fill(255);
    textSize(24);
    textAlign(RIGHT, CENTER);
    text("Score: " + GameState.getScore(), width - 20, 20);
  }

  void drawAmmo() {
    fill(255);
    textSize(24);
    textAlign(RIGHT, CENTER);
    text("Ammo: " + ammo, width - 20, 50);
  }

  void drawMissilesCount() {
    fill(255);
    textSize(24);
    textAlign(RIGHT, CENTER);
    text("Missiles: " + missiles, width - 20, 80);
  }

  void drawHealth() {
    fill(255);
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Health: " + playerHealth, 20, 20);
    if (finalBattle) {
      text("Zarak Health: " + zarakHealth, 20, 50);
    }
  }

  void updatePlayer() {
    if (keyPressed) {
      if (keyCode == LEFT) {
        playerX -= playerSpeed;
      }
      if (keyCode == RIGHT) {
        playerX += playerSpeed;
      }
      if (keyCode == UP) {
        playerY -= playerSpeed;
      }
      if (keyCode == DOWN) {
        playerY += playerSpeed;
      }
    }
    playerX = constrain(playerX, playerSize / 2, width - playerSize / 2);
    playerY = constrain(playerY, playerSize / 2, height - playerSize / 2);
  }

  void updateBullets() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();
      if (bullet.y < 0) {
        bullets.remove(i);
      }
    }
  }

  void updateMissiles() {
    for (int i = missilesList.size() - 1; i >= 0; i--) {
      Missile missile = missilesList.get(i);
      missile.move();
      if (missile.y < 0) {
        missilesList.remove(i);
      }
    }
  }

  void updateShockwaves() {
    for (int i = shockwaves.size() - 1; i >= 0; i--) {
      Shockwave shockwave = shockwaves.get(i);
      shockwave.update();
      if (shockwave.isFinished()) {
        shockwaves.remove(i);
      }
    }
  }

  void updateEnemies() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      enemy.move();
      if (enemy.y > height) {
        enemies.remove(i);
      }
    }
  }

  void updateItems() {
    for (int i = items.size() - 1; i >= 0; i--) {
      Item item = items.get(i);
      if (item.y > height) {
        items.remove(i);
      }
    }
  }

  void updateZarak() {
    if (zarak != null) {
      zarak.move();
      zarak.shoot();
    }
  }

  void updateZarakBullets() {
    for (int i = zarakBullets.size() - 1; i >= 0; i--) {
      Bullet bullet = zarakBullets.get(i);
      bullet.move();
      if (bullet.y > height) {
        zarakBullets.remove(i);
      }
    }
  }

  void checkCollisions() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (dist(playerX, playerY, enemy.x, enemy.y) < playerSize / 2 + 10) {
        playerHealth -= 10;
        enemies.remove(i);
        if (playerHealth <= 0) {
          gameOver();
        }
      }
    }

    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy enemy = enemies.get(j);
        if (dist(bullet.x, bullet.y, enemy.x, enemy.y) < playerSize / 2) {
          bullets.remove(i);
          enemies.remove(j);
          GameState.addScore(10);
          items.add(new Item(enemy.x, enemy.y, int(random(1, 3))));
          enemiesKilled++;
          if (enemiesKilled >= enemiesToKill && !finalBattle) {
            startFinalBattle();
          }
          break;
        }
      }
    }

    for (int i = missilesList.size() - 1; i >= 0; i--) {
      Missile missile = missilesList.get(i);
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy enemy = enemies.get(j);
        if (dist(missile.x, missile.y, enemy.x, enemy.y) < playerSize / 2) {
          missilesList.remove(i);
          createShockwave(enemy.x, enemy.y);
          break;
        }
      }
    }

    for (int i = items.size() - 1; i >= 0; i--) {
      Item item = items.get(i);
      if (dist(playerX, playerY, item.x, item.y) < playerSize / 2) {
        if (item.type == 1) {
          ammo += 5;
        } else if (item.type == 2) {
          missiles += 1;
        }
        items.remove(i);
      }
    }
  }

  void checkZarakCollisions() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      if (dist(bullet.x, bullet.y, zarak.x, zarak.y) < 50) { // Ajuste para colisão com a nave maior de Zarak
        bullets.remove(i);
        zarakHealth -= 10;
        if (zarakHealth <= 0) {
          zarakDefeated = true;
          showPopup = true;
          popupMessage = "Você derrotou Zarak! Parabéns!";
          buttonText = "Menu Inicial";
        }
      }
    }

    for (int i = missilesList.size() - 1; i >= 0; i--) {
      Missile missile = missilesList.get(i);
      if (dist(missile.x, missile.y, zarak.x, zarak.y) < 50) { // Ajuste para colisão com a nave maior de Zarak
        missilesList.remove(i);
        zarakHealth -= 20;
        createShockwave(zarak.x, zarak.y);
        if (zarakHealth <= 0) {
          zarakDefeated = true;
          showPopup = true;
          popupMessage = "Você derrotou Zarak! Parabéns!";
          buttonText = "Menu Inicial";
        }
      }
    }
  }

  void createShockwave(int x, int y) {
    shockwaves.add(new Shockwave(x, y));
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (dist(x, y, enemy.x, enemy.y) < 100) {
        enemies.remove(i);
        GameState.addScore(5);
      }
    }
  }

  void shoot() {
    if (ammo > 0) {
      bullets.add(new Bullet(playerX, playerY));
      ammo--;
    }
  }

  void shootMissile() {
    if (missiles > 0) {
      missilesList.add(new Missile(playerX, playerY));
      missiles--;
    }
  }

  void drawPopup(String message, String buttonText) {
    fill(50, 50, 50, 200);
    rect(width / 4, height / 3, width / 2, height / 3);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(message, width / 2, height / 2 - 20);
    fill(100, 100, 255);
    rect(width / 2 - 100, height / 2 + 50, 200, 50);
    fill(255);
    textSize(24);
    text(buttonText, width / 2, height / 2 + 75);
  }

  void drawGameOverPopup(String message) {
    fill(50, 50, 50, 200);
    rect(width / 4, height / 3, width / 2, height / 3);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(message, width / 2, height / 2 - 20);
    
    fill(100, 100, 255);
    rect(width / 2 - 150, height / 2 + 50, 100, 50);
    fill(255);
    textSize(24);
    text("Reiniciar", width / 2 - 100, height / 2 + 75);
    
    fill(100, 100, 255);
    rect(width / 2 + 50, height / 2 + 50, 100, 50);
    fill(255);
    textSize(24);
    text("Menu Inicial", width / 2 + 100, height / 2 + 75);
  }

  void resetGame() {
    playerX = width / 2;
    playerY = height - 100;
    playerHealth = 100;
    ammo = 10;
    missiles = 3;
    bullets.clear();
    missilesList.clear();
    enemies.clear();
    shockwaves.clear();
    items.clear();
    GameState.reset();
    init();
    loop();
  }

  void goToMainMenu() {
    MainMenu menu = new MainMenu();
    menu.setup();
    drawSpaceBattlePhase = false;
    drawMenu = true;
  }

  void spawnEnemy() {
    enemies.add(new Enemy(int(random(width)), -20));
  }

  void startFinalBattle() {
    finalBattle = true;
    zarak = new Zarak(width / 2, 50);
  }

  void gameOver() {
    println("Game Over!");
    showGameOverPopup = true;
  }

  class Bullet {
    int x, y;

    Bullet(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      y -= bulletSpeed;
    }

    void display() {
      fill(255, 255, 0);
      rect(x - 2, y, 4, 10);
    }
  }

  class Missile {
    int x, y;

    Missile(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      y -= missileSpeed;
    }

    void display() {
      fill(255, 0, 0);
      rect(x - 5, y - 15, 10, 30);
    }
  }

  class Shockwave {
    int x, y;
    int radius;
    int maxRadius;
    int speed;
    boolean finished;

    Shockwave(int x, int y) {
      this.x = x;
      this.y = y;
      this.radius = 0;
      this.maxRadius = 100;
      this.speed = 5;
      this.finished = false;
    }

    void update() {
      if (radius < maxRadius) {
        radius += speed;
      } else {
        finished = true;
      }
    }

    void display() {
      noFill();
      stroke(255, 0, 0);
      strokeWeight(3);
      ellipse(x, y, radius * 2, radius * 2);
    }

    boolean isFinished() {
      return finished;
    }
  }

  class Enemy {
    int x, y;
    int speed = 3;

    Enemy(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      y += speed;
    }

    void display() {
      image(enemyImage, x - 10, y - 10, 20, 20);
    }
  }

  class Item {
    int x, y;
    int type; // 1 for ammo, 2 for missiles

    Item(int x, int y, int type) {
      this.x = x;
      this.y = y;
      this.type = type;
    }

    void display() {
      if (type == 1) {
        fill(0, 255, 255);
        ellipse(x, y, 10, 10);
      } else if (type == 2) {
        fill(255, 0, 255);
        ellipse(x, y, 10, 10);
      }
    }
  }

  class Zarak {
    int x, y;
    int speed = 2;
    int fireRate = 60;
    int fireCount = 0;

    Zarak(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      if (fireCount % 120 < 60) {
        x += speed;
      } else {
        x -= speed;
      }
      if (x < 50 || x > width - 50) {
        speed *= -1;
      }
    }

    void shoot() {
      fireCount++;
      if (fireCount % fireRate == 0) {
        zarakBullets.add(new Bullet(x, y + 50)); // Ajuste para disparar para baixo
      }
    }

    void display() {
      image(zarakImage, x - 50, y - 50, 100, 100); // Nave maior de Zarak
    }
  }
}
