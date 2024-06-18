class Instructions {
  void setup() {
    fullScreen();
    textAlign(CENTER, CENTER);
  }

  void draw() {
    background(0);
    textSize(32);
    fill(255);
    text("Instruções do Jogo", width / 2, height / 8);

    textSize(24);
    float y = height / 4;

    // Instruções para a Fase 1 e Fase 2
    String[] instructionsLeft = {
      "Fase 1: Labirinto",
      "Use as setas do teclado para mover o personagem.",
      "Colete os itens para ganhar pontos.",
      "Evite os inimigos e encontre a saída do labirinto.",
      "Pressione 'A' para atacar inimigos próximos.",
      "",
      "Fase 2: Floresta",
      "Corra pela floresta usando as setas do teclado.",
      "Desvie dos obstáculos e inimigos.",
      "Colete itens para ganhar pontos.",
      "Chegue ao castelo o mais rápido possível.",
      "Pressione 'A' para atacar inimigos."
    };

    // Instruções para a Fase 3 e Fase 4
    String[] instructionsRight = {
      "Fase 3: Defesa do Castelo",
      "Defenda seu castelo do exército de Zarak.",
      "Use armas e habilidades especiais para eliminar os inimigos.",
      "Não deixe os inimigos destruírem o castelo.",
      "Mire e clique com o mouse para ataque padrão.",
      "Pressione 'S' para criar uma onda que irá afastar os inimigos proximos.",
      "",
      "Fase 4: Batalha Espacial",
      "Controle a nave de Arion com as setas do teclado.",
      "Desvie dos ataques inimigos e destrua as naves de Zarak.",
      "Pressione 'A' para disparar lasers.",
      "Pressione 'S' para lançar mísseis.",
      "Derrote Zarak em uma batalha espacial final."
    };

    // Desenha as instruções na coluna esquerda
    float xLeft = width / 4;
    for (String line : instructionsLeft) {
      text(line, xLeft, y);
      y += 40;
    }

    // Redefine a posição inicial para a coluna direita
    y = height / 4;
    float xRight = 3 * width / 4;
    for (String line : instructionsRight) {
      text(line, xRight, y);
      y += 40;
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
      drawInstructions = false;
      drawMenu = true;
    }
  }
}
