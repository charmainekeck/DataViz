import java.util.*;
import controlP5.*;

HashMap<Integer, Patient> patients;
ArrayList<VentilationRateGraph> graphsDrawn;

ControlP5 cp;
float controlX, controlY;
int wX, wY, wWidth, wHeight;
Textlabel minRangeLabel, maxRangeLabel;
PVector minSlider, maxSlider;

// Toggles
boolean peepON;
boolean fio2ON;
boolean pipON;
boolean phON;

boolean aON, bON, cON, dON, eON, fON, gON, hON, pcON, vcON, prvcON, hfovON;




void setup() {
  pcON = true;
  vcON = true;
  prvcON = true;
  hfovON = true;

  aON = true;
  bON = true;
  cON = true;
  dON = true;
  eON = true;
  fON = true;
  gON = true;
  hON = true;

  size(displayWidth, displayHeight - 150);
  background(240);

  loadPatients();
  createControls();

  createGraphWidget();
  graphsDrawn = new ArrayList<VentilationRateGraph>();
  updateGraphsDrawn();
}

void draw() {
  // Clear graph widget by painting over it
  noStroke();
  fill(240);
  rect(wX-5,wY-5,wWidth+10,wHeight+10);

  updateWeightSlider();
  updateGraphsDrawn();

  for (VentilationRateGraph graph : graphsDrawn)
    graph.display();
}

void loadPatients() {
  patients = new HashMap<Integer, Patient>();

  String[] lines = loadStrings("Aim1Data.csv");
  String[] headers = lines[0].split(",");
  for (int i = 1; i < lines.length; i++)
  {
    String[] line = lines[i].split(",");

    int subjectID = Integer.parseInt(line[0]);
    Patient p = patients.get(subjectID);
    if(p == null)
    {
      p = new Patient(headers);
      patients.put(subjectID, p);
    }

    p.addDataRow(line);
  }
}

void createGraphWidget()
{
  wX = 300;
  wY = 50;
  wHeight = height - (2*wY);
  wWidth = width - wX - wY;
  rect(wX,wY,wWidth,wHeight);
}

void createControls() {
  // FIXME: ranges should be created dynamically from data
  float minRange = 2;
  float maxRange = 83.7;

  controlX = 40;
  controlY = 40;
  cp = new ControlP5(this);

  PFont mainFont = createFont("Serif-24", 24);
  PFont attrFont = createFont("Avenir-HeavyOblique-16", 16);

  textFont(mainFont);
  fill(150);
  text("Oxygenation:", controlX, controlY);
  text("Ventilation:", controlX, controlY+100);
  text("Filters:", controlX, controlY+ 200 );

  textFont(attrFont);
  //textSize(16);
  text("PEEP", controlX + 50, controlY +30);
  text("FiO2", controlX + 50, controlY +60);
  text("PIP", controlX + 50, controlY + 130);
  text("pH", controlX +50, controlY +160);
  text("Vent Mode:", controlX, controlY +230);
  text("Pressure Control", controlX + 50, controlY +250);
  text("Volume Control", controlX + 50, controlY +280);
  text("PRVC", controlX +  50, controlY + 310);
  text("HFOV", controlX +  50, controlY + 340);
  text("Site: ", controlX, controlY +380);
  text("A", controlX + 50, controlY + 410);
  text("B", controlX + 110, controlY + 410);
  text("C", controlX + 50, controlY + 440);
  text("D", controlX + 110, controlY + 440);
  text("E", controlX + 50, controlY + 470);
  text("F", controlX + 110, controlY + 470);
  text("G", controlX + 50, controlY + 500);
  text("H", controlX + 110, controlY + 500);
  text("Weight Range:", controlX, controlY +525);
  stroke(150);
  textFont(attrFont);
  text("2", controlX +20, controlY + 580);
  text("83.7", controlX + 190, controlY +580);

  minSlider = new PVector(controlX +20, controlY +550);
  maxSlider = new PVector(controlX +210, controlY +550);
  minRangeLabel =  cp.addTextlabel("minRange")
    .setText(""+minRange)
    .setColorValue(150)
    .setPosition(minSlider.x, minSlider.y-15);

  maxRangeLabel = cp.addTextlabel("maxRange")
    .setText(""+maxRange)
    .setColorValue(150)
    .setPosition(maxSlider.x, maxSlider.y - 15);

  setUPButtons();
  setUpToggles();

}

