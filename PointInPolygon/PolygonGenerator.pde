class Point
{
  float posX;
  float posY;
  float radius;
  color col;
  public Point(float _x, float _y)
  {
    this.posX = _x;
    this.posY = _y;
    radius = 6;
    
    col = color(0,0,0);
  }
  public Point(Point t)
  {
    this.posX = t.posX;
    this.posY = t.posY;
  }
  public void setRenderColor(float r, float g, float b)
  {
    col = color(r,g,b);
  }
  public void renderPoint()
  {
    stroke(col);
    ellipse(posX, posY, radius, radius);
  }
}

class Edge
{
  Point A;
  Point B;
  color col;
  public Edge(Point _a, Point _b)
  {
    this.A = new Point(_a);
    this.B = new Point(_b);
    col = color(255,0,0);
  }
  public void setRenderColor(float r, float g, float b)
  {
    col = color(r,g,b);
  }
  
  public void renderEdge()
  {
    stroke(col);
    line(A.posX, A.posY, B.posX, B.posY);
  }
  public Point getTopPoint()
  {
    if(A.posY <= B.posY)
      return A;
    return B;
  }
  public Point getBottomPoint()
  {
    if(A.posY >= B.posY)
      return A;
    return B;
  }
  public Point getLeftPoint()
  {
    if(A.posX <= B.posX)
      return A;
    return B;
  }
  public Point getRightPoint()
  {
    if(A.posX >= B.posX)
      return A;
    return B;
  }
  public boolean isHorizontal()  
  {
    return (A.posY == B.posY);
  }
}
class Polygon
{
  
  ArrayList<Point> vertices;
  ArrayList<Edge> edges;
  public Polygon()
  {
    vertices = new ArrayList<Point>();
    edges = new ArrayList<Edge> ();
  }
  public void reset()
  {
    this.vertices.clear();
    this.edges.clear();
  }
  public boolean isPointInside(Point p)
  {
    int intersection=0;
    float py = p.posY;
    float px = p.posX;
    for(int i=0; i<edges.size(); i++)
    {
      Point _top = edges.get(i).getTopPoint();
      Point _bottom = edges.get(i).getBottomPoint();
      Point _left = edges.get(i).getLeftPoint();
      Point _right = edges.get(i).getRightPoint();
          
      if((_left.posX > px) || (_bottom.posY < py) || (_top.posY > py)){
        edges.get(i).setRenderColor(0,0,255); 
        continue;
      }
      if(_top.posY == _bottom.posY){ //ignore horizontal lines completely
        edges.get(i).setRenderColor(175,175,175);
        continue;
      }
      
      PVector vec_testPoint = new PVector(px, py);
      PVector vecTop = new PVector(_top.posX, _top.posY);
      PVector vecBottom = new PVector(_bottom.posX, _bottom.posY);
  
      PVector top2test = PVector.sub(vec_testPoint,vecTop);
      PVector top2bottom = PVector.sub(vecBottom, vecTop);
      
      //signed angle
      float t2b = atan2(top2bottom.y, top2bottom.x);
      float t2t = atan2(top2test.y, top2test.x);
      if(t2b - t2t < 0){
        edges.get(i).setRenderColor(255,255,0);
        continue;
      }
      /*
      if test-point is at same elevation as one of the point on edge then
      we need to decide whether we need to consider intersection with both the edges 
      or only 1 edge. 
      
      intersection with both edge iff (i.e +0 or +2)
        1. the Point-of-intersection(common point) is the "bottom" or "top" in both the edges.  (i.e the remaining 2 points must be either both above or below the ray.
      otherwise, just intersect with only 1 edge
            
            we can also say, if for a given edge, there is a point at same elevation as test-point,
              check if the other vertex of this edge is "above" the ray, if yes => count intersection with this edge
              else, ignore the edge. 
            note that horizontal edges will be ignored in this method automatically without special check.
            
      */
      if(py == _top.posY || py == _bottom.posY)
      {
        Edge currentEdge = edges.get(i);
        if(currentEdge.getTopPoint().posY == py)
          continue;
      } 
      edges.get(i).setRenderColor(0,255,0);
      intersection++;
    }
    if(intersection % 2 == 1) //odd, => inside
      return true;
    return false;
  }
  public void renderPolygon()
  {
    
    //render all edges 
    for(int i=0; i<edges.size(); i++)
      edges.get(i).renderEdge();
    //render all points
    for(int i=0; i<vertices.size(); i++)
      vertices.get(i).renderPoint();
      
  }
  
