  import gab.opencv.*;
  import processing.video.*;
  import java.awt.*;
  import controlP5.*;
  int user=0;
  Capture video;
  int nb_pictures=0,NB=0,nb_users;
  int choice=0;
  int menu;
  ArrayList<TauxRessemblance> Taux=new ArrayList<TauxRessemblance>();
  boolean capturer=false;
  int k=1,debut=-1;
  int start_LBPHOG=-1;
  PImage img_test1,img_test2,img1_LBP,img2_LBP;
  ArrayList<int[]> Histogrammes_image1=new ArrayList <int[]>();
  ArrayList<int[]> Histogrammes_image2=new ArrayList < int[]>();
  int tabLBP1[][],tabLBP2[][];
  ArrayList <PImage>images1=new ArrayList<PImage>(),images2=new ArrayList<PImage>();
  String nomProfil1="",nomProfil2="";
  int ia=0,b=-1;
  double erreur=0.0;
  static int [] hist;
  
  
  void setup() {
    background(36, 113, 163);
    size(640, 480);
    //Boutons de menu
      fill(127, 179, 213); strokeWeight(2); stroke(26, 82, 118);
      rect(155,150,330,50); 
      rect(155,300,330,50);
      fill(26, 82, 118  ); textSize(20);
      text("Add new Profil to Gallery",width/2-155,180);
      text("Compare with excisting Gallery",width/2-155,330);
      
  img1_LBP=createImage(256,256,RGB);
  img2_LBP=createImage(256,256,RGB);
//initialiser les deux images en blanc (pour l initialisation des bordures)
 for(int i=0; i<256; i++)
  {
    for(int j=0; j<256; j++)
    {   
      img1_LBP.pixels[j*img1_LBP.width+i]=color(255);
      img2_LBP.pixels[j*img2_LBP.width+i]=color(255);
    }
    
  }
  
  
  }
  void InitCamera(int nb_picture_toTake)
  {    NB=nb_picture_toTake;
     //background(255);
           video = new Capture(this, 640, 480);

    surface.setResizable(true);
     video.start();
     start_LBPHOG=1;
     
  }
  
  
  void draw()
  {     
  
    //Reccuperer le choix du menu principal
    if(start_LBPHOG==-1 )
    {  if(choice==0)
        Recuperer_Choix_Menu();  
     }
   
    
    if(start_LBPHOG==1)
    {
      if(nb_pictures<NB && capturer==true )
     {  
         PrendrePhoto();
     }
     
     else
     { 
       if(choice==10 && debut==1)
        { k=1;  capturer=true; nb_pictures=0; NB=2;              choice=2; 
           nb_pictures=0;    
             video.start();
           // InitCamera(2);
          
          
        }
           if(k==-1)
            { 
                background(255); 
                background(36, 113, 163);

                fill(127, 179, 213); strokeWeight(2); stroke(26, 82, 118);
                rect(400,200,400,100); //bouton hog
              
               fill(26, 82, 118  );
                text("Start HOG & LBP Merger",430,255); 
                surface.setSize(1200, 600);
              
            }    
  
   //  print("\ndebut="+debut+"\t choice="+choice);
     
     if(mousePressed && debut==0 && choice==0 )
    { //click on lbp & hog fusion
      if(mouseX>=400 && mouseX<=800 && mouseY>=200 && mouseY<=300)
      { k=1;   print("click fel bouto");
        background(255);  
       if(menu==1)
        genererHistoGallery(Integer.toString(nb_users));
        if(nb_users>0)
        Commencer_Comparaisons();
        LbpHog(img_test1,img_test2);      
        debut=-1;
       // print("\nTaux de ressemblance entre "+Taux.get(Taux.size()-1).nom1+"  et  "+Taux.get(Taux.size()-1).nom2+" ="+Taux.get(Taux.size()-1).Taux+"%");
       
      }
  
    }
  
     }
   
  
   if(keyPressed)
   { 
    if(key=='b') Dessiner_Portion_Histogramme();
   }
  
  
  }
  
  
  
  
  }
  
  void Recuperer_Choix_Menu()
  {
    
      if(mousePressed)
  {  //create new profil 
     if(mouseX>=155 && mouseX<=485 && mouseY>=155 && mouseY<=200)
      {   background(255);  //take 10 pictures 
          //Recuperer le nom du nouveau profil
                  read_Num_Profil();  menu=1;
                 File dir = new File("Gallery/Profil"+Integer.toString(nb_users));
                   dir.mkdir();
                 
                 write_Num_Profil();
                 InitCamera(10);  choice=10; capturer=true;
                 
  
      }
       if(mouseX>=155 && mouseX<=485 && mouseY>=300 && mouseY<=350)
      {   background(255); //take 10 pictures 
          print("existing galery"); menu=2;
          InitCamera(2); choice=2; capturer=true;
      }
    
  }
    
    
  }
  

  
  void Dessiner_Portion_Histogramme()
  {
     background(255);
    
     
    
  }
  
  void write_Num_Profil()
  {
      PrintWriter out = createWriter("nb_users.txt"); 
      out.print(nb_users); out.flush();
    out.flush(); out.close();
  }
  
  void read_Num_Profil()
  {  String[] lines = loadStrings("nb_users.txt");
      nb_users=Integer.parseInt(lines[0])+1;
     
  }
  
 void genererHistoGallery(String user){
  String path="Gallery/Profil"+Integer.toString(nb_users)+"/";
  PImage imgg1,imgg2;
  
  for(int i=0;i<5;i++){
   imgg1=loadImage(path+i+".png");
   imgg2=loadImage(path+(i+5)+".png");
   HOG(imgg1,imgg2);
   Reconnaissance_Faciale_LBP(imgg1,imgg2);Histogrammes_image1.clear();Histogrammes_image2.clear();
   background(255);
   fichiertxtHOG(tabClasses1,i,"Histogrammes/Profil"+Integer.toString(nb_users)+"/Hog/");
   fichiertxtHOG(tabClasses2,i+5,"Histogrammes/Profil"+Integer.toString(nb_users)+"/Hog/");
   fichiertxtLBP(tab1,i,"Histogrammes/Profil"+Integer.toString(nb_users)+"/Lbp/");
   fichiertxtLBP(tab2,i+5,"Histogrammes/Profil"+Integer.toString(nb_users)+"/Lbp/");
  }
  
  
}