public void PEEP() {
  peepON = !peepON;
}

public void PIP() {
  pipON = !pipON;
}

public void pH() {
  phON = !phON;
}

public void FiO2() {
  fio2ON = !fio2ON;
}

public void setUPButtons() {
  cp.addButton("PEEP")
    .setPosition(controlX +20, controlY +12)
    .setSize(20,20)
    .setColorForeground(color(38, 127, 252))
    .setColorBackground(color(38, 127, 252))
    .getCaptionLabel()
    .hide();

  cp.addButton("FiO2")
    .setPosition(controlX +20, controlY +45)
    .setSize(20,20)
    .setColorForeground(color(4, 214, 8))
    .setColorBackground(color(4, 214, 8))
    .getCaptionLabel()
    .hide();

  cp.addButton("PIP")
    .setPosition(controlX +20, controlY +112)
    .setSize(20,20)
    .setColorForeground(color(180, 101, 204))
    .setColorBackground(color(180, 101, 204))
    .getCaptionLabel()
    .hide();

  cp.addButton("pH")
    .setPosition(controlX +20, controlY +145)
    .setSize(20,20)
    .setColorForeground(color(252, 163, 38))
    .setColorBackground(color(252, 163, 38))
    .getCaptionLabel()
    .hide();
}

public void setUpToggles(){
  int y1= 430;
  String[] filterToggles1 = {"a", "c", "e", "g"};
  String[] filterToggles2 = {"b", "d", "f", "h"};
  String[] filterToggles3 = {"pc", "vc", "prvc", "hfov"};

  for( int i = 0; i < 4; ++i ) {
    cp.addToggle(filterToggles1[i])
      .setPosition( controlX +20, y1+ 30 * i )
      .setSize( 20, 20 )
      .setColorForeground(color(180, 180, 180))
      .setColorBackground(color(180, 180, 180))
      .setValue( true )
      .plugTo( this, filterToggles1[i]+"ON" )
      .getCaptionLabel()
      .hide();
  }

  int x1 = 120;
  y1=430;
  for( int i = 0; i < 4; ++i ) {
    cp.addToggle(filterToggles2[i])
      .setPosition( x1, y1+ 30 * i )
      .setSize( 20, 20 )
      .setColorForeground(color(180, 180, 180))
      .setColorBackground(color(180, 180, 180))
      .setValue( true )
      .plugTo( this, filterToggles2[i]+"ON" )
      .getCaptionLabel()
      .hide();
  }

  y1=275;
  for( int i = 0; i < 4; ++i ) {
    cp.addToggle(filterToggles3[i])
      .setPosition( controlX + 20, y1+ 30 * i )
      .setSize( 20, 20 )
      .setColorForeground(color(180, 180, 180))
      .setColorBackground(color(180, 180, 180))
      .setValue( true )
      .plugTo( this, filterToggles3[i]+"ON" )
      .getCaptionLabel()
      .hide();
  }
}

void updateWeightSlider()
{
  //background(240);
  noStroke();
  fill(240);
  rect(controlX - 20, controlY +530, 260, 30);
  stroke(150);
  strokeWeight(2);
  line(controlX+20, controlY+550, controlX+210, controlY+550);

  fill(150);
  ellipse(minSlider.x, minSlider.y, 10,10);
  ellipse(maxSlider.x, maxSlider.y, 10,10);
  minRangeLabel.draw(this);
  minRangeLabel.setPosition(minSlider.x, minSlider.y-15);
  maxRangeLabel.draw(this);
  maxRangeLabel.setPosition(maxSlider.x, maxSlider.y -15);

  noStroke();
  noFill();
}

void  updateGraphsDrawn()
{
  ArrayList<Patient> filteredPatients = filteredPatients();
  graphsDrawn.clear();

  double r = Math.ceil(Math.sqrt(filteredPatients.size()));
  float boxWidth = (float)(wWidth / r);
  float boxHeight = boxWidth / wWidth * wHeight;
  for (int i = 0; i < filteredPatients.size(); i++)
  {
    float boxX = (float)(wX + wWidth * (i%r) / r);
    float boxY = (float)(wY + wHeight * (int)(i/r) / r);

    graphsDrawn.add(new VentilationRateGraph(boxX, boxY, boxWidth, boxHeight, filteredPatients.get(i)));
  }
}

