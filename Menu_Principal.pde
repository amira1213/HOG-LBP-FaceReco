
  
  
  void PrendrePhoto() {
       if (video.available() == true) {
          loadPixels();
      video.read();
      image(video ,0,0);
      if(choice==10)
      stroke(255);
      if(choice==2)
      stroke(36, 113, 163);
      noFill();
      rect(250, 100, 220,320, 7);
           textSize(30);
           if(nb_pictures<NB) 
         { 
           if(choice==10)
           { fill(255);
           text("put your face on the rect to take\n profil Picture "+nb_pictures,110,35); }
           if(choice==1 || choice==2)
            { fill(36, 113, 163);
            text("put your face on the rect to take \ntest Picture "+nb_pictures,110,35); }
          }
          else 
          { 
           
            debut=1;
            //video.stop(); 
            nb_pictures=0;
          }
      if (mousePressed == true) {  //setting up a trigger for the camera to take a photo
     
        
     if(nb_pictures<NB)
     {
          video.read();
          image(video ,0,0);
         filter( POSTERIZE, 254 ); 
        if(choice==10)
          {   
             PImage img =video.get(250, 100, 220,320);
             img.resize(256,256); 
             
             img.save("Gallery/Profil"+Integer.toString(nb_users)+"/"+Integer.toString(nb_pictures)+".png");
          }
          else
          { 
            if(nb_pictures==0)
            { nomProfil1="Personne_test1";
              img_test1=video.get(250, 100, 220,320);
             img_test1.resize(256,256); 
             img_test1.save("Personne_test1.png");
             }
             if(nb_pictures==1)
             {  nomProfil2="Personne_test2";
                img_test2=video.get(250, 100, 220,320);
             img_test2.resize(256,256); 
             img_test2.save("Personne_test2.png");
             choice=0;
             k=-1; debut=0;
             video.stop();
             }
            
          }
       
     
                      nb_pictures++;
     }
     if(nb_pictures==10)
     debut=1;
     }
    }
  
     
  
   }
  
  
  
  

  
  
  
  
  //focus sur le visage avec la souris