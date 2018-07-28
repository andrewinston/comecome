import processing.net.*;
Client client;
float[] info;
int direcaoDoTiro;
float contadorDeEspera = 0;
PImage moeda, spriteBocaAberta, spriteBocaFechada, escudo, spriteBocaAbertaComEscudo, spriteBocaFechadaComEscudo, spriteIma;
PImage sprite2BocaAberta, sprite2BocaFechada, sprite2BocaFechadaComEscudo, sprite2BocaAbertaComEscudo, imagemArma;
float determinanteDaBoca = 0;
float contadorDeInstrucoes;
int tamanhoTexto = 32;
int pontuacao = 0;
boolean moverCima = false;
boolean moverBaixo = false;
boolean moverEsquerda = false;
boolean moverDireita = false;
int tamanhoCanvas = 600;
float tempoRestanteComIma = 0, tempoRestanteComEscudo = 0, tempoRestanteComArma = 0;;
color background = 255;
int contadorDeBolas = 0;
Bola[] bola = new Bola[30];
Tiro[] tiro = new Tiro[50];
Escudo escudoGerado = new Escudo();
Arma arma = new Arma();
Ima ima = new Ima();
BolaDeInstrucao instrutora = new BolaDeInstrucao();
float aux = 0;
float diametroBola = 20*600/tamanhoCanvas;
float posicaoXDoBoneco = 300 - diametroBola;
float posicaoYDoBoneco = 300 - diametroBola;
float velocidadeBola = 5;
int quantMaxBolas = 10, quantMaxTiros = 50;
boolean fim = false;
float bordaEsquerdaTentarNovamente = tamanhoCanvas*3/10 - tamanhoCanvas/20;
float bordaDireitaTentarNovamente = tamanhoCanvas*7/10 + tamanhoCanvas/20;
float bordaCimaTentarNovamente = tamanhoCanvas*5/8 - tamanhoCanvas/12;
float bordaBaixoTentarNovamente = tamanhoCanvas*5/8 - tamanhoCanvas/12 + tamanhoCanvas/6;
boolean tentarNovamenteSelecionado = false;
String recordes[];
String estatisticas[];
boolean[] instrucao = new boolean[5];
boolean estaComEscudo = false, estaComIma = false, estaComArma = false;
int frameQuePegouEscudo = -700, frameQuePegouIma = -700, frameQuePegouArma = -700;
int player = 1;
boolean estaNoJogoMultiplayer = false;
boolean estaNoMenuInicial = true;
boolean novoJogoSelecionado = false;
boolean multiplayerSelecionado = false;
boolean retornarAoMenuPrincipalSelecionado = false;
boolean recordeBatido = false;
boolean jaAbriuEspaco = false;
boolean recordesSelecionado = false;
boolean estaNoMenuDosRecordes;
boolean estaNasInstrucoes;
boolean instrucoesSelecionado = false;
boolean estaNoMenuDeDerrota = false;
boolean estaNoMenuDeEscolhaDeJogador = false;
float totalDePontos;
float mediaDePontos;
float partidasJogadas;
float tempoTotalDeJogo;
float bolasComidas;
float escudosPegos;
float duracaoMediaDasPartidas;
float mediaDeBolasComidas;
float mediaDeEscudosPegos;
boolean avancarSelecionado;
boolean estatisticasSelecionado;
boolean estaNoMenuDeEstatisticas;
boolean retornarAosRecordesSelecionado;
boolean jogador1Selecionado, jogador2Selecionado;
boolean estaNoMenuDeColocarOIP;
String tempoASerExibido;
float contagemRegressiva;
int contadorDeTiros;
int nivel = 1;
PVector posicaoDoBoneco;
float posXParceiro = 9000, posYParceiro = 9000;
int jogadoresOnline;
String ip = "192.168.0.15";

void setup(){
	//client = new Client(this, "192.168.0.15", 5204);
	imagemArma = loadImage("arma.png");
	spriteBocaAberta = loadImage("sprite_boca_aberta.png");
	spriteBocaFechada = loadImage("sprite_boca_fechada.png");
	sprite2BocaFechada = loadImage("sprite2_boca_fechada.png");
	sprite2BocaAberta = loadImage("sprite2_boca_aberta.png");
	sprite2BocaAbertaComEscudo = loadImage("sprite2_boca_aberta_com_escudo.png");
	sprite2BocaFechadaComEscudo = loadImage("sprite2_boca_fechada_com_escudo.png");
	moeda = loadImage("moeda.png");
	escudo = loadImage("escudo.png");
	spriteBocaFechadaComEscudo = loadImage("sprite_boca_fechada_com_escudo.png");
	spriteIma = loadImage("ima.png");
	spriteBocaAbertaComEscudo = loadImage("sprite_boca_aberta_com_escudo.png");
	background(background);
	noStroke();
	size(tamanhoCanvas, tamanhoCanvas);
	recordes = loadStrings("recordes.txt");
	estatisticas = loadStrings("estatisticas.txt");
	totalDePontos = int(estatisticas[0]);
	partidasJogadas = int(estatisticas[1]);
	mediaDePontos = 0;
	duracaoMediaDasPartidas = 0;
	mediaDeBolasComidas = 0;
	mediaDeEscudosPegos = 0;
	tempoTotalDeJogo = int(estatisticas[2]);
	escudosPegos = int(estatisticas[3]);
	bolasComidas = int(estatisticas[4]);
	if(partidasJogadas!= 0){
		mediaDePontos = totalDePontos/partidasJogadas;
		duracaoMediaDasPartidas = tempoTotalDeJogo/partidasJogadas;
		mediaDeBolasComidas = bolasComidas/partidasJogadas;
		mediaDeEscudosPegos = escudosPegos/partidasJogadas;
	}
	for(int i = 0; i < quantMaxTiros; i++){
		tiro[i] = new Tiro();
	}
}
void gerarBola(){
	bola[contadorDeBolas] = new Bola();
	bola[contadorDeBolas].definirBola();
	if(contadorDeBolas < quantMaxBolas){
		contadorDeBolas++;
	}
}
float calcularDistanciaBola(float posX, float posY, Bola bola){
	float distancia = sqrt(pow(((posX + diametroBola/2) - bola.posicao.x), 2) + pow(((posY + diametroBola/2) - bola.posicao.y), 2));
	return distancia;
}
float calcularDistanciaEscudo(float posX, float posY, Escudo escudoGerado){
	float distancia = sqrt(pow(((posX + diametroBola/2) - (escudoGerado.posX + escudoGerado.diametro/2)), 2) + 
		pow(((posY + diametroBola/2) - (escudoGerado.posY + escudoGerado.diametro/2)), 2));
	return distancia;
}
boolean checarSePegouEscudo(){
	boolean bool = false;
	if(calcularDistanciaEscudo(posicaoXDoBoneco, posicaoYDoBoneco, escudoGerado) <= diametroBola/2 + escudoGerado.diametro/2){
		bool = true;
	}
	return bool;
}

boolean pegouArma(){
	if(dist(posicaoXDoBoneco, posicaoYDoBoneco, arma.posX, arma.posY) <= diametroBola/2 + arma.diametro/2){
		return true;
	}
	else{
		return false;
	}
}

