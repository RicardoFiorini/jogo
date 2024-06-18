MainMenu menu;
Game game;
DifficultyMenu difficultyMenu;
Instructions instructions;
Credits credits;
PlatformPhase platformPhase;
TowerDefensePhase towerDefensePhase;
SpaceBattlePhase spaceBattlePhase;
PhaseSelectionMenu phaseSelectionMenu;

boolean drawMenu = true;
boolean drawGame = false;
boolean drawDifficulty = false;
boolean drawInstructions = false;
boolean drawCredits = false;
boolean drawPlatformPhase = false;
boolean drawTowerDefensePhase = false;
boolean drawSpaceBattlePhase = false;
boolean drawPhaseSelection = false;

void setup() {
  size(800, 600); // Defina o tamanho da janela, ajuste conforme necessário
  menu = new MainMenu();
  menu.setup();
  instructions = new Instructions();
  credits = new Credits();
}

void draw() {
  if (drawMenu) {
    menu.draw();
  } else if (drawGame) {
    game.draw();
  } else if (drawDifficulty) {
    difficultyMenu.draw();
  } else if (drawInstructions) {
    instructions.draw();
  } else if (drawCredits) {
    credits.draw();
  } else if (drawPlatformPhase) {
    platformPhase.draw();
  } else if (drawTowerDefensePhase) {
    towerDefensePhase.draw();
  } else if (drawSpaceBattlePhase) {
    spaceBattlePhase.draw();
  } else if (drawPhaseSelection) {
    phaseSelectionMenu.draw();
  }
}

void keyPressed() {
  if (drawMenu) {
    menu.keyPressed();
  } else if (drawDifficulty) {
    difficultyMenu.keyPressed();
  } else if (drawGame) {
    game.keyPressed();
  } else if (drawPlatformPhase) {
    platformPhase.keyPressed();
  } else if (drawTowerDefensePhase) {
    towerDefensePhase.keyPressed();
  } else if (drawSpaceBattlePhase) {
    spaceBattlePhase.keyPressed();
  } else if (drawPhaseSelection) {
    phaseSelectionMenu.keyPressed();
  }
}

void mousePressed() {
  if (drawInstructions) {
    instructions.mousePressed();
  } else if (drawCredits) {
    credits.mousePressed();
  } else if (drawGame) {
    game.mousePressed();
  } else if (drawPlatformPhase) {
    platformPhase.mousePressed();
  } else if (drawTowerDefensePhase) {
    towerDefensePhase.mousePressed();
  } else if (drawSpaceBattlePhase) {
    spaceBattlePhase.mousePressed();
  }
}
