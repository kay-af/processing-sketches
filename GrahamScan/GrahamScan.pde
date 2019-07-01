// Convex hull using Graham's Scan Algorithm
import java.util.*;

// The list of vertices
ArrayList<PVector> vertices;

// Upon calculation, it will store the edge data using which, hull will be drawn
ArrayList<PVector> out_edges;

void setup()
{
  size(800,600,P2D);
  
  out_edges = new ArrayList<PVector>();
  vertices = new ArrayList<PVector>();
}

// Handle adding and removing points/vertices
// Left click to add
// Right click near a point to remove
void mouseReleased()
{
  if(mouseButton == LEFT && vertices.size() < 50)
    vertices.add(new PVector(mouseX, mouseY)); 
  else if(mouseButton == RIGHT)
  {
    // Check if the clicked position is near any vertex
    // If so, delete that vertex
    for(int i=0; i<vertices.size(); i++)
    {
      PVector res = sub(vertices.get(i), new PVector(mouseX, mouseY));
      // within a range of approximately 30 pixels
      if(res.mag() <= 30)
      {
        vertices.remove(i);
        break;
      }
    }
  }
  
  // Algorithm only runs when a mouse event is generated and not every frame
  // This way draw function has a lesser load to take care of
  // Vertices are already added or removed above so we can now calculate new hull
  // Convex hull is only applicable for more than 2 vertices
  if(vertices.size() >= 3)
    GrahamScan();
}

void draw()
{
  // Some styling :D
  background(41);
  
  // When there are more than 3 vertices, only then shall the hull be drawn.
  // The out_edges are already calculated at removal or insertion of vertices through click events so its guaranteed that every,
  // draw call will have out_edges ready to work with if number of vertices is greater than 2
  if(vertices.size() >= 3)
  {
    fill(0,180,0,60);
    stroke(180);
    strokeWeight(2);
    beginShape();
    // Draw the hull using out_edges
    for(PVector v : out_edges)
    {
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
  }
  
  // Draw the vertices on top of hull edges
  stroke(255);
  strokeWeight(8);
  for(PVector vertex : vertices)
    point(vertex.x, vertex.y);
    
  // Draw help text
  fill(255);
  textSize(12);
  text("Left click to add a point", 10, 30);
  text("Right click on a point to remove it", 10, 50); 
}

// Simple implementation of graham scan algorithm using stack
void GrahamScan()
{
  // Get the bottomost vertex index to start with
  int bottom = 0;
  for(int i=1; i<vertices.size(); i++)
  {
    PVector vertex = vertices.get(i);
    if(vertex.y > vertices.get(bottom).y) // +Y is downwards
      bottom = i;
  }
  
  // Make a copy of vertices to work with as we will be deleting bottom [when using the algorithm, its better when the bottom is excluded]
  // and sorting the list based on angles with X axis
  ArrayList<PVector> tverts = (ArrayList<PVector>)vertices.clone();
  PVector b = tverts.get(bottom);
  tverts.remove(bottom);
  
  // Sorting the vertices according to angles using simple bubble sort
  for(int i=0; i<tverts.size(); i++)
  {
    for(int j=0; j<tverts.size()-i-1; j++)
    {
      float aj = angle(sub(tverts.get(j), b)); // Subtract the vectors to get a vector pointing from bottomost vertex to the current vertex and get its angle wrt Vector (1,0)
      float aj1 = angle(sub(tverts.get(j+1),b)); // Similarly for next
      if(aj > aj1)
      {
        PVector t = tverts.get(j);
        tverts.set(j,tverts.get(j+1));
        tverts.set(j+1,t);
      }
    }
  }
  
  // The stack is useful here in this algorithm
  Stack<PVector> stack = new Stack<PVector>();
  
  // Push bottomost vertex
  stack.push(b);
  
  // Push the next sorted one
  stack.push(tverts.get(0));
  
  // The rest is a simple implementation of Graham's scan algorithm
  float lastAngle = angle(sub(tverts.get(0), b));
  
  for(int i=1; i<tverts.size(); i++)
  {
    float curAngle = angle(sub(tverts.get(i), stack.peek()));
    if(curAngle >= lastAngle)
    {
      stack.push(tverts.get(i));
      lastAngle = curAngle;
    }
    else
    {
      while(curAngle < lastAngle)
      {
        stack.pop();
        curAngle = angle(sub(tverts.get(i), stack.peek()));
        PVector temp = stack.pop();
        lastAngle = angle(sub(temp, stack.peek()));
        stack.push(temp);
      }
      lastAngle = curAngle;
      stack.push(tverts.get(i));
    }
  }
  
  // New out_edges are here
  out_edges.clear();
  while(!stack.isEmpty())
  {
    out_edges.add(stack.pop()); // The vertices that belong to convex hull
  }
}

// Subtract Vector v2 from Vector v1
PVector sub(PVector v1, PVector v2)
{
  return new PVector(v1.x - v2.x, v1.y - v2.y);
}

// Find the angle between v and X axis
float angle(PVector v)
{
  float a = PVector.angleBetween(v, new PVector(1, 0));
  if(v.y > 0)
    a = TWO_PI-a;
  return a;
}
