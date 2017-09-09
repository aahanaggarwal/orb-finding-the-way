class Ball{
  DNA dna=new DNA();
  PVector pos=new PVector();
  PVector vel=new PVector();
  PVector acc=new PVector();
  boolean dead;
  
  int count=1;
  
  float fitness;
  float maxFitness;
  
  public Ball(DNA dna){
    this.dna = dna;
    pos.x=width/2;
    pos.y=height;
  }
  public void show(){
    strokeWeight(3);
    float mag=vel.mag();
    vel.setMag(50);
    line(pos.x, pos.y, (pos.x+vel.x), (pos.y+vel.y));
    ellipse(pos.x, pos.y, ballRad,ballRad);
    vel.setMag(mag);
  }
  void update(){
    if(dna.genes[count]==null)
      dna.genes[count]=PVector.random2D();
    if(!this.dead)
      acc.add(dna.genes[count]);
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
    count++;
  }
  boolean isDead(){
    boolean outOfBounds = (pos.x>width||pos.x<0||pos.y>height||pos.y<0);
    boolean hitRect1=((pos.x>0&&pos.x<gapLoc.x)&&(pos.y>height/2&&pos.y<height/2+ballRad+gapHeight));
    boolean hitRect2=((pos.x>gapLoc.y&&pos.x<width)&&(pos.y>height/2&&pos.y<height/2+ballRad+gapHeight));
    
    return hitRect1||hitRect2||outOfBounds;
  }
}