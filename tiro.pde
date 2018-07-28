class Tiro{
  PVector velocidade = new PVector();
  PVector posicao = new PVector(posicaoXDoBoneco, posicaoYDoBoneco);
  boolean estaEmCampo = false;
  int tamanhoEmX, tamanhoEmY;

  void gerar(){
    posicao.set(posicaoXDoBoneco + diametroBola/2, posicaoYDoBoneco + diametroBola/2);
    switch (direcaoDoTiro) {
      case 1 :
        velocidade.set(10, 0);
        tamanhoEmY = 5;
        tamanhoEmX = 10;
      break;  
      
      case 2 :
        velocidade.set(-10, 0);
        tamanhoEmY = 5;
        tamanhoEmX = 10;
      break;  
      
      case 3 :
        velocidade.set(0, -10);
        tamanhoEmY = 10;
        tamanhoEmX = 5;
      break;  
      
      case 4 :
        velocidade.set(0, 10);
        tamanhoEmY = 10;
        tamanhoEmX = 5;
      break;

      case 5 :
        velocidade.set(10, -10);
        velocidade.setMag(10);
        tamanhoEmY = 5;
        tamanhoEmX = 5;
      break;

      case 6 :
        velocidade.set(10, 10);
        velocidade.setMag(10);
        tamanhoEmY = 5;
        tamanhoEmX = 5;
      break;    

      case 7 :
        velocidade.set(-10, -10);
        velocidade.setMag(10);
        tamanhoEmY = 5;
        tamanhoEmX = 5;
      break;  

      case 8 :
        velocidade.set(-10, 10);
        velocidade.setMag(10);
        tamanhoEmY = 5;
        tamanhoEmX = 5;
      break;
    }
    estaEmCampo = true;
  }

  void desenhar(){
    fill(0);
    ellipse(posicao.x, posicao.y, tamanhoEmX, tamanhoEmY);
  }

  void aplicarMovimento(){
    if(posicao.x > 600 || posicao.x < 0 || posicao.y > 600 || posicao.y < 0){
      estaEmCampo = false;
    }
    if(estaEmCampo){
      posicao = PVector.add(posicao, velocidade);
      desenhar();
    }
  }
}
