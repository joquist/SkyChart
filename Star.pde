//stellar object data class

class Star {
  
  int x;
  int y;
  String name;
  String type; //Planet, Star, Nebula, Galaxy, Cluster, Constellation
  float distance;
  int diameter = 14;
  String dT;
  
  String tempName;
  
  //for drawing highlight circle
  float arc = 0;
  float arcRot = 0;
  
  //for drawing reticle
  int lineD = 125; //line distance from object
  int lineL = 30; //line length
  int lineTint = 0;
  
  //skyFade
  int fade = 0;
  
  Star(int tempX, int tempY, String tempN, String tempT, float tempD)
  {
    x = tempX;
    y = tempY;
    name = tempN;
    type = tempT;
    distance = tempD;
  }
  
  void display()
  {
    
    strokeWeight(3);
    
    //display circle at object position
    if (type == "Planet")
    {
      stroke(78,255,0);
      ellipse(x,y,diameter,diameter);
    }
    if (type == "Galaxy")
    {
      stroke(255,90,0);
      ellipse(x,y,diameter,diameter);
    }
    if (type == "Star")
    {
      stroke(255,240,0);
      ellipse(x,y,diameter,diameter);
    }
    if (type == "Cluster")
    {
      stroke(255,240,0);
      ellipse(x,y,diameter,diameter);
    }
    if (type == "Nebula")
    {
      stroke(0,252,255);
      ellipse(x,y,diameter,diameter);
    }
    
    
    
    if (type == "Constellation")
    {
      textFont(fConst);
      tempName = name.toUpperCase();
      fill(255);
      textAlign(CENTER);
      text(tempName,x,y+5);
      noFill();
    }
    
  }
  
  void displayInfo()
  {
    stroke(255);
    fill(255);
    
    textAlign(LEFT);
    textFont(f);
    
    //display stellar object data labels
    text("Object:", 50, 90);
    text("Type:", 50, 130);
    text("Distance:", 50, 170);
    
    //display object data
    text(name, 190, 90);
    text(type, 190, 130);
    
    //distance conversion
    
    dT = str(int(distance))+" LY";
    
    text(dT, 190, 170);
    
    noFill();
    
    //display icons
    if (type == "Planet")
    {
      shape(planet,50,200,175,175);
    }
    if (type == "Galaxy")
    {
      shape(galaxy,50,200,175,175);
    }
    if (type == "Star")
    {
      shape(star,50,200,175,175);
    }
    if (type == "Cluster")
    {
      shape(cluster,50,200,175,175);
    }
    if (type == "Nebula")
    {
      shape(nebula,50,200,175,175);
    }
    if (type == "Constellation")
    {
      shape(constellation,50,200,175,175);
    }
    
  }
  
  int overStar(int hX, int hY) 
  {
    //if using hand coords multiply coords*1.66
    if (int(sqrt(sq(x-(hX*1.66))+sq(y-(hY*1.66)))) < 25)
    {
      displayInfo();
      highlightObject();
  
      if (lineD > 40)
      {
        lineD = lineD - 5; 
      }
      
      if (lineTint < 255)
      {
        lineTint += 15;
        //println(lineTint);
      }
      return 1;
    }  
    else
    {
      lineD = 125;
      lineTint = 0;

      return 0;
    }
  }
  
  void highlightObject()
  {
    
    stroke(255,144,0);
    strokeWeight(2);
    noFill();
    
    
    //draw arcs around object
    for (int i = 0; i < 4; i++)
    {
      
      arc = arc+i*(1.08+.49)+arcRot;
      arc(x,y,50,50,arc,arc+1.08);
      arc = 0;
    }
    //rotate arcs for effect
    arcRot += .025;
    
    //draw target reticle
    
    
    stroke(255,144,0,lineTint);
    //top line
    line(x,y-lineD,x,y-lineD-lineL);
    //bottom line
    line(x,y+lineD,x,y+lineD+lineL);
    //left line
    line(x-lineD,y,x-lineD-lineL,y);
    //right line
    line(x+lineD,y,x+lineD+lineL,y);
  }  

}
