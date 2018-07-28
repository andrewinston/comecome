import processing.net.*;
Server server;
Client client;
int tamanhoCanvas = 600;
float[] informacoes;
float diametroBoneco;
String stringBruta = "";
String incomingMessage = "";
int player;
float posX;
float posY;
boolean estaComEscudo;
float diametro;
boolean bocaAberta;

void setup(){
	size(200,200);
	server = new Server(this, 5204/*, "192.168.0.13"*/);
	background(255);
}

void draw(){
	background(255);
	Client client = server.available();
	if(client != null){
		stringBruta = client.readStringUntil('*');
		//informacoes = float(splitTokens(stringBruta, ",*"));
		//println(stringBruta);
	//	String infoBola = bolaGerada();
	//	println(infoBola);
	//	server.write(infoBola);
		println(stringBruta);
		server.write(stringBruta);
		/*player = int(informacoes[0]);
		posX = informacoes[1];
		posY = informacoes[2];
		estaComEscudo = boolean(int(informacoes[3]));
		diametro = informacoes[4];
		bocaAberta = boolean(int(informacoes[5]));
		server.write(player + "," + posX + "," + posY + "," + estaComEscudo + "," + diametro + "," + bocaAberta + "*");
		*/
	}
}

void serverEvent(Server server, Client client) {
	incomingMessage = "A new client has connected:" + client.ip();
	println(incomingMessage);
}

String bolaGerada(){
	String str = "3,";
	int deOndeSai = floor(random(0,4));
	str += deOndeSai + ",";
	int pos = floor(random(0, 600));
	str += pos + "*";
	//println(str);
	return str;
}