void fichiertxtHOG(int [][]tab,int indice,String path){
  PrintWriter output1;
  output1 = createWriter(path+"Histogrammes"+indice+".txt"); 
  
   output1.flush(); // Writes the remaining data to the file
 
  
  for(int i=0;i<1024;i++){
    for(int j=0;j<9;j++){
    output1.print(tab[i][j]+"\t");
    }
    output1.println();
  }
  output1.close();;
} 

void fichiertxtLBP(int [][]tab1,int indice,String path){
  PrintWriter output1;
  output1 = createWriter(path+"Histogrammes"+indice+".txt"); 
  
   output1.flush(); // Writes the remaining data to the file
 
  
  for(int i=0;i<256;i++){
    for(int j=0;j<256;j++){
    output1.print(tab1[i][j]+"\t");
    }
    output1.println();
  }
  output1.close();;
}

void LbpHog(PImage img1,PImage img2){
  Reconnaissance_Faciale_LBP(img1,img2);
 
  HOG(img1,img2);
  TauxRessemblance R=new TauxRessemblance();
  R.nom1=nomProfil1; R.nom2=nomProfil2;
  float ressemblance=(ressemblanceHOG+ressemblanceLBP)/2;
  R.Taux=ressemblance;
  Taux.add(R);
  
  
  fill(150);
  textSize(30);
   
    background(255);
  
    text("HOG ET LBP \n Ressemblance="+(ressemblance)+"%\nHOG="+(ressemblanceHOG)+"%\nLBP="+(ressemblanceLBP)+"%",400,200);
  image(img1,0,0);
  image(img2,0,300);
}


public class TauxRessemblance
{
  String nom1,nom2;
  double Taux;
   
   public TauxRessemblance(){}
     
}

void Commencer_Comparaisons()
{
  String test1="Personne_test1",test2="Personne_test2";
  //img_test1=
 for(int i=1; i<nb_users+1; i++)
 {
    for(int j=0; j<10; j++)
   { TauxRessemblance T1=new TauxRessemblance();
     T1.nom1="Personne_test1"; T1.nom2="Profil"+Integer.toString(i)+"_"+Integer.toString(j);
    int[][] lbp_histogrammes=Recuperer_Donnees_Lbp("C:/Users/lenovo g50/Desktop/LBP_HOG_Gallery/Histogrammes/Profil"+Integer.toString(i)+"/Lbp/Histogrammes"+Integer.toString(j)+".txt");
    int[][] hog_histogrammes=Recuperer_Donnees_Hog("C:/Users/lenovo g50/Desktop/LBP_HOG_Gallery/Histogrammes/Profil"+Integer.toString(i)+"/Hog/Histogrammes"+Integer.toString(j)+".txt");
   
 }
   
   
   
 }
  
}


int[][] Recuperer_Donnees_Lbp(String path)
{ int [][] djamila=new int[256][256];
  String[] lines = loadStrings(path);

for (int i = 0 ; i < lines.length; i++) {
 String Line=lines[i];
 String values[]=Line.split("\\t");
 for(int j=0; j<values.length; j++)
 {
   djamila[i][j]=Integer.parseInt(values[j]);
 }
 }

  return djamila; 
}

int[][] Recuperer_Donnees_Hog(String path)
{
  int[][] djamel=new int[1024][9];
  String[] lines = loadStrings(path);
    Histogrammes_image1.clear();

for (int i = 0 ; i < lines.length; i++) {
 String Line=lines[i];
 String values[]=Line.split("\\t");
 for(int j=0; j<values.length; j++)
 {
   djamel[i][j]=Integer.parseInt(values[j]);
 }
 }

   return djamel;
}