class DifficultyMenu {
  String[] difficulties = {"Fácil", "Médio", "Difícil"};
  int selectedDifficulty = 0;

  void setup() {
    fullScreen();
    textAlign(CENTER, CENTER);
  }

  void draw() {
    background(0);
    textSize(48);
    fill(255);
    text("Selecione a Dificuldade", width / 2, height / 4);

    textSize(32);
    for (int i = 0; i < difficulties.length; i++) {
      if (i == selectedDifficulty) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      text(difficulties[i], width / 2, height / 2 + i * 50);
    }
  }

  void keyPressed() {
    if (keyCode == UP) {
      selectedDifficulty--;
      if (selectedDifficulty < 0) {
        selectedDifficulty = difficulties.length - 1;
      }
    } else if (keyCode == DOWN) {
      selectedDifficulty++;
      if (selectedDifficulty >= difficulties.length) {
        selectedDifficulty = 0;
      }
    } else if (keyCode == ENTER) {
      startGame(selectedDifficulty);
    }
  }

  void startGame(int difficultyIndex) {
    // Salva a dificuldade selecionada no GameState
    GameState.setDifficulty(difficulties[difficultyIndex]);

    // Inicia o jogo com a dificuldade selecionada
    game = new Game(difficulties[difficultyIndex]);
    game.setup();
    drawGame = true;
    drawDifficulty = false;
  }
}
