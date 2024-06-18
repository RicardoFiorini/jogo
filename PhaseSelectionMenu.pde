class PhaseSelectionMenu {
  String[] phases = {"Fase 1: Labirinto", "Fase 2: Floresta", "Fase 3: Defesa da Torre", "Fase 4: Batalha Espacial"};
  int selectedPhase = 0;

  void setup() {
    fullScreen();
    textAlign(CENTER, CENTER);
  }

  void draw() {
    background(0);
    textSize(48);
    fill(255);
    text("Selecionar Fase", width / 2, height / 4);

    textSize(32);
    for (int i = 0; i < phases.length; i++) {
      if (i == selectedPhase) {
        fill(255, 0, 0);
      } else {
        fill(255);
      }
      text(phases[i], width / 2, height / 2 + i * 50);
    }
  }

  void keyPressed() {
    if (keyCode == UP) {
      selectedPhase--;
      if (selectedPhase < 0) {
        selectedPhase = phases.length - 1;
      }
    } else if (keyCode == DOWN) {
      selectedPhase++;
      if (selectedPhase >= phases.length) {
        selectedPhase = 0;
      }
    } else if (keyCode == ENTER) {
      startPhase(selectedPhase);
    } else if (keyCode == ESC) {
      goToMainMenu();
    }
  }

  void startPhase(int phase) {
    switch(phase) {
      case 0:
        game = new Game("Médio"); // ou selecione a dificuldade desejada
        game.setup();
        drawGame = true;
        break;
      case 1:
        platformPhase = new PlatformPhase();
        platformPhase.init();
        platformPhase.start();
        drawPlatformPhase = true;
        break;
      case 2:
        towerDefensePhase = new TowerDefensePhase();
        towerDefensePhase.init();
        towerDefensePhase.start();
        drawTowerDefensePhase = true;
        break;
      case 3:
        spaceBattlePhase = new SpaceBattlePhase();
        spaceBattlePhase.init();
        spaceBattlePhase.start();
        drawSpaceBattlePhase = true;
        break;
    }
    drawPhaseSelection = false;
  }

  void goToMainMenu() {
    drawPhaseSelection = false;
    drawMenu = true;
  }
}
