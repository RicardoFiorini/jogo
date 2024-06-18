class PlatformPhase {
  int playerX, playerY;
  int playerSize = 40;
  int groundLevel;
  int gravity = 1;
  int jumpStrength = -20;
  int yVelocity = 0;
  int moveSpeed = 5;
  boolean isJumping = false;
  int score = 0;
  int ammo = 0;
  int[][] items;
  int[][] itemPositions = {
    {300, height - 80},
    {600, height - 80},
    {900, height - 80},
    {1200, height - 220},
    {1500, height - 80},
    {1800, height - 80},
    {2100, height - 80},
    {2400, height - 220},
    {2700, height - 80},
    {3000, height - 80},
    {400, height - 80},
    {1100, height - 220},
    {2200, height - 80}
  };
  int[] itemTypes = {1, 2, 3, 1, 2, 3, 1, 2, 3, 1, 4, 4, 4};
  int numItems = itemPositions.length;
  ArrayList<Enemy> enemies;
  int[][] enemyPositions = {
    {500, height - 100},
    {1000, height - 100},
    {1500, height - 320},
    {2000, height - 100},
  };

  int[][] platformPositions = {
    {1200, height - 200},
    {1500, height - 300},
    {2400, height - 200},
    {1100, height - 200},
    {2200, height - 300}
  };

  ArrayList<Bullet> bullets;

  boolean showPopup = false;
  boolean showGameOverPopup = false;
  String popupMessage = "";
  String buttonText = "";

  PImage playerImage;
  PImage enemyImage;
  PImage weaponImage;

  void init() {
    playerX = 100;
    playerY = height - 100;
    groundLevel = height - 60;
    items = new int[numItems][3];
    enemies = new ArrayList<Enemy>();
    bullets = new ArrayList<Bullet>();

    playerImage = loadImage("arion.png");
    enemyImage = loadImage("inimigo.png");
    weaponImage = loadImage("arma.png");

    for (int i = 0; i < numItems; i++) {
      items[i][0] = itemPositions[i][0];
      items[i][1] = itemPositions[i][1];
      items[i][2] = itemTypes[i];
    }

    for (int i = 0; i < enemyPositions.length; i++) {
      int range = getPlatformRange(enemyPositions[i][0], enemyPositions[i][1]);
      if (!isOnPlatform(enemyPositions[i][0], enemyPositions[i][1])) {
        enemies.add(new Enemy(enemyPositions[i][0], enemyPositions[i][1], range));
      }
    }
  }

  void start() {
    loop();
  }

  void draw() {
    background(135, 206, 235);
    drawBackground(playerX);
    fill(34, 139, 34);
    rect(0, groundLevel, width, height - groundLevel);

    pushMatrix();
    translate(-playerX + 100, 0);

    drawItems();
    drawEnemies();
    drawPlatforms();
    drawCastle();
    drawBullets();

    popMatrix();

    drawPlayer();
    drawScoreAndAmmo();

    if (showPopup) {
      drawPopup(popupMessage, buttonText);
    } else if (showGameOverPopup) {
      drawGameOverPopup("Game Over! Você foi pego por um inimigo.");
    } else {
      updatePlayer();
      moveEnemies();
      updateBullets();
      checkCollisions();
    }
  }

  void keyPressed() {
    if (key == ' ' && !isJumping) {
      yVelocity = jumpStrength;
      isJumping = true;
    } else if (key == 'a' || key == 'A') {
      shoot();
    }
  }

  void keyReleased() {
    // O método keyReleased está vazio, pois a movimentação será verificada continuamente no método updatePlayer
  }

  void mousePressed() {
    if (showPopup) {
      if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showPopup = false;
        nextPhase();
      }
    } else if (showGameOverPopup) {
      if (mouseX > width / 2 - 150 && mouseX < width / 2 - 50 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
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

  void drawBackground(int playerX) {
    for (int i = 0; i < 5; i++) {
      drawCloud((int)((200 + 600 * i) - playerX * 0.5), 100);
    }

    for (int i = 0; i < 20; i++) {
      drawTree((300 * i + 150) - playerX, groundLevel);
    }
  }

  void drawCloud(int x, int y) {
    fill(255);
    noStroke();
    ellipse(x, y, 100, 60);
    ellipse(x + 30, y + 10, 80, 50);
    ellipse(x - 30, y + 10, 80, 50);
    ellipse(x, y + 20, 60, 40);
  }

  void drawTree(int x, int y) {
    fill(139, 69, 19);
    rect(x - 30, y - 200, 60, 200);

    fill(34, 139, 34);
    ellipse(x, y - 250, 150, 150);
    ellipse(x - 60, y - 210, 150, 150);
    ellipse(x + 60, y - 210, 150, 150);
    ellipse(x - 40, y - 170, 150, 150);
    ellipse(x + 40, y - 170, 150, 150);
  }

  void drawPlatforms() {
    fill(128, 128, 128);
    for (int[] pos : platformPositions) {
      rect(pos[0], pos[1], 150, 20);
      fill(105, 105, 105);
      rect(pos[0] + 10, pos[1] + 5, 130, 10);
      fill(128, 128, 128);
    }
  }

  void drawCastle() {
    fill(169, 169, 169);

    rect(2850, groundLevel - 300, 300, 300);

    rect(2800, groundLevel - 350, 50, 350);
    rect(3150, groundLevel - 350, 50, 350);

    fill(105, 105, 105);
    triangle(2800, groundLevel - 350, 2825, groundLevel - 400, 2850, groundLevel - 350);
    triangle(3150, groundLevel - 350, 3175, groundLevel - 400, 3200, groundLevel - 350);

    fill(139, 69, 19);
    rect(2950, groundLevel - 100, 100, 100);

    fill(255);
    rect(2900, groundLevel - 250, 20, 40);
    rect(3100, groundLevel - 250, 20, 40);

    fill(0);
    rect(2810, groundLevel - 370, 30, 20);
    rect(3160, groundLevel - 370, 30, 20);
  }

  void drawPlayer() {
    image(playerImage, 100, playerY, playerSize, playerSize);
  }

  void drawItems() {
    for (int i = 0; i < numItems; i++) {
      switch (items[i][2]) {
        case 1:
          fill(0, 255, 0);
          ellipse(items[i][0], items[i][1], 20, 20);
          break;
        case 2:
          fill(0, 0, 255);
          ellipse(items[i][0], items[i][1], 20, 20);
          break;
        case 3:
          fill(255, 215, 0);
          ellipse(items[i][0], items[i][1], 20, 20);
          break;
        case 4:
          image(weaponImage, items[i][0] - 10, items[i][1] - 10, 20, 20);
          break;
      }
    }
  }

  void drawEnemies() {
    for (Enemy enemy : enemies) {
      image(enemyImage, enemy.x, enemy.y, playerSize, playerSize);
    }
  }

  void drawBullets() {
    fill(255, 255, 0);
    for (Bullet bullet : bullets) {
      rect(bullet.x, bullet.y, 10, 5);
    }
  }

  void drawScoreAndAmmo() {
    fill(0);
    textSize(32);
    textAlign(RIGHT, CENTER);
    text("Score: " + GameState.getScore(), width - 20, height - 50);
    text("Ammo: " + ammo, width - 20, height - 20);
  }

  void updatePlayer() {
    yVelocity += gravity;
    playerY += yVelocity;

    if (keyPressed) {
      if (keyCode == LEFT) {
        playerX -= moveSpeed;
      }
      if (keyCode == RIGHT) {
        playerX += moveSpeed;
      }
    }

    if (playerY >= groundLevel - playerSize) {
      playerY = groundLevel - playerSize;
      yVelocity = 0;
      isJumping = false;
    }

    for (int[] pos : platformPositions) {
      if (playerX + playerSize > pos[0] && playerX < pos[0] + 150 &&
          playerY + playerSize >= pos[1] && playerY + playerSize <= pos[1] + 20 &&
          yVelocity > 0) {
        playerY = pos[1] - playerSize;
        yVelocity = 0;
        isJumping = false;
      }
    }

    playerX = constrain(playerX, 0, 3000 - playerSize);

    if (playerX >= 2900 && playerY >= groundLevel - 300) {
      showPopup = true;
      popupMessage = "Fase completa! Preparando para a próxima fase...";
      buttonText = "Próxima Fase";
    }
  }

  void moveEnemies() {
    for (Enemy enemy : enemies) {
      enemy.move();
    }
  }

  void updateBullets() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();
      if (bullet.x > playerX + width || bullet.x < playerX - width) {
        bullets.remove(i);
      }
    }
  }

  void checkCollisions() {
    for (int i = 0; i < numItems; i++) {
      if (dist(playerX, playerY, items[i][0], items[i][1]) < playerSize) {
        if (items[i][2] == 4) {
          ammo += 5;
        } else {
          GameState.addScore(getItemScore(items[i][2]));
        }
        items[i][0] = -100;
      }
    }

    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (dist(playerX, playerY, enemy.x, enemy.y) < playerSize) {
        gameOver();
      }
      for (int j = bullets.size() - 1; j >= 0; j--) {
        Bullet bullet = bullets.get(j);
        if (dist(bullet.x, bullet.y, enemy.x, enemy.y) < playerSize) {
          enemies.remove(i);
          bullets.remove(j);
          break;
        }
      }
    }
  }

  int getItemScore(int itemType) {
    switch (itemType) {
      case 1:
        return 10;
      case 2:
        return 20;
      case 3:
        return 50;
      default:
        return 0;
    }
  }

  void gameOver() {
    println("Game Over!");
    showGameOverPopup = true;
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

  void nextPhase() {
    GameState.currentLevel = 3;
    towerDefensePhase = new TowerDefensePhase();
    towerDefensePhase.init();
    towerDefensePhase.start();
    drawPlatformPhase = false;
    drawTowerDefensePhase = true;
  }

  void resetGame() {
    playerX = 100;
    playerY = height - 100;
    yVelocity = 0;
    isJumping = false;
    bullets.clear();
    ammo = 0;
    GameState.reset();
    init();
    loop();
  }

  void goToMainMenu() {
    MainMenu menu = new MainMenu();
    menu.setup();
    drawPlatformPhase = false;
    drawMenu = true;
  }

  void shoot() {
    if (ammo > 0) {
      bullets.add(new Bullet(playerX + playerSize, playerY + playerSize / 2));
      ammo--;
    }
  }

  int getPlatformRange(int enemyX, int enemyY) {
    for (int[] pos : platformPositions) {
      if (enemyX >= pos[0] && enemyX <= pos[0] + 150 &&
          enemyY >= pos[1] - 20 && enemyY <= pos[1] + 20) {
        return 150;
      }
    }
    return 100;
  }

  boolean isOnPlatform(int x, int y) {
    for (int[] pos : platformPositions) {
      if (x >= pos[0] && x <= pos[0] + 150 &&
          y >= pos[1] - 20 && y <= pos[1] + 20) {
        return true;
      }
    }
    return false;
  }

  class Enemy {
    int x, y;
    int speed = 2;
    int leftBound, rightBound;
    boolean movingRight = true;

    Enemy(int x, int y, int range) {
      this.x = x;
      this.y = y;
      this.leftBound = x - range / 2;
      this.rightBound = x + range / 2;
    }

    void move() {
      if (movingRight) {
        x += speed;
        if (x >= rightBound) {
          movingRight = false;
        }
      } else {
        x -= speed;
        if (x <= leftBound) {
          movingRight = true;
        }
      }
    }
  }

  class Bullet {
    int x, y;
    int speed = 10;

    Bullet(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      x += speed;
    }
  }
}
