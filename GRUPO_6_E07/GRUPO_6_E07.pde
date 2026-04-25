Table datos;
Cancion[] top;

int maxSongs = 20;
float radioMin = 18;
float radioMax = 55;

void setup() {
  size(900, 700);
  textFont(createFont("Futura", 12));
  textAlign(CENTER, CENTER);

  datos = loadTable("spotify-2023.csv", "header");
  if (datos == null) {
    println("No se pudo cargar spotify-2023.csv");
    exit();
  }

  int total = min(maxSongs, datos.getRowCount());
  top = new Cancion[total];

  for (int i = 0; i < total; i++) {
    TableRow row = datos.getRow(i);

    // Más arriba en la tabla => círculo más grande.
    float radio = map(i, 0, max(1, total - 1), radioMax, radioMin);

    float x = random(radio, width - radio);
    float y = random(radio + 40, height - radio);
    color c = color(random(50, 255), random(50, 255), random(50, 255));

    top[i] = new Cancion(row.getString("track_name"), x, y, radio, c);
  }
}

void draw() {
  background(50);
  fill(0);

  for (Cancion c : top) {
    c.dibujar();
    c.mostrarNombreSiHover();
  }
}

class Cancion {
  String nombre;
  float x, y, radio;
  color c;

  Cancion(String nombre, float x, float y, float radio, color c) {
    this.nombre = nombre;
    this.x = x;
    this.y = y;
    this.radio = radio;
    this.c = c;
  }

  void dibujar() {
    fill(c);
    stroke(0);
    strokeWeight(0); //<>//
    ellipse(x, y, radio * 2, radio * 2);
  }

  void mostrarNombreSiHover() {
    if (dist(mouseX, mouseY, x, y) < radio) {
      float brillo = brightness(c);
      fill(brillo < 128 ? 255 : 0);
      noStroke();
      textSize(12);
      text(nombre, x, y);
    }
  }
}
