int tab1[][];int tab2[][];float ressemblanceLBP;
ArrayList<Double> SimHist1(){
  ArrayList<Double> Sim=new ArrayList<Double>();
    for(int i=0;i<16;i++){
      for(int j=0;j<16;j++){
         ArrayList<Double> ss=new ArrayList<Double>();
         ss=tabDist1(new Indice(i,j));
         Sim.add(Min(ss));
      }
    }
  return Sim;
}

ArrayList<Double> tabDist1(Indice ind){
  //double tabDis[]=new double[40];
  int k,k1,l,l1;
  ArrayList<Double> ListDis=new ArrayList();
  if(ind.i<3){ k=ind.i;k1=ind.i+6;}else if(ind.i>12){k=ind.i-6;k1=ind.i;} else{ k=ind.i-3;k1=ind.i+3;} ;
  if(ind.j<3){ l=ind.j;l1=ind.j+6;}else if(ind.j>12){l=ind.j-6;l1=ind.j;} else{ l=ind.j-3;l1=ind.j+3;} ;
  
  
  
  for(int i=k;i<k1;i++){
      for(int j=l;j<l1;j++){
        double d=distHist(tab1[(ind.i)*16+(ind.j)],tab2[i*16+j]);
        //region(i+1,j+1,img2);
        ListDis.add(d);
      }
    }
  return ListDis;  
}
double distHist(int hist1[],int hist2[]){
   
  double distance=0.0;
  for (int i=0; i<hist1.length; i++)
  { 
    distance=distance+(double)pow((hist1[i]-hist2[i]),2);
  }
  distance=Math.sqrt(distance);
  return distance;
}


void Reconnaissance_Faciale_LBP(PImage img1,PImage img2)
{     
  background(255);

  CalculLBP(img1, 1);
  CalculLBP(img2, 2);
  conversionTab();
  
   ArrayList<Double> ss1=new ArrayList<Double>();
   ss1=SimHist1();
   int nb=0;
   for(int i=0;i<ss1.size();i++){
     if(ss1.get(i)<=(double)45) 
     {nb++;  }
   }
   //print(nb);
    ressemblanceLBP=(nb*100)/ss1.size();
    fill(150);
  textSize(30);
  textSize(30);text("LBP \nRessemblance="+(ressemblanceLBP)+"%",400,200);
  image(img2, 0, 300);
  image(img1_LBP, 1200-255, 0);
  image(img2_LBP, 1200-255, 255);
}

int diff() {
  int d=0;
  for (int i=0; i<16; i++) {
    for (int j=0; j<256; j++) {
      if (Histogrammes_image1.get(i)[j]!=Histogrammes_image2.get(i)[j])
        d++;
    }
  }
  return d;
}



//calculer la valeur d'un pixel
int CalculerValeur(int px, int py, PImage img)
{ 


  int val=0;  
  int pat=1; 
  int loc = py*img.width+px;
  int r =(int) brightness(img.pixels[loc]);


  for (int i=px-1; i<px+2; i++)
  { 
    for (int j=py-1; j<py+2; j++)
    {      
      int locProv = j*img.width+i;
      int rProv =(int) brightness(img.pixels[locProv]);


      if ((rProv>r) && !(px==i && py==j)) 
      { 
        val+=pat;
      }
      if (!(px==i && py==j))
        pat*=2;
    }
  }





  return val;
}

void  CalculLBP(PImage imge, int num)
{     
  //Convertir_Niveau_DeGris(imge, num);

  for (int i=1; i<255; i++)
  {
    for (int j=1; j<255; j++)
    {
      if (num==1)
        img1_LBP.pixels[j*img1_LBP.width+i]=color(CalculerValeur(i, j, img_test1));
      if (num==2)
        img2_LBP.pixels[j*img2_LBP.width+i]=color(CalculerValeur(i, j, img_test2));
    }
  }
  if (num==1)
    img1_LBP.save("LBP1.png");
  else 
  img2_LBP.save("LBP2.png");


  //DIVISER l IMAGE en BLOCS 16*16 
  int i=0, j=0; 
  while (i<256)
  { 
    int cpt1=0, cpt2=0;
    PImage Bloc_Image=createImage(16, 16, RGB);    
    //Réccuperer bloc 16*16
    int f=0, k=0;
    for ( k=i; k<i+16; k++)
    { 
      cpt2=0;
      for ( f=j; f<j+16; f++)
      {
        Bloc_Image.pixels[cpt2*Bloc_Image.width+cpt1]=color(brightness(imge.pixels[f*imge.width+k]), brightness(imge.pixels[f*imge.width+k]), brightness(imge.pixels[f*imge.width+k]));
        cpt2++;
      }
      cpt1++;
    }


    //video.stop();       
    if (num==1)
    { 
      images1.add(Bloc_Image);   
      image(images1.get(images1.size()-1), i, j);
    } else       
    { 
      images2.add(Bloc_Image);
    }
    Calculer_Histogramme(Bloc_Image, num);
    j=f; 
    i=k;

    if (j>255 ) 
    {
      j=0;
    } else
    {
      i-=16;
    }
  }
}

void calcul_Distance_Euclidienne(int[] hist1, int hist2[], int bloc)
{
  double distance=0.0;
  for (int i=0; i<16; i++)
  { 

    distance=distance+(double)Math.pow(hist1[i]-hist2[i],2);
  }
  distance=Math.sqrt(distance);
  erreur+=distance;
  // print("\nla distance du bloc "+bloc+" ="+distance+" ");
}

void Calculer_Histogramme(PImage image,int num)

{   
  int [] hist=new int[256]; 
  for(int i =0; i<16; i++)
  {
    for(int j=0; j<16; j++)
    {
      int val=(int) brightness(image.pixels[j*image.width+i]);
      hist[val]++;
    }
    
  }
  if(num==1)  Histogrammes_image1.add(hist); 
  if(num==2)  Histogrammes_image2.add(hist);
  
  
  
}


void conversionTab(){
  tab1=new int [256][256];tab2=new int [256][256];
  
  for(int i=0;i<Histogrammes_image2.size();i++){
      tab1[i]=Histogrammes_image1.get(i);
      tab2[i]=Histogrammes_image2.get(i);
  }
}