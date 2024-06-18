class TowerDefensePhase {
  ArrayList<Tower> towers;
  ArrayList<Enemy> enemies;
  ArrayList<Shockwave> shockwaves;
  int castleHealth = 100;
  int waveNumber = 1;
  int maxWaves = 5; // Número máximo de ondas
  boolean showPopup = false;
  boolean showGameOverPopup = false;
  String popupMessage = "";
  String buttonText = "";
  
  PImage enemyImage;
  PImage grassImage;

  void init() {
    towers = new ArrayList<Tower>();
    enemies = new ArrayList<Enemy>();
    shockwaves = new ArrayList<Shockwave>();
    addTower(width / 2, height / 2);
    startWave();

    // Carregar imagens
    enemyImage = loadImage("inimigo.png");
    grassImage = loadImage("grass.jpg");
  }
  
  void start() {
    loop();
  }

  void draw() {
    background(135, 206, 235);
    drawBackground();
    drawTowers();
    drawEnemies();
    drawShockwaves();
    drawHealth();
    drawScore();

    if (showPopup) {
      drawPopup(popupMessage, buttonText);
    } else if (showGameOverPopup) {
      drawGameOverPopup("Game Over! O castelo foi destruído.");
    } else {
      updateEnemies();
      updateShockwaves();
      checkCollisions();
      if (castleHealth <= 0) {
        gameOver();
      }
      if (enemies.isEmpty() && !showPopup) {
        if (waveNumber < maxWaves) {
          waveNumber++;
          startWave();
        } else {
          showPopup = true;
          popupMessage = "Fase completa! Preparando para a próxima fase...";
          buttonText = "Próxima Fase";
        }
      }
    }
  }

  void keyPressed() {
    if (key == 's' || key == 'S') {
      shockwaves.add(new Shockwave(width / 2, height / 2));
    }
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
          mouseY > height / 2 + 50 && mouseX < height / 2 + 100) {
        showGameOverPopup = false;
        goToMainMenu();
      }
    } else {
      // Atira na direção do cursor do mouse
      for (Tower tower : towers) {
        tower.shoot(mouseX, mouseY);
      }
    }
  }

  void addTower(int x, int y) {
    towers.add(new Tower(x, y));
  }

  void startWave() {
    int numEnemies = waveNumber * 10; // Aumenta o número de inimigos por onda
    for (int i = 0; i < numEnemies; i++) {
      int spawnEdge = int(random(4));
      int spawnX = 0;
      int spawnY = 0;
      if (spawnEdge == 0) {
        spawnX = int(random(width));
        spawnY = 0;
      } else if (spawnEdge == 1) {
        spawnX = int(random(width));
        spawnY = height;
      } else if (spawnEdge == 2) {
        spawnX = 0;
        spawnY = int(random(height));
      } else if (spawnEdge == 3) {
        spawnX = width;
        spawnY = int(random(height));
      }
      enemies.add(new Enemy(spawnX, spawnY));
    }
  }

  void drawBackground() {
    for (int i = 0; i < width; i += 100) {
      for (int j = 0; j < height; j += 100) {
        image(grassImage, i, j, 100, 100); // Desenhar grama
      }
    }

    fill(169, 169, 169);
    rect(width / 2 - 50, height / 2 - 50, 100, 100); // Castle
  }

  void drawTowers() {
    for (Tower tower : towers) {
      tower.display();
      tower.updateBullets();
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

  void drawHealth() {
    fill(255);
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Castle Health: " + castleHealth, 10, 50);
  }

  void drawScore() {
    fill(255);
    textSize(24);
    textAlign(RIGHT, CENTER);
    text("Score: " + GameState.getScore(), width - 20, 50);
  }

  void updateEnemies() {
    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      enemy.move();
      if (dist(enemy.x, enemy.y, width / 2, height / 2) < 50) {
        castleHealth -= 5;
        enemies.remove(i);
      }
    }
  }

  void updateShockwaves() {
    for (int i = shockwaves.size() - 1; i >= 0; i--) {
      Shockwave shockwave = shockwaves.get(i);
      shockwave.expand();
      if (shockwave.isFinished()) {
        shockwaves.remove(i);
      }
    }
  }

  void checkCollisions() {
    for (Tower tower : towers) {
      for (int j = tower.bullets.size() - 1; j >= 0; j--) {
        Bullet bullet = tower.bullets.get(j);
        for (int i = enemies.size() - 1; i >= 0; i--) {
          Enemy enemy = enemies.get(i);
          if (dist(bullet.x, bullet.y, enemy.x, enemy.y) < 20) {
            GameState.addScore(10);
            enemies.remove(i);
            tower.bullets.remove(j);
            break;
          }
        }
      }
    }

    for (Shockwave shockwave : shockwaves) {
      for (int i = enemies.size() - 1; i >= 0; i--) {
        Enemy enemy = enemies.get(i);
        if (dist(shockwave.x, shockwave.y, enemy.x, enemy.y) < shockwave.radius) {
          enemy.pushAway(shockwave.x, shockwave.y);
        }
      }
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

  void resetGame() {
    castleHealth = 100;
    waveNumber = 1;
    enemies.clear();
    startWave();
    showGameOverPopup = false;
  }

  void goToMainMenu() {
    MainMenu menu = new MainMenu();
    menu.setup();
    drawTowerDefensePhase = false;
    drawMenu = true;
  }

  void nextPhase() {
    GameState.currentLevel = 4;
    spaceBattlePhase = new SpaceBattlePhase();
    spaceBattlePhase.init();
    spaceBattlePhase.start();
    drawTowerDefensePhase = false;
    drawSpaceBattlePhase = true;
  }

  class Tower {
    int x, y;
    ArrayList<Bullet> bullets;

    Tower(int x, int y) {
      this.x = x;
      this.y = y;
      bullets = new ArrayList<Bullet>();
    }

    void display() {
      fill(255, 0, 0);
      rect(x - 10, y - 10, 20, 20);
    }

    void shoot(int targetX, int targetY) {
      bullets.add(new Bullet(x, y, targetX, targetY));
    }

    void updateBullets() {
      for (Bullet bullet : bullets) {
        bullet.move();
        bullet.display();
      }
    }
  }

  class Enemy {
    int x, y;
    int speed = 2;

    Enemy(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void move() {
      x += (width / 2 - x) / dist(x, y, width / 2, height / 2) * speed;
      y += (height / 2 - y) / dist(x, y, width / 2, height / 2) * speed;
    }

    void pushAway(int centerX, int centerY) {
      float angle = atan2(y - centerY, x - centerX);
      x += cos(angle) * 50;
      y += sin(angle) * 50;
    }

    void display() {
      image(enemyImage, x - 10, y - 10, 20, 20);
    }
  }

  class Bullet {
    int x, y;
    int targetX, targetY;
    int speed = 5;

    Bullet(int x, int y, int targetX, int targetY) {
      this.x = x;
      this.y = y;
      this.targetX = targetX;
      this.targetY = targetY;
    }

    void move() {
      x += (targetX - x) / dist(x, y, targetX, targetY) * speed;
      y += (targetY - y) / dist(x, y, targetX, targetY) * speed;
    }

    void display() {
      fill(255, 255, 0);
      ellipse(x, y, 10, 10);
    }
  }

  class Shockwave {
    int x, y;
    int radius = 0;
    int maxRadius = 200;
    int expansionSpeed = 10;

    Shockwave(int x, int y) {
      this.x = x;
      this.y = y;
    }

    void expand() {
      if (radius < maxRadius) {
        radius += expansionSpeed;
      }
    }

    boolean isFinished() {
      return radius >= maxRadius;
    }

    void display() {
      noFill();
      stroke(0, 0, 255);
      ellipse(x, y, radius * 2, radius * 2);
    }
  }
}
