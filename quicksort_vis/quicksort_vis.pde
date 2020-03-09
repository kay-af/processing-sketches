int a[];
int n,q;

boolean canReset;

void setup()
{
   size(800,300,P2D);
   n=width/8;
   a=new int[n];
   
   for(int i=0;i<n;i++)
   {
     a[i]=(int)random(height-60)+5;
   }
   
   canReset=false;
   
   thread("sort");
}

void draw()
{
  background(30);
  
  strokeWeight(6);
  strokeCap(PROJECT);
  
  for(int i=0;i<n;i++)
  {
    stroke(255);
    if(i==q)
      stroke(255,0,0);
    else if(i<q)
      stroke(0,255,0);
    line((8*i)+5,height,(8*i)+5,height-a[i]);
  }
  
  fill(128);
  textAlign(LEFT);
  text("Number of elements: "+n, 10, 20);
  text("Pivot: "+(q+1),10,40);
  
  if(canReset)
  {
    textAlign(CENTER);
    fill(255,0,0);
    text("Press \"Space\" to reset",width/2,20);
  }
}

void sort()
{
  quicksort(a,0,n-1);
  q=n-1;
  canReset=true;
}

void quicksort(int a[], int p, int r)
{
  if(p<r)
  {
    delay(100);
    q=partition(a,p,r);
    quicksort(a,p,q-1);
    quicksort(a,q+1,r);
  }
}

int partition(int a[], int p, int r)
{
  int x=a[r],i=p-1;
  
  for(int j=p;j<r;j++)
  {
    if(a[j]<=x)
    {
      i++;
      swap(a,i,j);
    }
  }
  swap(a,i+1,r);
  return i+1;
}

void swap(int a[], int i, int j)
{
  int t=a[j];
  a[j]=a[i];
  a[i]=t;
}

void keyPressed()
{
  if(key==32 && canReset)
  {
    setup();
  }
}
