class Credits {
  String[] story = {
    "Arion foi preso em um labirinto por seu rival Zarak e deve escapar.",
    "Na primeira fase, Arion deve encontrar a saída do labirinto.",
    "Depois de escapar do labirinto, ele se encontra em uma floresta.",
    "Na segunda fase, ele deve correr pela floresta para chegar ao seu castelo.",
    "No castelo, ele deve defender sua base com todas as armas disponíveis.",
    "Na terceira fase, Arion enfrenta o exército de Zarak em uma batalha de defesa.",
    "Finalmente, Arion pega sua nave e foge para o espaço.",
    "Na quarta fase, ele enfrenta Zarak em uma batalha espacial final."
  };
  
  String[] team = {
    "Matheus - Roterista",
    "Luis - Designer",
    "Ricardo - Programador"
  };
  
  float yOffset;
  float speed = 0.5;
  boolean textStopped = false;

  void setup() {
    fullScreen();
    textAlign(CENTER, CENTER);
    yOffset = height;
  }

  void draw() {
    background(0);
    fill(255);
    textSize(24);
    float y = yOffset;

    for (String line : story) {
      text(line, width / 2, y);
      y += 40;
    }

    y += 60; // Espaço extra entre a história e os créditos da equipe

    textSize(32);
    text("Equipe:", width / 2, y);
    y += 40;

    textSize(24);
    for (String member : team) {
      text(member, width / 2, y);
      y += 40;
    }

    if (!textStopped) {
      yOffset -= speed;
      // Checa se o texto chegou ao centro da tela
      if (yOffset <= height / 2 - (story.length * 40 + 100 + team.length * 40) / 2) {
        textStopped = true;
        yOffset = height / 2 - (story.length * 40 + 100 + team.length * 40) / 2;
      }
    }

    // Botão "Voltar" no canto inferior esquerdo
    fill(100, 100, 255);
    rect(20, height - 60, 200, 40);
    fill(255);
    textSize(24);
    text("Voltar", 120, height - 40);
  }

  void mousePressed() {
    if (mouseX > 20 && mouseX < 220 &&
        mouseY > height - 60 && mouseY < height - 20) {
      MainMenu menu = new MainMenu();
      menu.setup();
      drawCredits = false;
      drawMenu = true;
    }
  }
}
