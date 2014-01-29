/*
* Cory Shaw   cory.shaw.dev@gmail.com
* 
* BlinkyMusicShow - A processing program for BlinkyTapes to visualize any sound input 
*                   based on sound energy, rather than frequency energy. 
* 
*/

import processing.serial.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

BlinkyTape bt = null;
Minim minim;
AudioInput in;
AudioPlayer song;
FFT fft;
PFont font;
SerialSelector s;

int sliders = 1;
int smoothedRed = 0;
int smoothedBlue = 0;
int smoothedGreen = 0;
boolean beat, mp3, randomAnim;
int smoother = 1;
float amp;
int count, count2, anim, window, wave, k;
int RED, GREEN, BLUE;
int beattime;
BeatDetect beat2;

void setup() {
  frameRate(60);
  
  s = new SerialSelector();
  
  size(800, 500); //window size

  colorMode(RGB);
  background(0);
  minim = new Minim(this);
  beat2 = new BeatDetect();
  in = minim.getLineIn(Minim.STEREO, 1024);
  beat2.detect(in.mix);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  beat2.setSensitivity(300);
  fft.logAverages(100, 4);
  rectMode(CORNERS);
  
  //Initiate variables
  count = count2 = 0;
  anim = 1;
  randomAnim = false;
  beat = false; //Start as false for music to start
  window = 1;
  k = 0;
  beattime = 0;
}


void draw()
{
  //Take the selected serial and create a BlinkyTape object out of it
  if(s != null && s.m_chosen){
    s.m_chosen = false; //So there aren't multiple BlinkyTapes of the same serial
    bt = new BlinkyTape(this, s.m_port, 60);
    s = null; //So there aren't multiple BlinkyTapes of the same serial
  }
  
  beat2.detect(in.mix);
  fill(0, 255);
  rect (0, 0, width, height);
  float[] leds = new float[fft.avgSize()];
  if(beat) fill(0, 200, 200, 50);
  rect(0, 0, width, height);
  fill(150);
  fft.forward(in.mix);
  int w = int(width/fft.avgSize());
  
  //For text
  fill(255);
  translate(10, 15);
  textFont(createFont("Arial", 18));
  String txt = "Animation : " + anim + "/14";
  if(randomAnim)
    txt = txt + " [random]";
  txt = txt + "\nSmooth Colors: " + smoother;
  text(txt,0,+textAscent()/2);
      
  for(int i = 0; i < fft.avgSize() && sliders == 1; i++)
  {
    float fftout = fft.getAvg(i);
    amp = constrain(fftout*exp(fftout*.01)*exp(i/8)*.5, 0, 255);
    if(window == 1){
      fill(color(RED-20, GREEN-20, BLUE-20)); //for different colored borders
      rect(i*w, height/2, i*w + w, height/2 - amp); //this draws the scaled spectrum
      rect(i*w, height/2, i*w + w, height/2 + amp);
      fill(color(RED, GREEN, BLUE));
      rect(i*w, height/2, i*w + w, height/2 - fftout*2); //this draws raw spectrum on top
      rect(i*w, height/2, i*w + w, height/2 + fftout*2);
      leds[i] = amp;
    }
  }
  
  float sum = leds[0] + leds[1] + leds[2];
  
  if(sliders == 1){
    if(sum > 730.00) //this checks two bass bands and considers peaks to be a beat
      beat = true;
    else 
      beat = false;
    if(anim == 1) anim1(leds);
    else if(anim == 2) anim2(leds);
    else if(anim == 3) anim3(leds);
    else if(anim == 4) anim4(leds);
    else if(anim == 5) anim5(leds);
    else if(anim == 6) anim6(leds);
    else if(anim == 7) anim7(leds);
    else if(anim == 8) anim8(leds);
    else if(anim == 9) anim9(leds);
    else if(anim == 10) anim10(leds);
    else if(anim == 11) anim11(leds);
    else if(anim == 12) anim11(leds);
    else if(anim == 13) anim11(leds);
    else if(anim == 14) anim11(leds);
  }//endif sliders = 1
  else
    drawSliders();
  
  if(smoother == 1){
      smoothVals();
      RED = smoothedRed;
      GREEN = smoothedGreen;
      BLUE = smoothedBlue;
    }
    
    //**CREATE COLOR AND PUSH ONTO BOARD**//
    
      color c = color(RED, GREEN, BLUE);
      if(bt != null) {
        for(int i = 0; i < 60; i++) { //60 leds on the BlinkyTape
            bt.pushPixel(c);
        }
        bt.update();
      }
    
    count++; //counts number of cycles since this anim started

    if(count > 200 && beat) { //this makes sure a certain amount of time passes
      if(randomAnim)
        anim = int(random(1, 14)); //changes animation to random one
      count = 0;
      count2 = 0;
    }
    
    if(beat) 
      count2 = 0;
    
    if(!beat){ //this times how long its been since a beat. after a certain point,
      count2++; // counts how long since a beat
      if(count2 > 400){
        if(randomAnim)
          anim = int(random(1, 14)); //change anim if no beats for a while
        count2 = 0;
      }
    }
    
}//end draw

