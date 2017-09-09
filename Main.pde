float ballRad=30;
float targetRad=120;
float gapWidth=100;
float gapHeight=40;
int popSize=200;
float totMutationRate=0.01;
float indMutationRate=0.0005;

Ball[] population = {null};
Ball[] empty={null};

boolean paused=true;
boolean editGap=false;
boolean editTarget=false;

int lifeSpan=200;
int permLifeSpan=lifeSpan;
float genMaxFitness=0;
float allTimeFitness=0;
boolean hit=false;

float gapStart=600;
PVector gapLoc=new PVector(gapStart,gapStart+gapWidth);
PVector targetPos=new PVector(400,200);;

int noOfGenes=1000;

void setup(){
  size(800, 1600);
  frameRate(120);
  for(int i=0; i<popSize; i++){
    population=(Ball[])append(population, new Ball(new DNA()));
  }
}

void draw(){
  background(51);
  fill(255);
  textSize(20);
  text("All time max Fitness: "+allTimeFitness, 0, 20);
  if(allTimeFitness>=999)
    hit=true;
  if(hit)
    text("TARGET ACHIEVED", 0, 40);
  if(editGap&&paused){
      gapStart=mouseX;
      gapLoc=new PVector(gapStart,gapStart+gapWidth);
  }
  if(editTarget&&paused){
    targetPos=new PVector(mouseX, mouseY);
  }
  fill(100,100,255);
  rect(0, height/2, gapLoc.x, gapHeight); 
  rect(gapLoc.y, height/2, width, gapHeight); 
  fill(255,255,100);
  ellipse(targetPos.x, targetPos.y, targetRad, targetRad);
  if(paused){
    fill(255,20,20);
    for(int i=0; i<popSize; i++){
      if(population[i]!=null){
        population[i].dead=population[i].isDead();
        if(!population[i].dead){
          population[i].show();
        }
      }
    }
  }
  else{
    editTarget=false;
    editGap=false;
    lifeSpan--;
    fill(100,255,100);
    for(int i=0; i<popSize; i++){
      if(population[i]!=null){
        population[i].dead=population[i].isDead();
        if(!population[i].dead){
          population[i].update();
          population[i].show();
          float curFitness=calcFitness(population[i]);
          if(curFitness>population[i].maxFitness)
            population[i].maxFitness=curFitness;
          if(curFitness>genMaxFitness)
            genMaxFitness=curFitness;
        }
        if(lifeSpan<0){
          setUpGen();
        }
      }
    }
  }
}

void setUpGen(){
  System.out.println(genMaxFitness);
  if(genMaxFitness>allTimeFitness)
    allTimeFitness=genMaxFitness;
  genMaxFitness=0;
  lifeSpan=permLifeSpan;
  Ball[] newGen=evolve(population);
  population=empty;
  population=newGen;
}

Ball[] evolve(Ball[] pop){
  Ball[] mat={null};
  for(int i=0; i<pop.length; i++){
    if(pop[i]!=null)
      for(int j=0; j<(pop[i].maxFitness*2); j++){
        pop[i].count=0;
        mat=(Ball[])append(mat, pop[i]);
      }
  }
  Ball[] newGen={null};
  for(int i=0; i<popSize; i++){
    newGen=(Ball[])append(newGen, crossover(pickRandomElement(mat), pickRandomElement(mat)));
  }
  for(int i=0; i<newGen.length; i++){
    if(newGen[i]!=null){
      PVector[] base=newGen[i].dna.genes;
      for(int j=0; j<base.length; j++){
        float chance=random(0,1);
        if(chance<totMutationRate){
          base[j]=PVector.random2D();
        }
      }
      newGen[i].dna.genes=base;
    }
  }
  for(int i=0; i<newGen.length; i++){
    float chance = random(0,1);
    if(chance<indMutationRate&&newGen[i]!=null){
      PVector[] mutated = new PVector[noOfGenes];
      for(int j=0; j<noOfGenes; j++)
        mutated[j]=PVector.random2D();
      DNA dna=new DNA(mutated);
      newGen[i].dna=dna;
    }
  }
  return newGen;
}

Ball pickRandomElement(Ball[] x){
  int n=(int)Math.floor(random(0, x.length));
  return x[n];
}

Ball crossover(Ball a, Ball b){
  PVector[] newGenes=new PVector[noOfGenes];
  if(a!=null&&b!=null)
    for(int i=0; i<a.dna.genes.length; i++){
      if(a.dna!=null&&a.dna!=null){
        float chance=random(0,1);
        if(chance>0.5)
          newGenes[i]=a.dna.genes[i];
        else
          newGenes[i]=b.dna.genes[i];
      }
    }
  DNA dna=new DNA(newGenes);
  return(new Ball(dna));
}

float calcFitness(Ball b){
  PVector p=b.pos;
  float fitness=0;
  float dist=(float)Math.pow((PVector.dist(p,targetPos)),1.2);
  if(dist!=0)
    fitness=(1/dist);
  if(dist<=targetRad+ballRad){
    fitness=0.01;
    b.dead=true;
  }
  fitness*=100000;
  return fitness;
}
void keyPressed(){
  if(key==' '){
    paused=!paused;
    editTarget=false;
    editGap=false;
  }
  if(key=='g'){
    editGap=!editGap;
    editTarget=false;
  }
  if(key=='t'){
    editTarget=!editTarget;
    editGap=false;
  }
}