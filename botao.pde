class Botao{
	String conteudo;
	float centroX;
	float centroY;
	float extensaoX;
	float extensaoY;
	boolean estaSelecionado;

	void definir(String letras, float posX, float posY, float largura, float height){
		conteudo = letras;
		centroX = posX;
		centroY = posY;
		extensaoX = largura;
		extensaoY = height;
	}

	boolean checarSeMouseXEstaNoRange(float x){
		if(x >= centroX - extensaoX/2 && x <= centroX + extensaoX/2){
			return true;
		}
		else{
			return false;
		}
	}

	boolean checarSeMouseYEstaNoRange(float y){
		if(y >= centroY - extensaoY/2 && y <= centroY + extensaoY/2){
			return true;
		}
		else{
			return false;
		}
	}

	boolean checarSeEstaSelecionado(float x, float y){
		float focoXA = centroX - extensaoX/2;
		float focoYA = centroY - extensaoY/2.5;
		float focoXB = centroX - extensaoX/2;
		float focoYB = centroY + extensaoY/2.5;
		float focoXA2 = centroX + extensaoX/2;
		float focoYA2 = centroY - extensaoY/2.5;
		float focoXB2 = centroX + extensaoX/2;
		float focoYB2 = centroY + extensaoY/2.5;
		if((dist(focoXA, focoYA, x, y) + dist(focoXB, focoYB, x, y) <= extensaoY) ||
			 (checarSeMouseXEstaNoRange(x) && checarSeMouseYEstaNoRange(y)) ||
				(dist(focoXA2, focoYA2, x, y) + dist(focoXB2, focoYB2, x, y) <= extensaoY)){
			return true;
		}
		else{
			return false;
		}
	}

	void desenhar(){
		rectMode(CORNER);
		if(checarSeEstaSelecionado(mouseX, mouseY)){
			fill(255);
		}
		else{
			fill(0);
		}
		ellipse(centroX + extensaoX/2, centroY, 60, extensaoY);
		ellipse(centroX - extensaoX/2, centroY, 60, extensaoY);
		rect(centroX - extensaoX/2, centroY - extensaoY/2, extensaoX, extensaoY);
		if(checarSeEstaSelecionado(mouseX, mouseY)){
			fill(0);
		}
		else{
			fill(255);
		}
		textAlign(CENTER);
		textSize(tamanhoRecomendadoPara(conteudo)*extensaoX/220);
		text(conteudo, centroX, centroY + 7*extensaoY/100);
	}
}

class BotaoDeEstatisticas extends Botao{
	String dadoASerExibido;
	void desenharEstatistica(){
		rectMode(CORNER);
		if(checarSeEstaSelecionado(mouseX, mouseY)){
			fill(255);
			ellipse(centroX + extensaoX/2, centroY, 60, extensaoY);
			ellipse(centroX - extensaoX/2, centroY, 60, extensaoY);
			rect(centroX - extensaoX/2, centroY - extensaoY/2, extensaoX, extensaoY);
		}
		else{
			fill(0);
			ellipse(centroX + extensaoX/2, centroY, 60, extensaoY);
			ellipse(centroX - extensaoX/2, centroY, 60, extensaoY);
			rect(centroX - extensaoX/2, centroY - extensaoY/2, extensaoX, extensaoY);
		}
		
		if(checarSeEstaSelecionado(mouseX, mouseY)){
			fill(0);
			textAlign(CENTER);
			textSize(tamanhoRecomendadoPara(dadoASerExibido)*extensaoX/220);
			text(dadoASerExibido, centroX, centroY + 7*extensaoY/100);
		}
		else{
			fill(255);
			textAlign(CENTER);
			textSize(tamanhoRecomendadoPara(conteudo)*extensaoX/220);
			text(conteudo, centroX, centroY + 7*extensaoY/100);
		}
	}
}
