
class Circle
{
  PVector pos;
  float diameter;
  float radius;

  color renderColor = color(225,25,25);
  color fillColor;
  public Circle(PVector pos, float d)
  {
    this.pos = new PVector(pos.x, pos.y);
    this.diameter = d;
    this.radius = d/2;
  }
  public void render()
  {
    fill(fillColor);
    stroke(renderColor);
    ellipse(pos.x, pos.y, diameter, diameter);
  }
};

ArrayList<Circle> sceneObjects = new ArrayList<Circle>();

float signDistCircle(PVector mousePos, Circle circle)
{
  float dist_centers =(PVector.sub(circle.pos, mousePos)).mag();
  return (dist_centers - circle.radius);
}
void setup()
{
  sceneObjects.add(new Circle(new PVector(250, 250), 50));
  sceneObjects.add(new Circle(new PVector(150, 150), 75));
  sceneObjects.add(new Circle(new PVector(100, 250), 75));
  sceneObjects.add(new Circle(new PVector(300, 440), 75));
  sceneObjects.add(new Circle(new PVector(450, 440), 75));
  sceneObjects.add(new Circle(new PVector(450, 240), 175));
  size(500, 500);
}
void draw()
{
  background(255);
  float minRad=1000;
  Circle currentComparator = sceneObjects.get(0);

  for(int i=0; i<sceneObjects.size(); i++)
  {
    sceneObjects.get(i).render();
    //get minimum distance
    float tmp= signDistCircle(new PVector(mouseX, mouseY), sceneObjects.get(i));
    if(tmp < minRad){
      minRad = tmp;
      currentComparator = sceneObjects.get(i);
    }
  }
  fill(color(125,125,125));
  ellipse(mouseX, mouseY, minRad*2, minRad*2);
  line(mouseX, mouseY, currentComparator.pos.x, currentComparator.pos.y);

}
