int[][] state;
float res; 
int zoom;
int rows, cols;
int R, C;

String sample = "universalturing.rle";
String[] lines;
String sample_rle = "";    
        
RLEdecoder decoder;
int Gen = 0;

boolean check(float x, float y) {
  return (0 <= x && x < R && 0 <= y && y < C);
}

void settings() {
  lines = loadStrings(sample);
  for (String line: lines) {
    // println ("line = ", line);
    sample_rle += line;
    sample_rle += "\n";
  }
  // println (sample_rle);
  decoder = new RLEdecoder(sample_rle);
  int[][] pattern = decoder.get_pattern();
  //decoder.print();
  rows = decoder.rows;
  cols = decoder.cols; 
  res = 0.1;
  zoom = 1;
  R = rows * zoom; C = cols * zoom;
  size((int)(rows * res * zoom), (int)(cols * res * zoom) + 50);
  state = new int[R][C];
  for (int i = 0; i < R; ++i) {
    for (int j = 0; j < C; ++j) {
      state[i][j] = 0;
    }
  }
  for (int i = 0; i < rows; ++i) {
    for (int j = 0; j < cols; ++j) {
      state[i + floor(R / 2) - floor(rows / 2)][j + floor(C / 2) - floor(cols / 2)] = pattern[i][j];   
    }
  }
  
}

void setup() {
  frameRate(64);
}

void draw() {
  background(255);
  textSize(30);
  textAlign(CENTER);
  text("Gen = " + str(Gen), width / 2, height - 15);
  for (int i = 0; i < R; i++) {
    for (int j = 0; j < C; j++) {
      //print(i, j, R, C);
      if (state[i][j] == 1) {
        fill(0);
        stroke(0);
        rect(i * res, j * res, res, res);
      }
    }
  }
  
  for (int step = 0; step < 8; ++step){
  int new_state[][] = new int[R][C];
  for (int i = 0; i < R; i++) {
    for (int j = 0; j < C; j++) {
      int live = 0;
      for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
          int ii = i + dx;
          int jj = j + dy;
          if (!check(ii, jj) || (ii == i && jj == j)) {
            continue; 
          }
          if (state[ii][jj] == 1) live += 1;
        }
      }

      if (state[i][j] == 1) {
        //println(i, j, live, state[i][j]);
        boolean ok = false;
        for (int s: decoder.survival_rules) {
          if (live == s) {
            ok = true;
            break;
          }
        }
        
        new_state[i][j] = int(ok == true);
        //println(i, j, live, new_state[i][j]);
      }
      else {
        //println(i, j, live, state[i][j]);
        boolean ok = false;
        for (int b: decoder.birth_rules) {
          if (live == b) {
            ok = true;
            break;
          }
        }
        
        new_state[i][j] = int(ok == true);
        //println(i, j, live, new_state[i][j]);
      }
    }
  }
  
  state = new_state;
  Gen++;
  }

}

void mousePressed() {
  int x = int(mouseX / res);
  int y = int(mouseY / res);
  state[x][y] = 1;
  fill(0);
  rect(x * res, y * res, res, res);
}
