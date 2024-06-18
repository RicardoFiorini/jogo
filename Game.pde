class Game {
  int cols, rows;
  int w = 40; // Largura de cada célula do labirinto
  int[][] grid; // Grid do labirinto
  int[][] items; // Grid de itens, agora com tipos diferentes de itens
  int playerX = 0, playerY = 0; // Posição inicial do jogador
  int exitX, exitY; // Posição da saída
  int itemCount; // Número de itens no labirinto
  int ammoCount = 0; // Quantidade de munição
  int timeLimit = 600; // Limite de tempo em segundos (10 minutos)
  int startTime; // Hora de início do jogo
  boolean showPopup = false; // Controle de exibição do popup
  String popupMessage = ""; // Mensagem do popup
  String buttonText = ""; // Texto do botão
  boolean isGameOver = false; // Controle para game over
  boolean showGameOverPopup = false; // Controle de exibição do popup de game over
  String difficulty;
  ArrayList<Enemy> enemies = new ArrayList<Enemy>(); // Lista de inimigos
  ArrayList<Bullet> bullets = new ArrayList<Bullet>(); // Lista de balas
  PImage playerImage, enemyImage, weaponImage, caminhoImage, gramaImage;

  Game(String difficulty) {
    this.difficulty = difficulty;
  }

  void setup() {
    fullScreen(); // Tela cheia
    playerImage = loadImage("arion.png");
    enemyImage = loadImage("inimigo.png");
    weaponImage = loadImage("arma.png");
    caminhoImage = loadImage("caminho.jpg");
    gramaImage = loadImage("grama.jpg");
    cols = width / w;
    rows = height / w;
    grid = new int[cols][rows];
    items = new int[cols][rows]; // Alterado de boolean para int para tipos de itens
    // Inicializa o labirinto com paredes e sem itens
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        grid[i][j] = 1; // 1 representa uma parede
        items[i][j] = 0; // 0 representa sem item
      }
    }
    // Criar caminhos no labirinto e colocar itens
    generateMaze(0, 0);
    placeItems(); // Coloca itens no labirinto
    placeStartingWeapon(); // Coloca uma arma próxima à posição inicial do jogador
    exitX = cols - 1;
    exitY = rows - 1;
    grid[exitX][exitY] = 0; // Define a saída
    startTime = millis(); // Armazena a hora de início do jogo
    
    // Adiciona inimigos ao labirinto
    for (int i = 0; i < getEnemyCount(); i++) {
      addEnemy();
    }
  }

  void draw() {
    background(0);
    drawMaze();
    drawItems();
    drawScore();
    drawTimer();
    drawAmmo();
    drawPlayer();
    drawEnemies();
    drawBullets();
    
    if (showPopup) {
      drawPopup(popupMessage, buttonText);
    } else if (showGameOverPopup) {
      drawGameOverPopup("Game Over! Você foi pego por um inimigo.");
    } else {
      if (playerX == exitX && playerY == exitY) {
        showPopup = true;
        popupMessage = "Fase completa! Preparando para a próxima fase...";
        buttonText = "Próxima Fase";
      } else if (millis() - startTime > timeLimit * 1000) {
        gameOver("O tempo acabou.");
      }
      moveEnemies();
      moveBullets();
      checkCollisions();
    }
  }

  void keyPressed() {
    if (!showPopup && !showGameOverPopup) {
      int nextX = playerX, nextY = playerY;
      if (keyCode == UP) nextY--;
      else if (keyCode == DOWN) nextY++;
      else if (keyCode == LEFT) nextX--;
      else if (keyCode == RIGHT) nextX++;
      
      if (nextX >= 0 && nextX < cols && nextY >= 0 && nextY < rows && grid[nextX][nextY] == 0) {
        playerX = nextX;
        playerY = nextY;
        if (items[playerX][playerY] != 0) {
          collectItem(items[playerX][playerY]);
          items[playerX][playerY] = 0; // O jogador coletou o item
        }
      }
    }
    if (key == 'A' || key == 'a') {
      shootNearestEnemy();
    }
  }

  void collectItem(int itemType) {
    switch(itemType) {
      case 1:
        GameState.addScore(10); // 10 pontos para item tipo 1
        break;
      case 2:
        GameState.addScore(20); // 20 pontos para item tipo 2
        break;
      case 3:
        GameState.addScore(50); // 50 pontos para item tipo 3
        break;
      case 4:
        ammoCount += 5; // 5 munições para o item tipo 4 (arma)
        break;
    }
  }

  void shootNearestEnemy() {
    if (ammoCount > 0) {
      ammoCount--;
      Enemy nearestEnemy = null;
      float nearestDistance = Float.MAX_VALUE;
      for (Enemy enemy : enemies) {
        float distance = dist(playerX, playerY, enemy.x, enemy.y);
        if (distance < nearestDistance && isSamePath(playerX, playerY, enemy.x, enemy.y)) {
          nearestDistance = distance;
          nearestEnemy = enemy;
        }
      }
      if (nearestEnemy != null) {
        float angle = atan2(nearestEnemy.y - playerY, nearestEnemy.x - playerX);
        bullets.add(new Bullet(playerX, playerY, angle, nearestEnemy));
      }
    }
  }

  boolean isSamePath(int x1, int y1, int x2, int y2) {
    return (x1 == x2 || y1 == y2) && isPathClear(x1, y1, x2, y2);
  }

  boolean isPathClear(int x1, int y1, int x2, int y2) {
    if (x1 == x2) {
      for (int y = min(y1, y2); y <= max(y1, y2); y++) {
        if (grid[x1][y] == 1) {
          return false;
        }
      }
    } else if (y1 == y2) {
      for (int x = min(x1, x2); x <= max(x1, x2); x++) {
        if (grid[x][y1] == 1) {
          return false;
        }
      }
    }
    return true;
  }

  void mousePressed() {
    if (showPopup) {
      // Verifica se o clique está dentro do botão
      if (mouseX > width / 2 - 100 && mouseX < width / 2 + 100 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showPopup = false;
        nextPhase();
      }
    } else if (showGameOverPopup) {
      // Verifica se o clique está dentro do botão "Reiniciar"
      if (mouseX > width / 2 - 150 && mouseX < width / 2 - 50 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showGameOverPopup = false;
        resetGame();
      }
      // Verifica se o clique está dentro do botão "Menu Inicial"
      if (mouseX > width / 2 + 50 && mouseX < width / 2 + 150 &&
          mouseY > height / 2 + 50 && mouseY < height / 2 + 100) {
        showGameOverPopup = false;
        goToMainMenu();
      }
    }
  }

  void endPhase() {
    println("Fase completa! Preparando para a próxima fase...");
    GameState.nextLevel(); // Avança para o próximo nível
  }

  void gameOver(String reason) {
    println("Game Over! " + reason);
    GameState.loseLife(); // Perde uma vida
    if (GameState.getLives() <= 0) {
      println("Game Over! Sem vidas restantes.");
    }
    showGameOverPopup = true;
    isGameOver = true;
  }

  void drawMaze() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (grid[i][j] == 1) {
          image(gramaImage, i * w, j * w, w, w); // Imagem das paredes
        } else if (i == exitX && j == exitY) {
          fill(0, 255, 0); // Cor da saída (verde)
          rect(i * w, j * w, w, w);
        } else {
          image(caminhoImage, i * w, j * w, w, w); // Imagem dos caminhos
        }
      }
    }
  }

  void generateMaze(int x, int y) {
    grid[x][y] = 0; // 0 representa um caminho
    // Embaralha direções para aleatoriedade
    int[] directions = {0, 1, 2, 3};
    for (int i = 0; i < directions.length; i++) {
      int r = int(random(directions.length));
      int temp = directions[i];
      directions[i] = directions[r];
      directions[r] = temp;
    }
    
    for (int i = 0; i < directions.length; i++) {
      int nx = x, ny = y;
      switch(directions[i]) {
        case 0: nx -= 2; break;
        case 1: nx += 2; break;
        case 2: ny -= 2; break;
        case 3: ny += 2; break;
      }
      if (nx >= 0 && nx < cols && ny >= 0 && ny < rows && grid[nx][ny] == 1) {
        grid[(nx + x) / 2][(ny + y) / 2] = 0;
        generateMaze(nx, ny);
      }
    }
  }

  void placeItems() {
    itemCount = getItemCountByDifficulty();
    for (int i = 0; i < itemCount; i++) {
      int itemX, itemY;
      do {
        itemX = int(random(cols));
        itemY = int(random(rows));
      } while (grid[itemX][itemY] != 0 || items[itemX][itemY] != 0); // Garante que itens não se sobreponham
      items[itemX][itemY] = int(random(1, 5)); // Tipos de item 1, 2, 3, 4
    }
  }

  void placeStartingWeapon() {
    int[][] offsets = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
    for (int[] offset : offsets) {
      int weaponX = playerX + offset[0];
      int weaponY = playerY + offset[1];
      if (weaponX >= 0 && weaponX < cols && weaponY >= 0 && weaponY < rows && grid[weaponX][weaponY] == 0) {
        items[weaponX][weaponY] = 4; // Coloca uma arma próxima à posição inicial do jogador
        return;
      }
    }
  }

  int getItemCountByDifficulty() {
    switch(difficulty) {
      case "Fácil": return 20;
      case "Médio": return 10;
      case "Difícil": return 5;
      default: return 10;
    }
  }

  void drawItems() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (items[i][j] != 0) {
          float scaleFactor = 1.0 + 0.2 * sin(millis() / 1000.0); // Fator de escala mais sutil
          pushMatrix();
          translate(i * w + w / 2, j * w + w / 2);
          scale(scaleFactor);
          switch(items[i][j]) {
            case 1:
              fill(0, 255, 0); // Verde para item tipo 1
              ellipse(0, 0, w / 2, w / 2);
              break;
            case 2:
              fill(0, 0, 255); // Azul para item tipo 2
              ellipse(0, 0, w / 2, w / 2);
              break;
            case 3:
              fill(255, 215, 0); // Dourado para item tipo 3
              ellipse(0, 0, w / 2, w / 2);
              break;
            case 4:
              image(weaponImage, -w / 4, -w / 4, w / 2, w / 2); // Imagem da arma
              break;
          }
          popMatrix();
        }
      }
    }
  }

  void drawPlayer() {
    image(playerImage, playerX * w, playerY * w, w, w);
  }

  void drawEnemies() {
    for (Enemy enemy : enemies) {
      image(enemyImage, enemy.x * w, enemy.y * w, w, w);
    }
  }

  void drawBullets() {
    fill(255, 255, 0);
    for (Bullet bullet : bullets) {
      ellipse(bullet.x * w + w / 2, bullet.y * w + w / 2, w / 4, w / 4);
    }
  }

  void moveBullets() {
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet bullet = bullets.get(i);
      bullet.move();
      if (bullet.hit || grid[int(bullet.x)][int(bullet.y)] == 1) { // Verifica se a bala atingiu um alvo ou uma parede
        bullets.remove(i);
      }
    }
  }

  void drawScore() {
    fill(0);
    noStroke();
    rect(width - 220, height - 50, 200, 40); // Caixa preta para fundo do score
    fill(255);
    textSize(24);
    textAlign(RIGHT, CENTER);
    text("Score: " + GameState.getScore(), width - 20, height - 30); // Texto alinhado à direita
  }

  void drawTimer() {
    int elapsedTime = (millis() - startTime) / 1000; // Tempo decorrido em segundos
    int remainingTime = timeLimit - elapsedTime; // Tempo restante
    fill(0);
    noStroke();
    rect(20, height - 50, 200, 40); // Caixa preta para fundo do timer
    fill(255);
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Tempo: " + remainingTime, 30, height - 30); // Texto alinhado à esquerda
  }

  void drawAmmo() {
    fill(0);
    noStroke();
    rect(20, height - 100, 200, 40); // Caixa preta para fundo do ammo
    fill(255);
    textSize(24);
    textAlign(LEFT, CENTER);
    text("Munição: " + ammoCount, 30, height - 80); // Texto alinhado à esquerda
  }

  void drawPopup(String message, String buttonText) {
    fill(50, 50, 50, 200); // Fundo do popup com transparência
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
    fill(50, 50, 50, 200); // Fundo do popup com transparência
    rect(width / 4, height / 3, width / 2, height / 3);
    fill(255);
    textSize(32);
    textAlign(CENTER, CENTER);
    text(message, width / 2, height / 2 - 20);
    
    // Botão "Reiniciar"
    fill(100, 100, 255);
    rect(width / 2 - 150, height / 2 + 50, 100, 50);
    fill(255);
    textSize(24);
    text("Reiniciar", width / 2 - 100, height / 2 + 75);
    
    // Botão "Menu Inicial"
    fill(100, 100, 255);
    rect(width / 2 + 50, height / 2 + 50, 100, 50);
    fill(255);
    textSize(24);
    text("Menu Inicial", width / 2 + 100, height / 2 + 75);
  }

  void nextPhase() {
    GameState.currentLevel = 2;
    platformPhase = new PlatformPhase(); // Cria uma instância da próxima fase
    platformPhase.init(); // Chama um método para inicializar a fase (se necessário)
    platformPhase.start(); // Inicia a próxima fase
    drawGame = false;
    drawPlatformPhase = true;
  }

  void resetGame() {
    // Lógica para reiniciar o jogo
    playerX = 0;
    playerY = 0;
    ammoCount = 0;
    GameState.reset(); // Reseta o estado do jogo
    startTime = millis();
    enemies.clear();
    bullets.clear();
    for (int i = 0; i < getEnemyCount(); i++) {
      addEnemy();
    }
    loop();
  }

  void goToMainMenu() {
    // Lógica para voltar ao menu inicial
    menu = new MainMenu();
    menu.setup();
    drawGame = false; // Troca para o menu
    drawMenu = true;
  }

  void addEnemy() {
    int ex, ey;
    do {
      ex = int(random(cols));
      ey = int(random(rows));
    } while (grid[ex][ey] != 0 || (ex == playerX && ey == playerY) || (ex == exitX && ey == exitY));
    enemies.add(new Enemy(ex, ey, getEnemySpeed()));
  }

  void moveEnemies() {
    for (Enemy enemy : enemies) {
      if (millis() - enemy.lastMoveTime > enemy.moveDelay) {
        int direction = int(random(4));
        int nextX = enemy.x;
        int nextY = enemy.y;
        switch(direction) {
          case 0: nextY--; break; // Cima
          case 1: nextY++; break; // Baixo
          case 2: nextX--; break; // Esquerda
          case 3: nextX++; break; // Direita
        }
        if (nextX >= 0 && nextX < cols && nextY >= 0 && nextY < rows && grid[nextX][nextY] == 0) {
          enemy.x = nextX;
          enemy.y = nextY;
          enemy.lastMoveTime = millis();
        }
      }
    }
  }

  void checkCollisions() {
    for (Enemy enemy : enemies) {
      if (enemy.x == playerX && enemy.y == playerY) {
        gameOver("Você foi pego por um inimigo.");
      }
    }
  }

  class Enemy {
    int x, y;
    int moveDelay;
    int lastMoveTime = 0; // Momento do último movimento
    Enemy(int x, int y, int moveDelay) {
      this.x = x;
      this.y = y;
      this.moveDelay = moveDelay;
    }
  }

  class Bullet {
    float x, y;
    float angle;
    float speed = 0.2;
    boolean hit = false;
    Enemy target;

    Bullet(int startX, int startY, float angle, Enemy target) {
      this.x = startX;
      this.y = startY;
      this.angle = angle;
      this.target = target;
    }

    void move() {
      x += cos(angle) * speed;
      y += sin(angle) * speed;
      if (dist(x, y, target.x, target.y) < 0.5) {
        hit = true;
        enemies.remove(target);
        GameState.addScore(100);
      }
    }
  }

  int getItemScore(int itemType) {
    switch(itemType) {
      case 1:
        return 10; // 10 pontos para item tipo 1
      case 2:
        return 20; // 20 pontos para item tipo 2
      case 3:
        return 50; // 50 pontos para item tipo 3
      default:
        return 0;
    }
  }

  int getEnemyCount() {
    switch(difficulty) {
      case "Fácil": return 3;
      case "Médio": return 5;
      case "Difícil": return 7;
      default: return 5;
    }
  }

  int getEnemySpeed() {
    switch(difficulty) {
      case "Fácil": return 1000;
      case "Médio": return 500;
      case "Difícil": return 250;
      default: return 500;
    }
  }
}