void smoothVals(){
  float filterVal = 0.2;
  
  if (filterVal > 1){ // check to make sure param's are within range
    filterVal = .99;
  }
  else if (filterVal <= 0){
    filterVal = 0;
  }
  
  smoothedRed = int((RED * (1 - filterVal)) + (smoothedRed * filterVal));
  smoothedGreen = int((GREEN * (1 - filterVal)) + (smoothedGreen * filterVal));
  smoothedBlue = int((BLUE * (1 - filterVal)) + (smoothedBlue * filterVal));

}
  
void keyReleased(){
  if(key == '1'){ //this increments the animation
    if(anim == 14)
      anim = 1;
    else
      anim += 1;
  }
  else if(key == '2'){ //this decrements the animation
    if(anim == 1)
      anim = 14;
    else
      anim -= 1;
  }
  else if(key == '3') //this resets animation to 1
    anim = 1;
  else if(key == 'f') //this toggles smoother color functionality
    smoother *= -1;
  else if(key == 'r'){ //this randomizes animations
    if(randomAnim)
      randomAnim = false;
    else
      randomAnim = true;
  }  
  else if(key == 's'){ //this toggles sliders
    sliders *= -1; 
  }
}
  
void drawSliders(){ //Turn lights bright and visualizer off
  RED = 255;
  GREEN = 255;
  BLUE = 255;
  background(RED, GREEN, BLUE);
      fill(122, map(.07,0,22,255,-100));
      translate(10, 15);
      textFont(createFont("Arial", 18));
      text("SUCK IT TREBEK",0,+textAscent()/2);
}
  
/*ANIMATIONS
* Each of the bands from the fft are within the led array
* Below are the APPROXIMATE values that are worth noting to make new animations
*
* leds[2]   = bass
* leds[6]   = usually voices, sometimes hi-hats
* leds[15]  = snares
*
*/

//Color changes periodically
void anim1(float leds[]) {
  k++;
  
  float angle = 0.001*k;
  float sinmap = map(sin(angle), -1, 1, 0, fft.avgSize() - 1); //this creates a periodic fft band shifter
  float cosmap = map(cos(angle*2), -1, 1, 0, fft.avgSize() - 1);
  float sinmap2 = map(cos(2 + angle*3), -1, 1, 0, fft.avgSize() - 1);
  
  RED = int(leds[int(sinmap)]);
  GREEN = int(leds[int(cosmap)]);
  BLUE = int(leds[int(sinmap2)]);
  
  if(beat) getColor(); //getColor pulses a random color on every detected beat
}

//Visualize from bass on blue only opposite on beat detect
void anim2(float leds[]) {
  RED = 0;
  GREEN = 0;
  BLUE = int(leds[2]);
  if(beat) {
    int pRED = RED; //pRED is a placeholder variable for previous RED array location
    RED = GREEN;
    int pGREEN = GREEN;
    GREEN = BLUE;
    int pBLUE = BLUE;
    BLUE = RED;
  }
}