public void mouseDragged()
{
  // FIXME: ranges should be created dynamically from data
  float minRange = 2;
  float maxRange = 83.7;

  float radius = 20;
  float minX = 60;
  float maxX = 250;
  float diff = (83.7 - 2);
  float percent = 0;
  //if (pmouseX > point.x - radius && pmouseX < point.x + radius && pmouseY < point.y + radius && pmouseY > point.y - radius)
  if (pmouseX > (minSlider.x - radius) && pmouseX < (minSlider.x + radius) && pmouseY < (minSlider.y + radius) && pmouseY > (minSlider.y - radius)) {
    if((pmouseX + radius) >= maxSlider.x) {
      minSlider.set(minSlider.x , minSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      minRange = (2+(percent* diff));
      minRangeLabel.setText(""+String.format("%.2f", minRange));
      return;
    }

    if (pmouseX <= minX) {
      minSlider.set(minX, minSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      minRange = (2+(percent* diff));

      minRangeLabel.setText(""+String.format("%.2f", minRange));
      return;
    }

    if (pmouseX >= (maxX - 2*radius)) {
      minSlider.set((maxX - radius), minSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      minRange = (2+(percent* diff));
      minRangeLabel.setText(""+String.format("%.2f", minRange));
      return;
    } else {
      minSlider.set(pmouseX, minSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      minRange = (2+(percent* diff));
      minRangeLabel.setText(""+String.format("%.2f", minRange));
    }
  }

  if (pmouseX > (maxSlider.x - radius) && pmouseX < (maxSlider.x + radius) && pmouseY < (maxSlider.y + radius) && pmouseY > (maxSlider.y - radius)) {
    if((pmouseX - radius) <= minSlider.x) {
      maxSlider.set(maxSlider.x, maxSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      maxRange = (2 + (percent * diff));
      maxRangeLabel.setText(""+String.format("%.2f", maxRange));
      return;
    }

    if (pmouseX <= (minX + radius)) {
      maxSlider.set((minX+ radius), maxSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      maxRange = (2 + (percent * diff));
      maxRangeLabel.setText(""+String.format("%.2f", maxRange));
      return;
    }

    if (pmouseX >= (maxX /*- radius*/)) {
      maxSlider.set(maxX, maxSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      maxRange = (2 + (percent * diff));
      maxRangeLabel.setText(""+String.format("%.2f", maxRange));
      return;
    } else {
      maxSlider.set(pmouseX, maxSlider.y);
      percent = ((pmouseX - minX)/ (maxX - minX));
      maxRange = (2 + (percent * diff));
      maxRangeLabel.setText(""+String.format("%.2f", maxRange));
    }
  }
}

private ArrayList<Patient> filteredPatients()
{
  ArrayList<Patient> filteredPatients = new ArrayList<Patient>(patients.values());

  for (Patient p : patients.values())
  {
    String site = p.getSite();

    String vent = p.getVentMode();
    if (p.getWeight() < Float.parseFloat(minRangeLabel.get().getText()))
      filteredPatients.remove(p);
    else if (p.getWeight() > Float.parseFloat(maxRangeLabel.get().getText()))
      filteredPatients.remove(p);
    else if (!aON && site.toLowerCase().equals("a"))
      filteredPatients.remove(p);
    else if (!bON && site.toLowerCase().equals("b"))
      filteredPatients.remove(p);
    else if (!cON && site.toLowerCase().equals("c"))
      filteredPatients.remove(p);
    else if (!dON && site.toLowerCase().equals("d"))
      filteredPatients.remove(p);
    else if (!eON && site.toLowerCase().equals("e"))
      filteredPatients.remove(p);
    else if (!fON && site.toLowerCase().equals("f"))
      filteredPatients.remove(p);
    else if (!gON && site.toLowerCase().equals("g"))
      filteredPatients.remove(p);
    else if (!pcON && vent.toLowerCase().equals("pressure control"))
      filteredPatients.remove(p);
    else if (!vcON && vent.toLowerCase().equals("volume control"))
      filteredPatients.remove(p);
    else if (!prvcON && vent.toLowerCase().equals("prvc"))
      filteredPatients.remove(p);
    else if (!hfovON && vent.toLowerCase().equals("hfov"))
      filteredPatients.remove(p);


  }

  return filteredPatients;
}

class VentilationRateGraph {
  private final static int MAXVENTRATE = 50;
  private final static int MAXPEEP = 22;
  private final static float MAXFIO2 = 1.0;
  private final static int MAXPIP = 50;
  private final static int MAXPH = 14;

  Patient patient;
  float x, y, wWidth, wHeight;
  private float dotRadius;

  VentilationRateGraph(float x, float y, float wWidth, float wHeight, Patient patient) {
    this.patient = patient;
    this.x = x;
    this.y = y;
    this.wWidth = wWidth;
    this.wHeight = wHeight;

    this.dotRadius = max(wWidth, wHeight) / 50;
  }

  void display() {
    stroke(100);
    strokeWeight(1);
    fill(255);
    rect(x, y, wWidth, wHeight);

    long maxTime = patient.getMaxTime();
    if (maxTime <= 0)
      return;

    PVector prev = null;
    for (Reading r : patient.getReadings()) {
      float timePercent = (float)r.getTime() / maxTime;
      float ventRatePercent = (float)r.getVentilatorRate() / MAXVENTRATE;
      if (ventRatePercent <= 0.0)
        continue;

      float ventX = x + timePercent * wWidth;
      float ventY = (y + wHeight) - ventRatePercent * wHeight;

      fill(150);
      ellipse(ventX, ventY, dotRadius, dotRadius);

      if (prev != null) {
        line(prev.x, prev.y, ventX, ventY);
        prev.set(ventX, ventY);
      } else {
        prev = new PVector(ventX, ventY);
      }
    }

    if (peepON)
      displayPEEP();
    if (fio2ON)
      displayFiO2();
    if (pipON)
      displayPIP();
    if (phON)
      displayPh();
  }

  private void displayPEEP() {
    long maxTime = patient.getMaxTime();
    if (maxTime <= 0)
      return;

    for (Reading r : patient.getReadings()) {
      float timePercent = (float)r.getTime() / maxTime;
      float peepPercent = (float)r.getPeep() / MAXPEEP;
      if (peepPercent <= 0.0)
        continue;

      float peepX = x + timePercent * wWidth;
      float peepY = (y + wHeight) - peepPercent * wHeight;
      noStroke();
      fill(color(38,127,252));
      ellipse(peepX, peepY, dotRadius, dotRadius);
    }
  }

  private void displayFiO2() {
    long maxTime = patient.getMaxTime();
    if (maxTime <= 0)
      return;

    for (Reading r : patient.getReadings()) {
      float timePercent = (float)r.getTime() / maxTime;
      float fio2Percent = r.getFiO2() / MAXFIO2;
      if (fio2Percent <= 0.0)
        continue;

      float fio2X = x + timePercent * wWidth;
      float fio2Y = (y + wHeight) - fio2Percent * wHeight;
      noStroke();
      fill(color(4,214,8));
      ellipse(fio2X, fio2Y, dotRadius, dotRadius);
    }
  }

  private void displayPIP() {
    long maxTime = patient.getMaxTime();
    if (maxTime <= 0)
      return;

    for (Reading r : patient.getReadings()) {
      float timePercent = (float)r.getTime() / maxTime;
      float pipPercent = (float)r.getPip() / MAXPIP;
      if (pipPercent <= 0.0)
        continue;

      float pipX = x + timePercent * wWidth;
      float pipY = (y + wHeight) - pipPercent * wHeight;
      noStroke();
      fill(color(180,101,204));
      ellipse(pipX, pipY, dotRadius, dotRadius);
    }
  }

  private void displayPh() {
    long maxTime = patient.getMaxTime();
    if (maxTime <= 0)
      return;

    for (Reading r : patient.getReadings()) {
      float timePercent = (float)r.getTime() / maxTime;
      float phPercent = (float)r.getpH() / MAXPH;
      if (phPercent <= 0.0)
        continue;

      float phX = x + timePercent * wWidth;
      float phY = (y + wHeight) - phPercent * wHeight;
      noStroke();
      fill(color(252,163,38));
      ellipse(phX, phY, dotRadius, dotRadius);
    }
  }

}