  public void addVertex(float x, float y)
  {
    //create new point
    Point newVertex = new Point(x, y);
   
    //if current point is not the first point
    if(this.vertices.size() > 0)
    {
      //get ref to last point inserted
      Point oldPoint = this.vertices.get(this.vertices.size() - 1);
      if(oldPoint.posX == x && oldPoint.posY == y)
        return;
      //create edge between new and last point
      this.vertices.add(newVertex);
      this.edges.add( new Edge(oldPoint, newVertex) );
      
      if(this.edges.size() > 2)
      {
        this.edges.remove(this.edges.size() - 2);
      }
      
      //in case we have only 2 vertices, we need to make bi-directional edge
      //in order to make sure ray intersect 2 edges and so all points are treated 
      //outside.
      this.edges.add( new Edge(this.vertices.get(0), newVertex));
    }
    else this.vertices.add(newVertex);
  }
  
}

Polygon polygon = new Polygon();
boolean poly_mode = true;
ArrayList<Point> testPoints = new ArrayList<Point>(); //The list of test-points, i.e whether these points are inside or outside.

void setup()
{
  size(700, 650);
  background(0);
  strokeWeight(2);
  frameRate(50);
  
  PFont myFont = createFont("FFScala", 18);
  textFont(myFont); 
  text("vertices : "+polygon.vertices.size(), 10, 20);
  
  polygon.addVertex(100, 200);
  polygon.addVertex(150, 200);
  polygon.addVertex(150, 150);
  polygon.addVertex(180, 150);
  polygon.addVertex(180, 400);
  polygon.addVertex(100, 400);
  
  //now add test 
  testPoints.add(new Point(160,200));
}

void draw()
{
  float startTime = millis();
  
  rect(0,0, width, height);
  polygon.renderPolygon();
  
  
    for(int i=0; i<testPoints.size(); i++)
    {
      
      boolean inside = polygon.isPointInside(testPoints.get(i));
      if(inside)
        testPoints.get(i).setRenderColor(0, 255, 0);
      else testPoints.get(i).setRenderColor(255, 0, 0);
    
      
      testPoints.get(i).renderPoint();
    }
  
  float endTime = millis();
  fill(0);
  text("vertices : "+polygon.vertices.size(), 10, 25);
  text("edges : " + polygon.edges.size(), 10, 45);
  text("press P to place test points", 10, 70);
  text("press G to continue building polygon", 10, 95);
  text("press R to remove polygon", 10, 120);
  text("press M to remove test-points", 10, 145);
  
  text("Total Time Taken(ms): "+(endTime-startTime), 10, 600);
  text("Test Points : " + testPoints.size(), 10, 620);
  fill(255,255,255);
  
}

void mousePressed()
{
  if(poly_mode)
    polygon.addVertex(mouseX, mouseY);
  else 
    testPoints.add(new Point(mouseX, mouseY));
}

void keyPressed()
{
  if(key=='r' || key =='R')
    polygon.reset();
  else if(key=='p' || key == 'P') // P for point-mode (i.e place test points)
    poly_mode = false;
  
  else if(key=='g'  || key =='G') // G for geometry-mode (i.e make polygon/geometry)
    poly_mode = true;
  else if(key == 'M' || key=='m')
    testPoints.clear();
  
}