class Escudo{
  float posX;
  float posY;
  boolean estaEmCampo;
  int diametro = 25;
  void definir(){
    posX = random(0, tamanhoCanvas - 2*diametro);
    posY = random(0, tamanhoCanvas - 2*diametro);
  }
  
  private void desenhar(){
    if(estaEmCampo == true){
      image(escudo, posX, posY, diametro, diametro);
    }
  }

  void gerar(){
    if(estaEmCampo == false && estaComEscudo == false && naoEstaEmNenhumMenu()){
      int aleatorio = floor(random(0, 4000));
      if(aleatorio == 0){
        definir();
        desenhar();
        estaEmCampo = true;
      }
    }
  }

  void gerarEscudoInstrucao(){
    definir();
    posX = tamanhoCanvas/2 + 50;
    posY = tamanhoCanvas/2;
    desenhar();
    estaEmCampo = true;
        }
}

class Ima extends Escudo{
  void desenhar(){
    if(estaEmCampo){
      image(spriteIma, posX, posY, diametro, diametro);
    }
  }
}

class Arma extends Escudo{
  void desenhar(){
    if(estaEmCampo){
      fill(0);
      image(imagemArma, posX, posY, diametro, diametro);
    }
  }
}
