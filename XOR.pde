double input[] = new double[2];

double weights1[] = new double[4];
double weights2[] = new double[2];
double bias[] = new double[3];

double weights1Best[] = new double[4];
double weights2Best[] = new double[2];
double biasBest[] = new double[3];

double best = Double.MAX_VALUE;
int iterations = 0;
boolean start = false;

int rounds = 0;
void setup() {
  randomize();
  fullScreen();
}

void randomize() {
  // Init weights1
  for (int i = 0; i < weights1.length; i++) {
    weights1[i] = random(10) - 5;
  }
  // Init weights2
  for (int i = 0; i < weights2.length; i++) {
    weights2[i] = random(10) - 5;
  }
  // Init bias
  for (int i = 0; i < bias.length; i++) {
    bias[i] = random(10) - 5;
  }
}

float compute(double first, double second) {
  input[0] = first;
  input[1] = second;

  // Convert input to hidden layer
  double hidden[] = new double[2];
  for (int i = 0; i < input.length; i++) {
    hidden[0] += input[i] * weights1[2*i];
    hidden[1] += input[i] * weights1[2*i + 1];
  }

  hidden[0] = Math.tanh(hidden[0] + bias[0]);
  hidden[1] = Math.tanh(hidden[1] + bias[1]);

  // Convert hidden layer to output
  float output = (float)(hidden[0] * weights2[0] + hidden[1] * weights2[1]);

  output = (float)(Math.tanh(output + bias[2]));
  return min(1, max(0, output));
}

double test() {
  double error = 0;
  error += abs(0 - compute(0, 0));
  error += abs(1 - compute(0, 1));
  error += abs(1 - compute(1, 0));
  error += abs(0 - compute(1, 1));

  return error;
}


void draw() {
  rounds++;
  if (keyPressed && key == 'r') start = true;
  
  background(color(150, 170, 200));

  int x = 500;
  int y = 400;
  int xgap = 300;
  int ygap = 300;
  int textlength = 4;

  textSize(170);
  text("XOR Neural Network", 1920/2, 100);
  

  textSize(32);
  strokeWeight(5);
  textAlign(CENTER, CENTER);

  // Lines
  line(x, y, x + xgap, y);
  line(x, y, x + xgap, y + ygap);

  line(x, y + ygap, x + xgap, y);
  line(x, y + ygap, x + xgap, y + ygap);

  line(x + xgap, y, x + 2*xgap, y + ygap/2);
  line(x + xgap, y + ygap, x + 2*xgap, y + ygap/2);


  // Neurons
  for (int i = 0; i < 2; i++) {
    fill(255);
    ellipse(x, y + i*ygap, 100, 100);
  }

  // Hidden layer
  for (int i = 0; i < 2; i++) {
    fill(255);
    ellipse(x + xgap, y + i*ygap, 100, 100);

    fill(0);
    String s = Double.toString(biasBest[i]);
    text(s.substring(0, Math.min(s.length(), textlength)), x + xgap, y + i*ygap);
  }

  // Output
  fill(255);
  ellipse(x + 2*xgap, y + ygap/2, 100, 100);

  fill(0);
  String s = Double.toString(biasBest[2]);
  text(s.substring(0, Math.min(s.length(), textlength)) , x + 2*xgap, y + ygap/2);

  // Weights
  
  for (int i = 0; i < weights1Best.length; i++){
    fill(255);
    s = Double.toString(weights1Best[i]);
    text(s.substring(0, Math.min(s.length(), textlength)), x + xgap/2, y - ygap/8 + i*ygap/2.5);
  }

  // Draw error
  textSize(64);
  text("Iterations", x + 1000, y);
  textSize(48);
  text(iterations, x + 1000, y +100);
  
  if (!start) return;
  
  textSize(64);
  text("Error", x + 1000, y + 200);
  textSize(48);
  s = Double.toString(best);
  text(s, x + 1000, y + 300);

  textSize(50);

  fill((rounds) % 255, (rounds + 128) % 255, 255);
  text("Subscribe Daporan!", 1300, 900);
  fill(255, 255, 255);
  ///////////////////////////////////////////////
  
  // Train
  for (int j = 0; j < 10; j++) {
    iterations++;
    randomize();

    double score = test();  
    if (score < best) {
      best = score; 

      // Copy current weights into best
      for (int i = 0; i < weights1.length; i++) {
        weights1Best[i] = weights1[i];
      }
      for (int i = 0; i < weights2.length; i++) {
        weights2Best[i] =  weights2[i];
      }
      for (int i = 0; i < bias.length; i++) {
        biasBest[i] = bias[i];
      }

      print("iteration: " + j + ", score: " + best + "\n");
    }
  }
}
