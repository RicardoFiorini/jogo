class MainMenu {
  String[] menuOptions = {"Novo Jogo", "Carregar Jogo", "Instruções", "Créditos", "Selecionar Fase"};
  int selectedOption = 0;

  void setup() {
    fullScreen();
    textAlign(CENTER, CENTER);
  }

  void draw() {
    background(0);
    textSize(48);
    fill(255);
    text("Menu Inicial", width / 2, height / 4);

    textSize(32);
    for (int i = 0; i < menuOptions.length; i++) {
      if (i == selectedOption) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      text(menuOptions[i], width / 2, height / 2 + i * 50);
    }
  }

  void keyPressed() {
    if (keyCode == UP) {
      selectedOption--;
      if (selectedOption < 0) {
        selectedOption = menuOptions.length - 1;
      }
    } else if (keyCode == DOWN) {
      selectedOption++;
      if (selectedOption >= menuOptions.length) {
        selectedOption = 0;
      }
    } else if (keyCode == ENTER) {
      executeOption(selectedOption);
    }
  }

  void executeOption(int option) {
    switch(option) {
      case 0:
        selectDifficulty();
        break;
      case 1:
        loadGame();
        break;
      case 2:
        showInstructions();
        break;
      case 3:
        showCredits();
        break;
      case 4:
        selectPhase();
        break;
    }
  }

  void selectDifficulty() {
    difficultyMenu = new DifficultyMenu();
    difficultyMenu.setup();
    drawGame = false;
    drawMenu = false;
    drawDifficulty = true;
  }

  void loadGame() {
    // Carregar jogo salvo usando GameState
    game = new Game(GameState.getDifficulty());
    game.setup();
    drawGame = true;
    drawMenu = false;
  }

  void showInstructions() {
    instructions.setup();
    drawInstructions = true;
    drawMenu = false;
  }

  void showCredits() {
    credits.setup();
    drawCredits = true;
    drawMenu = false;
  }

  void selectPhase() {
    phaseSelectionMenu = new PhaseSelectionMenu();
    phaseSelectionMenu.setup();
    drawMenu = false;
    drawPhaseSelection = true;
  }
}