//Visualize from bass on red only opposite on beat detect
void anim3(float leds[]) {
  RED = int(leds[2]);
  GREEN = 0;
  BLUE = 0;
  if(beat) {
    BLUE = RED;
    GREEN = RED;
    RED = GREEN;
  }
}

//Visualize from red and green only on snare high blue on beat detect
void anim4(float leds[]) {
  RED = int(leds[15]*2);
  GREEN = int(leds[15]*.25);
  BLUE = 0;
  if(beat){
    BLUE = 255;
  }
}

//Periodic color change high blue/green on beat detect 
void anim5(float leds[]) {
  k++;
  
  float angle = 0.08*k; //change for speed of color change EPILEPTIC WARNING IF SET TOO HIGH
  float sinmap = map(sin(angle), -1, 1, 0, fft.avgSize() - 1); //this creates a periodic fft band shifter
  float cosmap = map(cos(angle*2), -1, 1, 0, fft.avgSize() - 1);
  float sinmap2 = map(cos(2 + angle*3), -1, 1, 0, fft.avgSize() - 1);
  
  RED = int(leds[int(sinmap)]);
  GREEN = int(leds[int(cosmap)]);
  BLUE = int(leds[int(sinmap2)]);
  if(beat) {
    BLUE = int(leds[2]);
    GREEN = int(leds[2]);
    RED = 0;
  }
}

//Brighter green on bass random color on beat detect
void anim6(float leds[]) {
  RED = 0;
  GREEN = int(leds[2]);
  BLUE = 0;
  if(beat) {
    getColor();
  }
}

//
void anim7(float leds[]) {
  RED = int(leds[15]);
  GREEN = 0;
  BLUE = int(leds[6]);
  if(beat) {
    BLUE = int(leds[2]);
    GREEN = int(leds[2]);
    RED = int(leds[2]);
  }
}

void anim8(float leds[]) {
  RED = int(leds[15]*.8);
  GREEN = 0;
  BLUE = int(leds[15]*.25);
  if(beat){
    BLUE = 255;
    RED = 255;
  }
}

void anim9(float leds[]) {
  RED = int(leds[15]*.8);
  GREEN = 0;
  BLUE = int(leds[15]*.5);
  if(beat){
    BLUE = 255;
    RED = 255;
  }
}

void anim10(float leds[]) {
  RED = 0;
  GREEN = 10;
  BLUE = 10;
  if(beat){
    BLUE = 255;
    GREEN = 255;
  }
}

void anim11(float leds[]) {
  RED = 0;
  GREEN = int(leds[15]);
  BLUE = int(leds[0]*2);
  if(beat){
    BLUE = 255;
    RED = 255;
  }
}

void anim12(float leds[]) {
  RED = 10;
  GREEN = 10;
  BLUE = 10;
  if(beat){
    RED = 255;
    BLUE = 255;
    GREEN = 255;
  }
}

void anim13(float leds[]) {
  RED = 0;
  GREEN = 0;
  BLUE = 10;
  if(beat){
    RED = 0;
    BLUE = 255;
    GREEN = 0;
  }
}

void anim14(float leds[]) {
  RED = 10;
  GREEN = 30;
  BLUE = 10;
  if(beat){
    RED = 200;
    BLUE = 255;
    GREEN = 100;
  }
}

void getColor() {
  int temp = int(random(0, 7));  
  switch(temp){
    case '1': //blue
      BLUE = 255;
      GREEN = 0;
      RED = 0;
      break;
    case '2': //green
      BLUE = 0;
      GREEN = 255;
      RED = 0;
      break;
    case '3': //cyan
      BLUE = 255;
      GREEN = 255;
      RED = 0;
      break;
    case '4': //fuschia
      BLUE = 255;
      GREEN = 0;
      RED = 255;
      break;
    case '5': //yellow
      BLUE = 0;
      GREEN = 255;
      RED = 255;
      break;
    case '6': //pink
      BLUE = 150;
      GREEN = 150;
      RED = 255;
      break;
  }
}



