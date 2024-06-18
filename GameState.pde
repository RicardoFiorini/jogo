static class GameState {
  static int score = 0; // Pontuação acumulada ao longo das fases
  static int playerLives = 3; // Vidas do jogador
  static int currentLevel = 1; // Controle de nível atual
  static String difficulty = "Médio"; // Dificuldade padrão

  public static void addScore(int points) {
    score += points;
  }

  public static int getScore() {
    return score;
  }

  public static void loseLife() {
    playerLives--;
  }

  public static int getLives() {
    return playerLives;
  }

  public static void nextLevel() {
    currentLevel++;
  }

  public static int getLevel() {
    return currentLevel;
  }

  public static void setDifficulty(String diff) {
    difficulty = diff;
  }

  public static String getDifficulty() {
    return difficulty;
  }

  public static void reset() {
    score = 0;
    playerLives = 3;
    currentLevel = 1;
    difficulty = "Médio"; // Reset para dificuldade padrão
  }
}
