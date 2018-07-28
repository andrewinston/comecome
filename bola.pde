class Bola {
	float posX;
	float posY;
	int deOndeSai;
	float diametro;
	color cor;
	boolean estaEmCampo;
	PVector posicao, velocidade, aceleracao;

	void definirManualmente(int onde, int d, float p, int v){
		int vx, vy;
		float px, py;
		deOndeSai = onde;
		diametro = d;
		if(onde == 0){
			px = 0;
			py = p - d;
			vx = v;
			vy = 0;
		}
		else if(onde == 1){
			px = p - d;
			py = 0;
			vx = 0;
			vy = v;
		}
		else if(onde == 2){
			px = 600 + d;
			py = p;
			vx = -v;
			vy = 0;
		}
		else{
			px = p;
			py = 600 + d;
			vx = 0;
			vy = -v;
		}
		posicao = new PVector(px, py);
		velocidade = new PVector(vx, vy);
		cor = color(random(0, 255), random(0, 255), random(0, 255));
		estaEmCampo = true;
	}

	void desenhar(){
		fill(cor);
		ellipse(posicao.x, posicao.y, diametro, diametro);
	}

	void moverAteOBoneco(){
		posicaoDoBoneco = new PVector(posicaoXDoBoneco + diametroBola/2, posicaoYDoBoneco + diametroBola/2);
		aceleracao = new PVector();
		aceleracao = PVector.sub(posicaoDoBoneco, posicao);
		aceleracao.setMag(0.2);
		velocidade.add(aceleracao);
		velocidade.limit(3);
		posicao.add(velocidade);
	}

	void aplicarMovimentoInimigo(){
		mover();
		desenhar();
		if(posicao.x > 600 + diametro || posicao.x < 0 - diametro || posicao.y > 600 + diametro || posicao.y < 0 - diametro){
			estaEmCampo = false;
		}
	}

	void fazerDesaparecer(){
		estaEmCampo = false;
	}

	void definirBola(){
		deOndeSai = floor(random(0,4));
		if(diametroBola <= 20){
			diametro = floor(random(diametroBola/5,  diametroBola*5));
		}
		else if(diametroBola <= 30){
			diametro = floor(random(diametroBola/8, diametroBola*4));
		}
		else if(diametroBola <= 50){
			diametro = floor(random(diametroBola/10, diametroBola*2));
		}
		else if(diametroBola <=70){
			diametro = floor(random(diametroBola/10, diametroBola*1.5));
		}
		else{
			diametro = floor(random(diametroBola/12, diametroBola*1.2));
		}
//    diametro = 40;
		if(deOndeSai == 0){
			posicao = new PVector(tamanhoCanvas + 2*diametro, random(diametro, tamanhoCanvas - diametro));
			velocidade = new PVector((-1), random(-1, 1));
		}
		if(deOndeSai == 1){
			posicao = new PVector(random(diametro, tamanhoCanvas - diametro), tamanhoCanvas + 2*diametro);
			velocidade = new PVector(random(-1, 1), (-1));
		}
		if(deOndeSai == 2){
			posicao = new PVector((-2)*diametro, random(diametro, tamanhoCanvas - diametro));
			velocidade = new PVector(1, random(-1, 1));
		}
		if(deOndeSai == 3){
			posicao = new PVector(random(diametro, tamanhoCanvas - diametro), (-2)*diametro);
			velocidade = new PVector(random(-1, 1), 1);
		}
		cor = color(floor(random(0, 255)), floor(random(0, 255)), floor(random(0, 255)));
		estaEmCampo = true;
		velocidade.setMag(random(1, 3));
	}

	void mover(){
		posicao.add(velocidade);
	}

	boolean checarSeBolaMorreu(){
		boolean bool = false;
		if(posicao.x > tamanhoCanvas + 2*diametro || posicao.x < (-2)*diametro){
			bool = true;
		}
		else if(posicao.y > tamanhoCanvas + 2*diametro || posicao.y < (-2)*diametro){
			bool = true;
		}
		return bool;
	}
}

class BolaDeInstrucao extends Bola{  
	void desenhar(){
		fill(cor);
		ellipse(posX, posY, diametro, diametro);
	}
}
