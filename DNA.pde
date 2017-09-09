class DNA{
  PVector[] genes=new PVector[noOfGenes];
  public DNA(){
    for (int i=0; i<genes.length; i++){
      genes[i]=PVector.random2D();
    }
  }
  public DNA(PVector[] genes){
    this.genes=genes;
  }
}