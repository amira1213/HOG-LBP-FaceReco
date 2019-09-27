



float ressemblanceHOG;
int [][]tabClasses1;
int [][]tabClasses2;

ArrayList<Double> SimHist(){
  ArrayList<Double> Sim=new ArrayList<Double>();
    for(int i=0;i<32;i++){
      for(int j=0;j<32;j++){
         ArrayList<Double> ss=new ArrayList<Double>();
         ss=tabDist(new Indice(i,j));
         Sim.add(Min(ss));
      }
    }
  return Sim;
}
double Min(ArrayList<Double> list){
  double min=list.get(0);
  
  for(int i=0;i<list.size();i++){
    if(list.get(i)<min)
      min=list.get(i); 
  }
  return min;
}
ArrayList<Double> tabDist(Indice ind){
  //double tabDis[]=new double[40];
  int k,k1,l,l1;
  ArrayList<Double> ListDis=new ArrayList();
  if(ind.i<3){ k=ind.i;k1=ind.i+6;}else if(ind.i>29){k=ind.i-6;k1=ind.i;} else{ k=ind.i-3;k1=ind.i+3;} ;
  if(ind.j<3){ l=ind.j;l1=ind.j+6;}else if(ind.j>29){l=ind.j-6;l1=ind.j;} else{ l=ind.j-3;l1=ind.j+3;} ;
  //print("i de "+k+" ==> "+k1+"\n");print("j de "+l+" ==> "+l1+"\n");
  for(int i=k;i<k1;i++){
      for(int j=l;j<l1;j++){
        double d=distHist(tabClasses1[(ind.i)*32+(ind.j)],tabClasses2[i*32+j]);
       // region(i+1,j+1,img2);
        ListDis.add(d);
      }
    }
  return ListDis;  
}


void region(int x, int y,PImage img){
  for(int i=8*x;i<8+(8*x);i++){
    for(int j=8*y;j<8+(8*y);j++){
      img.pixels[i*img.width+j]=color(255,0,0);
    }
  }
  
}
void HOG(PImage img1,PImage img2){
  tabClasses1=new int [1024][9];
  tabClasses2=new int [1024][9];
  PrintWriter output1,output2;
  image(img1,0,0);
  image(img2,0,img2.height);
 /* for(int i=0;i<classes.length;i++){
    classes[i]=0;
    
  }*/
  output1 = createWriter("Histogrammes1.txt"); 
  output2 = createWriter("Histogrammes2.txt"); 
  frameRate(100);
  
  
  //img.resize(256,256);
  int []clas=new int[9];
   for(int i=0;i<32;i++){
    for(int j=0;j<32;j++){
      clas=classes(i,j,img1);
      tabClasses1[(i*32)+j]=clas;
      
      clas=classes(i,j,img2);
      tabClasses2[(i*32)+j]=clas;
    }
  }
  


  
  output1.flush(); // Writes the remaining data to the file
  output2.flush(); // Writes the remaining data to the file
  for(int i=0;i<1024;i++){
    for(int j=0;j<9;j++){
    output1.print(tabClasses1[i][j]+"\t");
    output2.print(tabClasses2[i][j]+"\t");
    }
    output1.println();output2.println();
  }
  output1.close();output2.close();

   ArrayList<Double> ss1=new ArrayList<Double>();
   ss1=SimHist();
   //print(ss1.size());
   int nb=0;double change=ss1.get(0);
   for(int i=0;i<ss1.size();i++){
     print("\nerreur="+ss1.get(i));
     if(ss1.get(i)<=(double)20) nb++;
     
     //print(ss1.get(i)+"\n");
   }
   //print(nb);
   ressemblanceHOG=(nb*100)/ss1.size();
   double err=calcul_Distance_Euclidienne_Hog(tabClasses1,tabClasses2);
  fill(150);
  textSize(30);text("HOG \n Ressemblance="+(ressemblanceHOG)+"%",400,200);

image(img1,0,0);
    image(img2,0,300);
}

int[] classes(int xBloc,int yBloc,PImage img){  
  float drv,dgr;
  int []classes=new int [9];
  for(int i=8*xBloc;i<8+(8*xBloc);i++){
    for(int j=8*yBloc;j<8+(8*yBloc);j++){
      drv=dirivePixel(i,j,img).deriv;
      dgr=degree(drv);
      
      if (dgr>=0 && dgr<=20){classes[0]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=20 && dgr<=40){classes[1]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=40 && dgr<=60){classes[2]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=60 && dgr<=80){classes[3]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=80 && dgr<=100){classes[4]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=100 && dgr<=120){classes[5]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=120 && dgr<=140){classes[6]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=140 && dgr<=160){classes[7]+=dirivePixel(i,j,img).magnitude;}
      if (dgr>=160 && dgr<=180){classes[8]+=dirivePixel(i,j,img).magnitude;;}
    }
  }
  
  return classes;
  
}
Pixel dirivePixel(int py,int px,PImage img)
{ float dx,dy;
Pixel p=new Pixel();
  float d=0;
    if(px==0){
      dx=(int) brightness(img.pixels[(py*img.width)+(px+1)])-(int) brightness(img.pixels[(py*img.width)+(px)]);
    }
    else if(px==img.height-1){
       dx=(int) brightness(img.pixels[(py*img.width)+(px)])-(int) brightness(img.pixels[(py*img.width)+(px-1)]);
    }
    else{
      dx=(int) brightness(img.pixels[(py*img.width)+(px+1)])-(int) brightness(img.pixels[(py*img.width)+(px-1)]);
    }
    if(py==0){
      dy=(int) brightness(img.pixels[((py+1)*img.width)+(px)])-(int) brightness(img.pixels[((py)*img.width)+(px)]);
    }
    else if(py==img.width-1){
      dy=(int) brightness(img.pixels[((py)*img.width)+(px)])-(int) brightness(img.pixels[((py-1)*img.width)+(px)]);
    }
    else{
      dy=(int) brightness(img.pixels[((py+1)*img.width)+(px)])-(int) brightness(img.pixels[((py-1)*img.width)+(px)]);
     }
     //imgg.pixels[(py*img.width)+px]=color(dy,dy,dy);
     if(dy==0) dy=0.00001;
     else
      d=dy/dx;
    //print(dx+"\t"+dy+"\n");
    p.deriv=d;
        p.magnitude=sqrt((dx*dx)+(dy*dy));

    return p;
    
}
float degree(float dirive){
  float drc=degrees(atan(dirive));

     if(drc<0) drc+=180;
//print(drc+"\n");
  return drc;
}
int b1=1;
/*void draw(){
    img.loadPixels();
     
  
}*/
double calcul_Distance_Euclidienne_Hog(int[][] hist1, int hist2[][])
{ double erreur_Hog=0.0;
 double distance=0.0;
 for(int i=0;i<1024;i++)
  for(int j=0; j<9; j++)
  { 
    distance=distance+(double)Math.abs(hist1[i][j]-hist2[i][j]);
  }
distance=distance/9;
erreur_Hog+=distance;
 // print("\nla distance du bloc "+bloc+" ="+distance+" ");
 return erreur_Hog;
}
class Indice{
  int i,j;
  Indice(int i,int j){
    this.i=i;
    this.j=j;
  }
  Indice(){}
}
public class Pixel
{ public Pixel(){}
  float deriv; double magnitude;
  
}