boolean pegouIma(){
	if(dist(posicaoXDoBoneco, posicaoYDoBoneco, ima.posX, ima.posY) <= diametroBola/2 + ima.diametro/2){
		return true;
	}
	else{
		return false;
	}
}
boolean checarColisao(int i){
	boolean bool = false;
	if(estaComEscudo == false){
		if(calcularDistanciaBola(posicaoXDoBoneco, posicaoYDoBoneco, bola[i]) <= diametroBola/2 + bola[i].diametro/2){
			bool = true;
		}
	}
	if(estaComEscudo){
		if(calcularDistanciaBola(posicaoXDoBoneco, posicaoYDoBoneco, bola[i]) <= diametroBola/2 + bola[i].diametro/2 && podeComerBola(i)){
			bool = true;
		}
	}
	return bool;
}
boolean checarColisaoNaInstrucao(){
	if(dist(posicaoXDoBoneco + diametroBola/2, posicaoYDoBoneco + diametroBola/2, instrutora.posX, instrutora.posY) <
	 diametroBola/2 + instrutora.diametro/2 && instrucao[1] == true){
		return true;
	}
	else{
		return false;
	}
}
void gerarBolaNoIndice(int i){
	bola[i].definirBola();
}
void moverEsquerda(){
	posicaoXDoBoneco -= velocidadeBola;
}
void moverCima(){
	posicaoYDoBoneco -= velocidadeBola;
}
void moverBaixo(){
	posicaoYDoBoneco += velocidadeBola;
}
void moverDireita(){
	posicaoXDoBoneco += velocidadeBola;
}
int checarMovimento(){
	if(moverDireita == true){
		if(moverCima == true){
			direcaoDoTiro = 5;
			return 5;
		}
		if(moverBaixo == true){
			direcaoDoTiro = 6;
			return 6;
		}
		direcaoDoTiro = 1;
		return 1;
	}
	if(moverEsquerda == true){
		if(moverCima == true){
			direcaoDoTiro = 7;
			return 7;
		}
		if(moverBaixo == true){
			direcaoDoTiro = 8;
			return 8;
		}
		direcaoDoTiro = 2;
		return 2;
	}
	if(moverCima == true){
		direcaoDoTiro = 3;
		return 3;
	}
	if(moverBaixo == true){
		direcaoDoTiro = 4;
		return 4;
	}
	else{
		return 0;
	}
}
void aplicarMovimento(){
	if(checarMovimento() == 1){
		moverDireita();
	}
	if(checarMovimento() == 2){
		moverEsquerda();
	}
	if(checarMovimento() == 3){
		moverCima();
	}
	if(checarMovimento() == 4){
		moverBaixo();
	}
	if(checarMovimento() == 5){
		moverDireita();
		moverCima();
	}
	if(checarMovimento() == 6){
		moverDireita();
		moverBaixo();
	}
	if(checarMovimento() == 7){
		moverEsquerda();
		moverCima();
	}
	if(checarMovimento() == 8){
		moverEsquerda();
		moverBaixo();
	}
	if(checarSeChegouAoFimDoCanvas() == 1){
		posicaoXDoBoneco = -diametroBola/2;
	}
	if(checarSeChegouAoFimDoCanvas() == 2){
		posicaoXDoBoneco = tamanhoCanvas + diametroBola/2;
	}
	if(checarSeChegouAoFimDoCanvas() == 3){
		posicaoYDoBoneco = -diametroBola/2;
	}
	if(checarSeChegouAoFimDoCanvas() == 4){
		posicaoYDoBoneco = tamanhoCanvas + diametroBola/2;
	}
	desenharBola();
}
int checarSeChegouAoFimDoCanvas(){
	if(posicaoXDoBoneco > tamanhoCanvas + diametroBola/2){
		return 1;
	}
	if(posicaoXDoBoneco < -diametroBola/2){
		return 2;
	}
	if(posicaoYDoBoneco > tamanhoCanvas + diametroBola/2){
		return 3;
	}
	if(posicaoYDoBoneco < -diametroBola/2){
		return 4;
	}
	else{
		return 0;
	}
}
void comerBolaInimiga(int i){
	diametroBola += sqrt(bola[i].diametro)/diametroBola;
	//println(diametroBola);
}
int quantAlgarismosPontuacao(){
	int quantAlgarismos = 0, auxPontuacao = pontuacao;
	while(auxPontuacao != 0){
		auxPontuacao /= 10;
		quantAlgarismos++;
	}
	return quantAlgarismos;
}
int quantAlgarismos(int num){
	int quantAlgarismos = 0;
	while(num != 0){
		num /= 10;
		quantAlgarismos++;
	}
	return quantAlgarismos;
}
void mostrarPontuacao(){
	textAlign(CENTER);
	fill(0);
	textSize(tamanhoTexto);
	text(pontuacao, tamanhoTexto + 10, tamanhoTexto + 10);
}
void somarPontos(int i){
	pontuacao += sqrt(bola[i].diametro);
}
boolean podeComerBola(int i){
	if(diametroBola*1.1 >= bola[i].diametro){
		return true;
	}
	else{
		return false;
	}
}

void aplicarColisaoDosTiros(){
	for(int i = 0; i < quantMaxTiros; i++){
	//  println("estou checando os tiros");
		if(tiro[i].estaEmCampo){
		//  println("TIRO EM CAMPO, CARAE");
			for(int j = 0; j < quantMaxBolas; j++){
			//  println("vou checar as bolas");
				println("distancia = " +dist(tiro[i].posicao.x, tiro[i].posicao.y, bola[j].posicao.x, bola[j].posicao.y));
				if(dist(tiro[i].posicao.x, tiro[i].posicao.y, bola[j].posicao.x, bola[j].posicao.y) <= bola[j].diametro/2){
					println("COLIDIUUUUU");
					bola[j].diametro *= 0.96;
					tiro[i].estaEmCampo = false;
				}
			}
		}
	}
}

