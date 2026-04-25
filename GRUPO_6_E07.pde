Table datos;
Cancion[] top;

int maxSongs = 12;
float radioMin = 18;
float radioMax = 55;

int seleccion = -1;

void setup() {
  size(900, 700);
  textFont(createFont("Futura", 12));
  textAlign(CENTER, CENTER);

  datos = loadTable("spotify-2023.csv", "header");

  int total = min(maxSongs, datos.getRowCount());
  top = new Cancion[total];

  float centroX = width/2;
  float centroY = height/2;
  float radioCirculo = 230;

  for (int i = 0; i < total; i++) {

    TableRow row = datos.getRow(i);

    float ang = map(i, 0, total, 0, TWO_PI);

    float x = centroX + cos(ang) * radioCirculo;
    float y = centroY + sin(ang) * radioCirculo;

    float dance = row.getFloat("danceability_%");
    float energy = row.getFloat("energy_%");

    float radio = map(dance, 0, 100, radioMin, radioMax);
    color c = color(energy * 2.5, dance * 2, 255, 150);

    top[i] = new Cancion(
      row.getString("track_name"),
      row.getString("artist(s)_name"),
      x, y, radio, c, dance, energy);
  }
}

void draw() {
  background(20);

  for (int i = 0; i < top.length; i++) {
    top[i].dibujar();
  }

  if (seleccion != -1) {

    Cancion c = top[seleccion];

    fill(255);
    textSize(26);
    text(c.nombre, width/2, height/2 - 10);

    textSize(16);
    text(c.artista, width/2, height/2 + 20);


    text("Danceability: " + nf(c.dance, 0, 1) + "%", width/2, height - 60);
    text("Energy: " + nf(c.energy, 0, 1) + "%", width/2, height - 40);
  }
}


void mousePressed() {

  seleccion = -1;

  for (int i = 0; i < top.length; i++) {

    if (dist(mouseX, mouseY, top[i].x, top[i].y) < top[i].radio) {

      seleccion = i;
      break;
    }
  }
}

class Cancion {

  String nombre;
  String artista;
  float x;
  float y;
  float radio;
  color c;
  float dance;
  float energy;

  Cancion(String nombre, String artista, float x, float y, float radio, color c, float dance, float energy) {

    this.nombre = nombre;
    this.artista = artista;
    this.x = x;
    this.y = y;
    this.radio = radio;
    this.c = c;
    this.dance = dance;
    this.energy = energy;
  }

  void dibujar() {

    noStroke();
    fill(c);
    ellipse(x, y, radio*2, radio*2);
  }
}