void aplicarColisaoDaBolaDoIndice(int i){
	for(int j = 0; j < quantMaxBolas; j++){
		if(i == j){j++;}
		if(dist(bola[i].posicao.x, bola[i].posicao.y, bola[j].posicao.x, bola[j].posicao.y) <= bola[i].diametro/2 + bola[j].diametro/2){
			PVector auxI = new PVector();
			PVector auxJ = new PVector();
			float vi = bola[i].velocidade.mag();
			float vj = bola[j].velocidade.mag();
			float mi = bola[i].diametro, mj = bola[j].diametro;
			float vxii = bola[i].velocidade.x, vxji = bola[j].velocidade.x;
			float vyii = bola[i].velocidade.y, vyji = bola[j].velocidade.y;
			float vxjf, vyjf, vxif, vyif;

			/*vxjf = 2*mi*vxii/(mj + mi);
			vxif = vxji + vxjf - vxii;

			vyjf = 2*mi*vyii/(mj + mi);
			vyif = vyji + vyjf - vyii;

			bola[i].velocidade.set(vxif, vyif);
			bola[j].velocidade.set(vxjf, vyjf);*/

			auxI.set(bola[i].posicao);
			auxI.setMag(mi);
			auxJ.set(bola[j].posicao);
			auxJ.setMag(mj);
			bola[i].velocidade = PVector.sub(bola[i].posicao, bola[j].posicao);
			bola[j].velocidade = PVector.sub(bola[j].posicao, bola[i].posicao);
			bola[i].velocidade = PVector.add(bola[i].velocidade, auxI);
			bola[j].velocidade = PVector.add(bola[j].velocidade, auxJ);
			bola[i].velocidade.setMag(vi);
			bola[j].velocidade.setMag(vj);
		}
	}
}
void draw(){
	//println("multiplayerSelecionado: "+multiplayerSelecionado);
	//println("estaNoMenuInicial: "+estaNoMenuInicial);
	atualizarTela();
	atualizarEstatisticas();
	if(estaNoMenuDeColocarOIP){
		exibirMenuDeEscolhaDoIP();
	}
	if(estaSomenteNosRecordes()){
		exibirTodosRecordes();
	}
	if(estaSomenteNoMenuInicial()){
		exibirMenuInicial();
	}
	if(estaNoMenuDeEscolhaDeJogador){
		exibirMenuDeEscolhaDeJogador();
	}
	if(estaNoJogoMultiplayer){
		//println("TO NO MULTIPLAYER");
		aplicarMovimento();
//    if(estaSeMovendo()){
//      client.write(player + "," + posicaoXDoBoneco + "," + posicaoYDoBoneco + "," + estaComEscudo + "," + diametroBola + "," + estaPertoDeInimigoComestivel() + "*");
//    }
//    else{
//      client.write(-player + "," + posicaoXDoBoneco + "," + posicaoYDoBoneco + "," + estaComEscudo + "," + diametroBola + "," + estaPertoDeInimigoComestivel() + "*");
//    }
		thread("mandarInformacoes");
		if(frameCount%50 == 0){
			if(client.available() > 0){
				String dados = client.readStringUntil('*');
				info = float(splitTokens(dados, ",*"));
				if(player != abs(info[0])){
					if(abs(info[0]) == 1 || abs(info[0]) == 2){
						jogadoresOnline = 2;
					}
					if(info[0] < 0){
						if(posXParceiro != 9000){
							posXParceiro = info[1];
							posYParceiro = info[2];
						}
						else{
							posXParceiro = 280;
							posYParceiro = 280;
						}
					}
					if(info[0] == 1 || info[0] == 2){
						if(info[1] == 1){
							posXParceiro -= 5;
						}
						if(info[2] == 1){
							posYParceiro -= 5;
						}
						if(info[3] == 1){
							posXParceiro += 5;
						}
						if(info[4] == 1){
							posYParceiro += 5;
						}  
					}
					if(jogadoresOnline == 2){
						if(info[0] == 3){
							for(int i = 0; i < quantMaxBolas; i++){
								if(!bola[i].estaEmCampo){
									bola[i].definirManualmente(int(info[1]), 15, info[2], 2);
									break;
								}
							}
						}
					}
				}
			}
			for(int i = 0; i < quantMaxBolas; i++){
				if(bola[i].estaEmCampo){
					bola[i].aplicarMovimentoInimigo();
				}
			}
			if(jogadoresOnline == 2){
				desenharParceiro(posXParceiro, posYParceiro, false, 20, false);
			}
			if(jogadoresOnline != 2){
				fill(0);
				textAlign(LEFT);
				if(frameCount % 150 < 50){
					text("Esperando jogador.", 170, 340);
				}
				else if(frameCount % 150 < 100){
					text("Esperando jogador..", 170, 340);
				}
				else{
					text("Esperando jogador...", 170, 340);  
				}
			}
			//println("jogadoresOnline: "+jogadoresOnline);
			println("posXParceiro: "+posXParceiro);
			println("posYParceiro: "+posYParceiro);
		}
		/*if(client.available() > 0){
			String dados = client.readStringUntil('*');
			char primeiraLetra = dados.charAt(0);
			info = float(splitTokens(dados, ",*"));
			if(info[0] != player && info[0] != -player){
				desenharParceiro(info[1], info[2], boolean(int(info[3])), info[4], boolean(int(info[5])));
			}
		}*/
	}
	if(naoEstaEmNenhumMenu()){
		for(int i = 0; i < quantMaxTiros; i++){
			if(tiro[i].estaEmCampo){
				tiro[i].aplicarMovimento();
			}
		}
		aplicarColisaoDosTiros();
		player = 1;
		escudoGerado.gerar();
		escudoGerado.desenhar();
		if(!estaComArma){
			//arma.gerar();
		}
		//arma.desenhar();
		if(!estaComIma){
			ima.gerar();
		}
		ima.desenhar();
		if(pegouIma() && ima.estaEmCampo){
			estaComIma = true;
			frameQuePegouIma = frameCount;
			ima.estaEmCampo = false;
		}
		if(pegouArma() && arma.estaEmCampo){
			estaComArma = true;
			frameQuePegouArma = frameCount;
			arma.estaEmCampo = false;
		}
		if(estaComArma){
			exibirTempoRestanteComArma();
			if(frameCount - frameQuePegouArma >= 1200){
				estaComArma = false;
			}
		}
		if(estaComIma){
			exibirTempoRestanteComIma();
			if(frameCount - frameQuePegouIma >= 600){
				estaComIma = false;
			}
		}
		if(checarSePegouEscudo() && escudoGerado.estaEmCampo == true){
			estaComEscudo = true;
			frameQuePegouEscudo = frameCount;
			escudoGerado.estaEmCampo = false;
			escudosPegos++;
		}
		if(estaComEscudo){
			velocidadeBola = 6 + nivel;
			exibirTempoRestanteComEscudo();
			if(frameCount - frameQuePegouEscudo >= 600){
				estaComEscudo = false;
				velocidadeBola = 4 + nivel;
			}
		}
		if(estaComEscudo == false){
			velocidadeBola = 4 + nivel;
		}
		mostrarPontuacao();
		aplicarMovimento();
		desenharBola();
		gerarBola();
		mostrarMaiorRecorde();
		tempoTotalDeJogo += 0.01666666667;
		if(contadorDeEspera <= 0){
			for (int i = 0; i < contadorDeBolas; i++){
				aplicarColisaoDaBolaDoIndice(i);
				bola[i].aplicarMovimentoInimigo();
				if(podeComerBola(i) && estaComIma){
					bola[i].moverAteOBoneco();
				}
				if(naoEstaEmNenhumMenu() == false){
					bola[i].estaEmCampo = false;
				}
				if((bola[i].checarSeBolaMorreu() || checarColisao(i)) && naoEstaEmNenhumMenu()){
					if(checarColisao(i) == true && !podeComerBola(i) && !estaComEscudo){
						fim = true;
						salvarEstatisticas();
						for(int j = 0; j < quantMaxTiros; j++){
							tiro[j].estaEmCampo = false;
						}
						tempoRestanteComIma = 0;
					}
					if(estaComEscudo && checarColisao(i) && !podeComerBola(i)){
						println("TA COM ESCUDO E COMEU A BOLA");
						if(recordePrincipalBatido()){
							if(jaAbriuEspaco == false){
								abrirEspacoParaMaiorRecorde();
								jaAbriuEspaco = true;
							}
							recordes[recordes.length - 1] = str(pontuacao);
						}
					}
					if(bola[i].checarSeBolaMorreu()){
						bola[i].estaEmCampo = false;
					}
					if(checarColisao(i) && podeComerBola(i)){
						bola[i].estaEmCampo = false;
						comerBolaInimiga(i);
						somarPontos(i);
						gerarBolaNoIndice(i);
						bolasComidas++;
					}
					if(bola[i].estaEmCampo == false){
						gerarBolaNoIndice(i);
					}
				}
				if(bola[i].estaEmCampo){
					bola[i].aplicarMovimentoInimigo();
					desenharBola();
				}
			}
		}
	}
	if(contadorDeBolas < quantMaxBolas){
		gerarBola();
	}
	if(fim == true && estaNoMenuDeEstatisticas == false){
		estaNoMenuDeDerrota = true;
		if(checarSeBateuAlgumRecorde()){
			if(recordePrincipalBatido() == false){
				aplicarAlteracaoNosRecordes();
				salvarRecordes();
				totalDePontos += pontuacao;
				pontuacao = 0;
			}
		}
		if(escudoGerado.estaEmCampo){
			escudoGerado.estaEmCampo = false;
		}
		if(ima.estaEmCampo){
			ima.estaEmCampo = false;
		}
	}
	determinanteDaBoca += 0.4;
	if(determinanteDaBoca >= 200){
		determinanteDaBoca = 0;
	}
	if(recordePrincipalBatido()){
		if(jaAbriuEspaco == false){
			abrirEspacoParaMaiorRecorde();
			jaAbriuEspaco = true;
		}
		recordes[recordes.length - 1] = str(pontuacao);
		salvarRecordes();
	}
	if(estaNoMenuDeDerrota){
		exibirMenuDerrota();
	}
	if(estaNoMenuDeEstatisticas){
		exibirMenuEstatisticas();
	}
	if(estaNasInstrucoes){
		exibirBotaoDePularParaOJogo();
		if(instrucao[0] == true){
			mostrarMensagemDaPrimeiraInstrucao();
			desenharBola();
			aplicarMovimento();
			if(estaSeMovendo()){
				contadorDeInstrucoes -= 0.016666667;
				if(contadorDeInstrucoes <= 0){
					instrutora.definirBola();
					instrucao[0] = false;
					instrucao[1] = true;
				}
			}
		}
		if(instrucao[1] == true){
			instrutora.aplicarMovimentoInimigo();
			mostrarMensagemDaSegundaInstrucao();
			desenharBola();
			aplicarMovimento();
			if(checarColisaoNaInstrucao() == true){
				instrucao[1] = false;
				instrucao[2] = true;
				escudoGerado.gerarEscudoInstrucao();
			}
		}
		if(instrucao[2] == true){
			mostrarMensagemDaTerceiraInstrucao();
			desenharBola();
			aplicarMovimento();
			if(escudoGerado.estaEmCampo){
				escudoGerado.desenhar();
			}
			if(checarSePegouEscudo()){
				escudoGerado.estaEmCampo = false;
				estaComEscudo = true;
				instrucao[2] = false;
				instrucao[3] = true;
				contagemRegressiva = 3;
			}
		}
		if(instrucao[3] == true){
			contagemRegressiva -= 0.01666667;
			mostrarMensagemDaQuartaInstrucao();
			desenharBola();
			aplicarMovimento();
			if(ceil(contagemRegressiva) == 0){
				sairDeTodosMenus();
				partidasJogadas ++;
				instrucao[3] = false;
				estaComEscudo = true;
			}
		}
	}
	if(pontuacao >= 700*nivel){
		nivel++;
		quantMaxBolas = 8 + nivel;
	}
}
void keyPressed(){
	if(key == CODED){
		if (keyCode == LEFT){
			moverEsquerda = true;
			moverDireita = false;
		}
		if (keyCode == UP){
			moverCima = true;
			moverBaixo = false;
		}
		if (keyCode == DOWN){
			moverCima = false;
			moverBaixo = true;
		}
		if (keyCode == RIGHT){
			moverDireita = true;
			moverEsquerda = false;
		}
	}
	if(estaNoMenuDeColocarOIP){
		if(ip.length() > 0){
			if(key == BACKSPACE){
				ip = ip.substring(0, ip.length() - 1);
			}
		}
		if(key != BACKSPACE){
			if(ip.length() > 0 && ip.charAt(ip.length() - 1) == key){

			}
			else{
				ip += key;
			}
		}
		if((ip.length() == 3 || ip.length() == 7 || ip.length() == 9) && key != BACKSPACE){
			ip += ".";
		}
	}
	if(estaComArma){
		if(key == ' '){
			for(int i = 0; i < quantMaxTiros; i++){
				if(!tiro[i].estaEmCampo){
					tiro[i].gerar();
					println("tiro["+i+"] em campo");
					break;
				}
			}
		}
	}
}
void keyReleased(){
	if(key == CODED){
		if(keyCode == UP){
			moverCima = false;
		}
		if(keyCode == DOWN){
			moverBaixo = false;
		}
		if(keyCode == RIGHT){
			moverDireita = false;
		}
		if(keyCode == LEFT){
			moverEsquerda = false;
		}
	}
}
void mandarInformacoes(){
	if(estaSeMovendo()){
		client.write(player + "," + str(int(moverEsquerda)) + "," + str(int(moverCima)) + "," + str(int(moverDireita)) + "," + str(int(moverBaixo)) + "*");
	}
	else{
		client.write(-player + "," + posicaoXDoBoneco + "," + posicaoYDoBoneco + "*");
	}
}
void zerarJogo(){
	fim = false;
	frameQuePegouIma = -700;
	frameQuePegouArma = -700;
	velocidadeBola = 4 + nivel;
	diametroBola = 20*600/tamanhoCanvas;
	posicaoXDoBoneco = 300 - diametroBola;
	posicaoYDoBoneco = 300 - diametroBola;
	pontuacao = 0;
	for(int i = 0; i < quantMaxBolas; i++){
		bola[i].fazerDesaparecer();
		bola[i].definirBola();
	}
	jaAbriuEspaco = false;
}
void mousePressed(){
	if(estaNoMenuInicial){
		if(recordesSelecionado){
			sairDeTodosMenus();
			estaNoMenuDosRecordes = true;
			recordesSelecionado = false;
		}  
		if(novoJogoSelecionado){
			sairDeTodosMenus();
			zerarJogo();
			fim = false;
			partidasJogadas++;
			novoJogoSelecionado = false;
		}
		if(multiplayerSelecionado){
			sairDeTodosMenus();
			estaNoMenuDeColocarOIP = true;
//      estaNoMenuDeEscolhaDeJogador = true;
			multiplayerSelecionado = false;
		}
		if(instrucoesSelecionado){
			sairDeTodosMenus();
			estaNasInstrucoes = true;
			instrucoesSelecionado = false;
			contadorDeInstrucoes = 1;
			posicaoYDoBoneco = 160;
			posicaoXDoBoneco = tamanhoCanvas/2 - diametroBola/2 ;
			instrucao[0] = true;
		}
	}
	if(estaNoMenuDosRecordes){
		if(retornarAoMenuPrincipalSelecionado){
			sairDeTodosMenus();
			estaNoMenuInicial = true;
			retornarAoMenuPrincipalSelecionado = false;
		}
		if(estatisticasSelecionado){
			sairDeTodosMenus();
			estaNoMenuDeEstatisticas = true;
			estatisticasSelecionado = false;
		}
	}
	if(estaNoMenuDeDerrota){
		if(retornarAoMenuPrincipalSelecionado){
			sairDeTodosMenus();
			totalDePontos += pontuacao;
			zerarJogo();
			estaNoMenuInicial = true;
			retornarAoMenuPrincipalSelecionado = false;
		}
		if(tentarNovamenteSelecionado){
			sairDeTodosMenus();
			totalDePontos += pontuacao;
			zerarJogo();
			partidasJogadas++;
			tentarNovamenteSelecionado = false;
		}
	}
	if(estaNoMenuDeEstatisticas){
		if(retornarAosRecordesSelecionado){
			sairDeTodosMenus();
			estaNoMenuDosRecordes = true;
			retornarAosRecordesSelecionado = false;
		}
	}
	if(estaNasInstrucoes){
		if(novoJogoSelecionado){
			sairDeTodosMenus();
			zerarJogo();
			fim = false;
			novoJogoSelecionado = false;
			partidasJogadas++;
		}
	}
	if(estaNoMenuDeColocarOIP){
		if(avancarSelecionado){
			client = new Client(this, ip, 5204);
			sairDeTodosMenus();
			estaNoMenuDeEscolhaDeJogador = true;
			avancarSelecionado = false;
		}
		if(retornarAoMenuPrincipalSelecionado){
			sairDeTodosMenus();
			estaNoMenuInicial = true;
			estaNoMenuDeColocarOIP = false;
			retornarAoMenuPrincipalSelecionado = false;
		}
	}
	if(estaNoMenuDeEscolhaDeJogador){
		if(jogador1Selecionado){
			sairDeTodosMenus();
			player = 1;
			estaNoJogoMultiplayer = true;
			estaNoMenuDeEscolhaDeJogador = false;
			jogador1Selecionado = false;
			jogadoresOnline = 1;
		}
		if(jogador2Selecionado){
			sairDeTodosMenus();
			player = 2;
			estaNoJogoMultiplayer = true;
			estaNoMenuDeEscolhaDeJogador = false;
			jogador2Selecionado = false;
			jogadoresOnline = 1;
		}
		if(retornarAosRecordesSelecionado){
			sairDeTodosMenus();
			retornarAosRecordesSelecionado = false;
			retornarAoMenuPrincipalSelecionado = false;
			estaNoMenuDeEscolhaDeJogador = false;
			estaNoMenuInicial = true;
			client.stop();
		}
	}
}
void desenharBola(){
	if(player == 1){
		if(estaComEscudo){
			if(estaPertoDeInimigoComestivel()){
				image(spriteBocaAbertaComEscudo, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
			else{
				image(spriteBocaFechadaComEscudo, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
		}
		else{
			if(estaPertoDeInimigoComestivel()){
				image(spriteBocaAberta, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
			else{
				image(spriteBocaFechada, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
		}
	}
	if(player == 2){
		if(estaComEscudo){
			if(estaPertoDeInimigoComestivel()){
				image(sprite2BocaAbertaComEscudo, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
			else{
				image(sprite2BocaFechadaComEscudo, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
		}
		else{
			if(estaPertoDeInimigoComestivel()){
				image(sprite2BocaAberta, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
			else{
				image(sprite2BocaFechada, posicaoXDoBoneco, posicaoYDoBoneco, diametroBola, diametroBola);
			}
		}  
	}
}
void desenharParceiro(float x, float y, boolean estaComEscudo, float diametro, boolean bocaAberta){
	if(player == 2){
		if(estaComEscudo){
			if(bocaAberta){
				image(spriteBocaAbertaComEscudo, x, y, diametro, diametro);
			}
			else{
				image(spriteBocaFechadaComEscudo, x, y, diametro, diametro);
			}
		}
		else{
			if(bocaAberta){
				image(spriteBocaAberta, x, y, diametro, diametro);
			}
			else{
				image(spriteBocaFechada, x, y, diametro, diametro);
			}
		}
	}
	else{
		if(estaComEscudo){
			if(bocaAberta){
				image(sprite2BocaAbertaComEscudo, x, y, diametro, diametro);
			}
			else{
				image(sprite2BocaFechadaComEscudo, x, y, diametro, diametro);
			}
		}
		else{
			if(bocaAberta){
				image(sprite2BocaAberta, x, y, diametro, diametro);
			}
			else{
				image(sprite2BocaFechada, x, y, diametro, diametro);
			}
		}  
	}
}
boolean estaPertoDeInimigoComestivel(){
	for(int i = 0; i < quantMaxBolas; i++){
		if(calcularDistanciaBola(posicaoXDoBoneco, posicaoYDoBoneco, bola[i]) <= diametroBola/2 + bola[i].diametro/2 + 20 && podeComerBola(i)){
			return true;
		}
	}
	return false;
}
void exibirTentarNovamente(){
	int x = 300, y = 300;
	Botao tentarNovamente = new Botao();
	tentarNovamente.definir("Jogar novamente", x, y, 220, 100);
	tentarNovamente.desenhar();
	if(tentarNovamente.checarSeEstaSelecionado(mouseX, mouseY)){
		tentarNovamenteSelecionado = true;
	}
	else{
		tentarNovamenteSelecionado = false;
	}
}
void exibirRetornarAoMenuPrincipal(){
	int x = 300, y = 410;
	Botao retornarAoMenuPrincipal = new Botao();
	retornarAoMenuPrincipal.definir("Retornar ao Menu Principal", x, y, 220, 100);
	retornarAoMenuPrincipal.desenhar();
	if(retornarAoMenuPrincipal.checarSeEstaSelecionado(mouseX, mouseY)){
		retornarAoMenuPrincipalSelecionado = true;
	}
	else{
		retornarAoMenuPrincipalSelecionado = false;
	}
}
void exibirVocePerdeu(){
	fill(0);
	textSize(32);
	text("Você perdeu!", 300, 200);
}
void exibirMenuDerrota(){
	exibirTentarNovamente();
	exibirRetornarAoMenuPrincipal();
	exibirVocePerdeu();
}
void exibirBotaoDeIniciarJogo(){
	int x = 300, y = 180;
	Botao iniciarJogo = new Botao();
	iniciarJogo.definir("Novo Jogo", x, y, 220, 100);
	iniciarJogo.desenhar();
	if(iniciarJogo.checarSeEstaSelecionado(mouseX, mouseY)){
		novoJogoSelecionado = true;
	}
	else{
		novoJogoSelecionado = false;
	}
}

void exibirMenuDeEscolhaDoIP(){
	textAlign(CENTER);
	fill(0);
	text("Coloque o IP do host", 300, 200);
	stroke(0);
	rectMode(CENTER);
	fill(255);
	rect(300, 300, 400, 50);
	fill(0);
	text(ip, 300, 310);
	noStroke();
	exibirBotaoDeAvancar();
	exibirRetornar();
}

void exibirMenuDeEscolhaDeJogador(){
	textAlign(CENTER);
	fill(0);
	text("Selecione seu jogador:", 300, 200);
	exibirBotaoJogador1();
	exibirBotaoJogador2();
	desenharRetornarAosRecordes();  
}
void exibirBotaoJogador1(){
	int x = 150, y = 350;
	Botao jogador1 = new Botao();
	jogador1.definir("Jogador 1", x, y, 220, 100);
	jogador1.desenhar();
	if(jogador1.checarSeEstaSelecionado(mouseX, mouseY)){
		jogador1Selecionado = true;
	}
	else{
		jogador1Selecionado = false;
	}
}
void exibirBotaoJogador2(){
	int x = 450, y = 350;
	Botao jogador2 = new Botao();
	jogador2.definir("Jogador 2", x, y, 220, 100);
	jogador2.desenhar();
	if(jogador2.checarSeEstaSelecionado(mouseX, mouseY)){
		jogador2Selecionado = true;
	}
	else{
		jogador2Selecionado = false;
	}  
}
void exibirBotaoDeMultiPlayer(){
	int x = 300, y = 290;
	Botao multiplayer = new Botao();
	multiplayer.definir("Multiplayer", x, y, 220, 100);
	multiplayer.desenhar();
	if(multiplayer.checarSeEstaSelecionado(mouseX, mouseY)){
		multiplayerSelecionado = true;
	}
	else{
		multiplayerSelecionado = false;
	}
}
void exibirBotaoDeInstrucoes(){
	int x = 300, y = 400;
	Botao instrucoes = new Botao();
	instrucoes.definir("Instruções", x, y, 220, 100);
	instrucoes.desenhar();
	if(instrucoes.checarSeEstaSelecionado(mouseX, mouseY)){
		instrucoesSelecionado = true;
	}
	else{
		instrucoesSelecionado = false;
	}
}
void exibirBotaoDeMostrarRecordes(){
	int x = 300, y = 510;
	Botao recordes = new Botao();
	recordes.definir("Recordes", x, y, 220, 100);
	recordes.desenhar();
	if(recordes.checarSeEstaSelecionado(mouseX, mouseY)){
		recordesSelecionado = true;
	}
	else{
		recordesSelecionado = false;
	}
}

void exibirBotaoDeAvancar(){
	int x = 450, y = 520;
	Botao avancar = new Botao();
	avancar.definir("Avançar", x, y, 220, 100);
	avancar.desenhar();
	if(avancar.checarSeEstaSelecionado(mouseX, mouseY)){
		avancarSelecionado = true;
	}
	else{
		avancarSelecionado = false;
	}
}

void exibirTituloDoJogo(){
	fill(0);
	textAlign(CENTER);
	textSize(32);
	text("Jogo", 300, 90);
}
void exibirMenuInicial(){
	exibirTituloDoJogo();
	exibirBotaoDeIniciarJogo();
	exibirBotaoDeMultiPlayer();
	exibirBotaoDeInstrucoes();
	exibirBotaoDeMostrarRecordes();
}

int posicaoDoPrimeiroEmRelacaoAosOutros(float a, float b, float c){
	if(a > b && c > a || a < b && c < a){
				return 2;
	}
	if(a > b && a > c){
				return 1;
	}
	if(a < b && a < c){
				return 3;
	}
	else{
		return 0;
	}
}

void exibirTempoRestanteComArma(){
	int x = 5, y = 70;
	tempoRestanteComArma = ((frameQuePegouArma + 1200 - frameCount)/6)/10.0;
	if(frameCount - frameQuePegouIma < 600){
		tempoRestanteComIma = ((frameQuePegouIma + 600 - frameCount)/6)/10.0;
	}
	if(frameCount - frameQuePegouEscudo < 600){
		tempoRestanteComEscudo = ((frameQuePegouEscudo + 600 - frameCount)/6)/10.0;
	}
	if(tempoRestanteComIma > 0 && tempoRestanteComEscudo > 0){
		switch (posicaoDoPrimeiroEmRelacaoAosOutros(tempoRestanteComArma, tempoRestanteComIma, tempoRestanteComEscudo)) {
			case 1:
				y = 70;
			break;
			case 2:
				y = 110;
			break;
			case 3:
				y = 150;
			break;
		}
	}
	else if(tempoRestanteComEscudo == 0){
		if(tempoRestanteComIma > tempoRestanteComArma){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	else if(tempoRestanteComIma == 0){
		if(tempoRestanteComEscudo > tempoRestanteComArma){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	textAlign(LEFT);
	fill(0);
	text("Arma: " + tempoRestanteComArma, x, y);
}

void exibirTempoRestanteComEscudo(){
	int x = 5, y = 70;
	tempoRestanteComEscudo = ((frameQuePegouEscudo + 600 - frameCount)/6)/10.0;
	if(frameCount - frameQuePegouIma < 600){
		tempoRestanteComIma = ((frameQuePegouIma + 600 - frameCount)/6)/10.0;
	}
	if(frameCount - frameQuePegouArma < 600){
		tempoRestanteComArma = ((frameQuePegouArma + 1200 - frameCount)/6)/10.0;
	}
	if(tempoRestanteComIma > 0 && tempoRestanteComArma > 0){
		switch (posicaoDoPrimeiroEmRelacaoAosOutros(tempoRestanteComEscudo, tempoRestanteComIma, tempoRestanteComArma)) {
			case 1:
				y = 70;
			break;
			case 2:
				y = 110;
			break;
			case 3:
				y = 150;
			break;
		}
	}
	else if(tempoRestanteComArma == 0){
		if(tempoRestanteComIma > tempoRestanteComEscudo){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	else if(tempoRestanteComIma == 0){
		if(tempoRestanteComArma > tempoRestanteComEscudo){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	textAlign(LEFT);
	fill(0);
	text("Escudo: " + tempoRestanteComEscudo, x, y);
}
void exibirTempoRestanteComIma(){
	int x = 5, y = 70;
	tempoRestanteComIma = ((frameQuePegouIma + 600 - frameCount)/6)/10.0;
	if(frameCount - frameQuePegouArma < 600){
		tempoRestanteComArma = ((frameQuePegouArma + 1200 - frameCount)/6)/10.0;
	}
	if(frameCount - frameQuePegouEscudo < 600){
		tempoRestanteComEscudo = ((frameQuePegouEscudo + 600 - frameCount)/6)/10.0;
	}
	if(tempoRestanteComArma > 0 && tempoRestanteComEscudo > 0){
		switch (posicaoDoPrimeiroEmRelacaoAosOutros(tempoRestanteComIma, tempoRestanteComArma, tempoRestanteComEscudo)) {
			case 1:
				y = 70;
			break;
			case 2:
				y = 110;
			break;
			case 3:
				y = 150;
			break;
		}
	}
	else if(tempoRestanteComArma == 0){
		if(tempoRestanteComEscudo > tempoRestanteComIma){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	else if(tempoRestanteComEscudo == 0){
		if(tempoRestanteComArma > tempoRestanteComIma){
			y = 110;
		}
		else{
			y = 70;
		}
	}
	textAlign(LEFT);
	fill(0);
	text("Ima: " + tempoRestanteComIma, x, y);
}
boolean checarSeBateuAlgumRecorde(){
	boolean bool = false;
	for(int i = 0; i < recordes.length; i++){
		if(int(recordes[i]) < pontuacao){
			bool = true;
		}
	}
	return bool;
}
int recordeBatidoNoIndice(){
	for(int i = recordes.length - 1; i >= 0; i--){
		if(pontuacao > int(recordes[i])){
			return i;
		}
	}
	return 283572;
}
void aplicarAlteracaoNosRecordes(){
	String aux;
	recordes[0] = str(pontuacao);
	for(int j = 0; j < recordes.length; j++){
		for(int i = j + 1; i < recordes.length; i++){
			if(int(recordes[i]) < int(recordes[j])){
				aux = recordes[i];
				recordes[i] = recordes[j];
				recordes[j] = aux;
			}
		}
	}
}
boolean recordePrincipalBatido(){
	boolean bool = true;
	for(int i = 0; i < recordes.length; i++){
		if(int(recordes[i]) > pontuacao){
			bool = false;
		}
	}
	return bool;
}
void abrirEspacoParaMaiorRecorde(){
	recordes[0] = str(0);
	for(int i = 0; i < recordes.length; i++){
		if(i + 1 < recordes.length){
			recordes[i] = recordes[i + 1];
		}
	}
}
void mostrarMaiorRecorde(){
	textAlign(CENTER);
	textSize(32);
	text("Recorde: " + recordes[recordes.length - 1], 460, 30);
}
void exibirTodosRecordes(){
	textAlign(CENTER);
	fill(0);
	text("Recordes", tamanhoCanvas/2, 60);
	for(int i = 0; i < recordes.length; i++){
		textSize(20);
		if(int(recordes[9  - i]) == 0){
			if(i == 0){
			fill(0);
			text("Ainda não há recordes para \n serem exibidos", tamanhoCanvas/2, 200);
			}
			break;
		}
		text(i + 1 + "º "+ repetirString(".", 30 - quantAlgarismos(i + 1) - quantAlgarismos(int(recordes[9 - i]))) + recordes[9 - i], tamanhoCanvas/2, 120 + 23*i);
	}
	exibirRetornar();
	exibirBotaoParaEstatisticas();
}
void exibirRetornar(){
	float x = tamanhoCanvas/2, y = 400;
	Botao retornar = new Botao();
	retornar.definir("Retornar", x, y, 220, 100);
	retornar.desenhar();
	if(retornar.checarSeEstaSelecionado(mouseX, mouseY)){
		retornarAoMenuPrincipalSelecionado = true;
	}
	else{
		retornarAoMenuPrincipalSelecionado = false;
	}
}
void exibirBotaoParaEstatisticas(){
	float x = tamanhoCanvas/2, y = 510;
	Botao estatisticas = new Botao();
	estatisticas.definir("Estatísticas", x, y, 220, 100);
	estatisticas.desenhar();
	if(estatisticas.checarSeEstaSelecionado(mouseX, mouseY)){
		estatisticasSelecionado = true;
	}
	else{
		estatisticasSelecionado = false;
	}
}
void atualizarTela(){
	fill(background);
	rectMode(CENTER);
	rect(300, 300, 600, 600);
}
void atualizarEstatisticas(){
	if(partidasJogadas != 0){
		mediaDePontos = totalDePontos*10/partidasJogadas;
		duracaoMediaDasPartidas = tempoTotalDeJogo/partidasJogadas;
		mediaDeBolasComidas = bolasComidas/partidasJogadas;
		mediaDeEscudosPegos = escudosPegos/partidasJogadas;
	}
}
void exibirMenuEstatisticas(){
	desenharBotaoDoTotalDePontos();
	desenharBotaoDePartidasJogadas();
	desenharBotaoDeMediaDePontos();
	desenharBotaoDeBolasComidas();
	desenharBotaoDeTempoTotalDeJogo();
	desenharBotaoDeDuracaoMedia();
	desenharRetornarAosRecordes();
}
void desenharBotaoDoTotalDePontos(){
	float x = tamanhoCanvas/4, y = 80;
	BotaoDeEstatisticas pontuacaoTotal = new BotaoDeEstatisticas();
	pontuacaoTotal.definir("Total de Pontos", x, y, 220, 100);
	pontuacaoTotal.dadoASerExibido = str(totalDePontos);
	pontuacaoTotal.desenharEstatistica();
}
void desenharBotaoDePartidasJogadas(){
	float x = tamanhoCanvas/4, y = 190;
	BotaoDeEstatisticas totalDePartidas = new BotaoDeEstatisticas();
	totalDePartidas.definir("Partidas Jogadas", x, y, 220, 100);
	totalDePartidas.dadoASerExibido = str(partidasJogadas);
	totalDePartidas.desenharEstatistica();
}
void desenharBotaoDeMediaDePontos(){
	float x = tamanhoCanvas/4, y = 300;
	BotaoDeEstatisticas mediaDePontuacao = new BotaoDeEstatisticas();
	mediaDePontuacao.definir("Média de Pontos", x, y, 220, 100);
	mediaDePontuacao.dadoASerExibido = str(mediaDePontos);
	mediaDePontuacao.desenharEstatistica();
}
void desenharBotaoDeBolasComidas(){
	float x = tamanhoCanvas/4, y = 410;
	BotaoDeEstatisticas totalDeBolasComidas = new BotaoDeEstatisticas();
	totalDeBolasComidas.definir("Total de Bolas Comidas", x, y, 220, 100);
	totalDeBolasComidas.dadoASerExibido = str(bolasComidas);
	totalDeBolasComidas.desenharEstatistica();
}
void desenharBotaoDeTempoTotalDeJogo(){
	float x = 3*tamanhoCanvas/4, y = 80;
	String tempoASerExibido;
	if(tempoTotalDeJogo < 60){
		tempoASerExibido = tempoEmSegundos(tempoTotalDeJogo);
	}
	else if(tempoTotalDeJogo < 3600){
		tempoASerExibido = tempoEmMinutos(tempoTotalDeJogo);
	}
	else{
		tempoASerExibido = tempoEmHoras(tempoTotalDeJogo);
	}
	BotaoDeEstatisticas totalDeTempoEmJogo = new BotaoDeEstatisticas();
	totalDeTempoEmJogo.definir("Tempo Total em Partida", x, y, 220, 100);
	totalDeTempoEmJogo.dadoASerExibido = tempoASerExibido;
	totalDeTempoEmJogo.desenharEstatistica();
}
void desenharBotaoDeDuracaoMedia(){
	float x = 3*tamanhoCanvas/4, y = 200;
	String tempoASerExibido;
	if(duracaoMediaDasPartidas < 60){
		tempoASerExibido = tempoEmSegundos(duracaoMediaDasPartidas);
	}
	else if(duracaoMediaDasPartidas < 3600){
		tempoASerExibido = tempoEmMinutos(duracaoMediaDasPartidas);
	}
	else{
		tempoASerExibido = tempoEmHoras(duracaoMediaDasPartidas);
	}
	BotaoDeEstatisticas duracaoMedia = new BotaoDeEstatisticas();
	duracaoMedia.definir("Duração Média das Partidas", x, y, 220, 100);
	duracaoMedia.dadoASerExibido = tempoASerExibido;
	duracaoMedia.desenharEstatistica();
}
void desenharRetornarAosRecordes(){
	float x = tamanhoCanvas/2, y = 520;
	Botao retornarAosRecordes = new Botao();
	retornarAosRecordes.definir("Retornar", x, y, 220, 100);
	retornarAosRecordes.desenhar();
	if(retornarAosRecordes.checarSeEstaSelecionado(mouseX, mouseY)){
		retornarAosRecordesSelecionado = true;
	}
	else{
		retornarAosRecordesSelecionado = false;
	}
}
boolean estaSomenteNosRecordes(){
	if(estaNoMenuDeEstatisticas == false
	 && estaNoMenuDeDerrota == false
		&& estaNoMenuInicial == false
		 && estaNoMenuDosRecordes == true){
		return true;
	}
	else{
		return false;
	}
}
boolean estaSomenteNoMenuInicial(){
	if(estaNoMenuDosRecordes == false
	 && estaNoMenuDeDerrota == false
		&& estaNoMenuDeEstatisticas == false
		 && estaNoMenuInicial == true){
		return true;
	}
	else{
		return false;
	}
}
boolean estaSomenteNoMenuDeDerrota(){
	if(estaNoMenuInicial == false
	 && estaNoMenuDosRecordes == false
		&& estaNoMenuDeEstatisticas == false
		 && estaNoMenuDeDerrota == true){
		return true;
	}
	else{
		return false;
	}
}
boolean estaSomenteNoMenuDeEstatisticas(){
	if(estaNoMenuDosRecordes == false
	 && estaNoMenuDeDerrota == false
		&& estaNoMenuInicial == false
		 && estaNoMenuDeEstatisticas == true){
		return true;
	}
	else{
		return false;
	}
}
boolean naoEstaEmNenhumMenu(){
	if(!estaNoMenuDosRecordes
	 && !estaNoMenuDeDerrota
		&& !estaNoMenuInicial
		 && !estaNoMenuDeEstatisticas
		&& !estaNasInstrucoes
		 && !estaNoJogoMultiplayer
			&& !estaNoMenuDeEscolhaDeJogador
			 && !estaNoMenuDeColocarOIP){
		return true;
	}
	else{
		return false;
	}
}
int tamanhoRecomendadoPara(String str){
	if(str.length() < 15){
		return 32;
	}
	else{
		return 32 - (str.length() - 13);
	}
}
String tempoEmMinutos(float tempo){
	String tempoASerExibido;
	if(int(tempo/60) == 1){
		tempoASerExibido = str(int(tempo/60)) + " minuto ";
	}
	else{
		tempoASerExibido = str(int(tempo/60)) + " minutos ";
	}
	if(int(tempo)%60 == 1){
		tempoASerExibido += "e " + int(tempo%60) + " segundo";
	}
	else if(int(tempo)%60 != 0){
		tempoASerExibido += "e " + int(tempo%60) + " segundos";
	}
	return tempoASerExibido;
}
String tempoEmHoras(float tempo){
	String tempoASerExibido;
	if(int(tempo)/3600 == 1){
		tempoASerExibido = int(tempo)/3600 + " hora ";
	}
	else{
		tempoASerExibido = int(tempo)/3600 + " horas ";
	}
	if((int(tempo)%3600)/60 == 1){
		tempoASerExibido += "e " + (int(tempo)%3600)/60 + " minuto";
	}
	else if((int(tempo)%3600)/60 != 0){
		tempoASerExibido += "e " + (int(tempo)%3600)/60 + " minutos";
	}
	return tempoASerExibido;
}
String tempoEmSegundos(float tempo){
	String tempoASerExibido;
	if(int(tempo) == 1){
		tempoASerExibido = int(tempo) + " segundo";
	}
	else{
		tempoASerExibido = int(tempo) + " segundos";
	}
	return tempoASerExibido;
}
void salvarEstatisticas(){
	estatisticas[0] = str(totalDePontos);
	estatisticas[1] = str(partidasJogadas);
	estatisticas[2] = str(tempoTotalDeJogo);
	estatisticas[3] = str(escudosPegos);
	estatisticas[4] = str(bolasComidas);
	saveStrings("estatisticas.txt", estatisticas);
}
void salvarRecordes(){
	saveStrings("recordes.txt", recordes);
}
void sairDeTodosMenus(){
	estaNoMenuDeDerrota = false;
	estaNoMenuDeEstatisticas = false;
	estaNoMenuDosRecordes = false;
	estaNoMenuInicial = false;
	estaNasInstrucoes = false;
	estaNoMenuDeEscolhaDeJogador = false;
	estaNoMenuDeColocarOIP = false;
}
boolean estaSeMovendo(){
	if(moverEsquerda == true || moverDireita == true || moverCima == true || moverBaixo == true){
		return true;
	}
	else{
		return false;
	}
}
void mostrarMensagemDaPrimeiraInstrucao(){
	textAlign(CENTER);
	fill(0);
	text("Este é o Dhammapada experimente usar as setas para movê-lo", 50, 10, 500, 300);
}
void mostrarMensagemDaSegundaInstrucao(){
	fill(0);
	textAlign(CENTER);
	text("Muito bem, agora veja como ele abre e fecha a boca, está faminto, direcione-o até as bolas menores que ele, como essa no canto inferior", 50, 10, 500, 400);
}
void mostrarMensagemDaTerceiraInstrucao(){
	fill(0);
	textAlign(CENTER);
	text("Aleatoriamente irão surgir escudos como esse, se você pegar, terá 10 segundos de imunidade e um aumento na velocidade", 50, 10, 500, 300);
}
void exibirBotaoDePularParaOJogo(){
	float x = tamanhoCanvas/4, y = 540;
	Botao pularParaOJogo = new Botao();
	pularParaOJogo.definir("Pular para o Jogo", x, y, 220, 100);
	pularParaOJogo.desenhar();
	if(pularParaOJogo.checarSeEstaSelecionado(mouseX, mouseY)){
		novoJogoSelecionado = true;
	}
	else{
		novoJogoSelecionado = false;
	}
}
void mostrarMensagemDaQuartaInstrucao(){
	fill(0);
	text("Ótimo, você já sabe como jogar, a sua partida vai começar em " + ceil(contagemRegressiva), 100, 10, 400, 300);
}
String repetirString(String str, int fator){
	String texto = str;
	for(int i = 0; i < fator - 1; i++){
		texto += str;
	}
	return texto;
}
/*void exibirMudancaDeNivel(){
	fill(0);
	textAlign(CENTER);
	text("Você passou de nível, a partida voltará em " + floor(contadorDeEspera), tamanhoCanvas/2 - 150, tamanhoCanvas/2 - 100, 300, 300);
}
*/
