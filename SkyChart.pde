/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect 2 library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / Zhdk / http://iad.zhdk.ch/
 * date:  12/12/2012 (m/d/y)
 * ----------------------------------------------------------------------------
 */

 //Branch change test
 
import SimpleOpenNI.*;

PShape galaxy;
PShape planet;
PShape nebula;
PShape star;
PShape cluster;
PShape constellation;
PShape sky;

PFont f;
PFont fConst;

//hand coordinates
int ptX;
int ptY;

int skyFade = 0;
int counter = 0;

ArrayList<Star> stars;

SimpleOpenNI  context;
color[]       userClr = new color[]{ color(255,0,0),
                                     color(0,255,0),
                                     color(0,0,255),
                                     color(255,255,0),
                                     color(255,0,255),
                                     color(0,255,255)
                                   };
PVector com = new PVector();                                   
PVector com2d = new PVector();                                   

void setup()
{
  size(1066,800);
  
  stars = new ArrayList<Star>();
  
  
  stars.add(new Star(724,570,"Neptune","Planet",0.0004));
  stars.add(new Star(588,508,"Uranus","Planet",0.0002));
 
  
  stars.add(new Star(850,312,"Vega","Star",25.05));
  stars.add(new Star(297,346,"Betelgeuse","Star",640));
  stars.add(new Star(660,222,"Polaris","Star",434));
  stars.add(new Star(385,151,"Castor","Star",51));
  stars.add(new Star(409,386,"Aldebaran","Star",65));
  stars.add(new Star(506,530,"Mira","Star",300));
  stars.add(new Star(874,456,"Altair","Star",16.73));
  stars.add(new Star(489,271,"Capella","Star",42));
  stars.add(new Star(535,354,"Algol","Star",93));
  stars.add(new Star(765,353,"Betelgeuse","Star",643));
  stars.add(new Star(709,664,"Fomalhault","Star",25));
  stars.add(new Star(848,376,"Albireo","Star",400));
  
  
  stars.add(new Star(582,419,"Triangulum Galaxy","Galaxy",2380000));
  stars.add(new Star(776,95,"Pinwheel Galaxy","Galaxy",20000000));
  stars.add(new Star(625,393,"Andromeda Galaxy","Galaxy",2540000));
  
  
  stars.add(new Star(470,391,"Pleiades","Cluster",424));
  
  stars.add(new Star(651,294,"Cepheus","Constellation", 13.15));
  stars.add(new Star(658,417,"Andromeda","Constellation",10.30));
  stars.add(new Star(727,475,"Pegasus","Constellation", 20.38));
  stars.add(new Star(643,358,"Cassiopeia","Constellation", 19.42));
  stars.add(new Star(325,406,"Orion","Constellation", 17.51));
  stars.add(new Star(683,593,"Aquarius","Constellation", 11.27));
  stars.add(new Star(914,281,"Hercules","Constellation", 20.62));
  stars.add(new Star(683,192,"Ursa Minor","Constellation", 42.60));
  stars.add(new Star(527,441,"Aries","Constellation", 12.58));
  
  f = createFont("Arial", 32);
  fConst = createFont("Arial",18);
  
  
  
  galaxy = loadShape("galaxy_icon.svg");
  nebula = loadShape("nebula_icon.svg");
  star = loadShape("star_icon.svg");
  cluster = loadShape("cluster_icon.svg");
  planet = loadShape("planet_icon.svg");
  constellation = loadShape("constellation_icon.svg");
  
  sky = loadShape("constellations.svg");
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  context.setMirror(true);
  
  // enable depthMap generation 
  context.enableDepth();
   
  // enable skeleton generation for all joints
  context.enableUser();
  
  context.enableRGB();
 
  background(200,0,0);

  stroke(255);
  strokeWeight(2);
  smooth();  
}

void draw()
{
  background(90);
  // update the cam
  context.update();
  
  scale(1.67);
  // draw depthImageMap
  image(context.rgbImage(),0,0);
  //image(context.userImage(),0,0);
  
  // draw the skeleton if it's available
  int[] userList = context.getUsers();
  for(int i=0;i<userList.length;i++)
  {
    if(context.isTrackingSkeleton(userList[i]))
    {
      stroke(userClr[ (userList[i] - 1) % userClr.length ] );
      drawSkeleton(userList[i]);
    }      
  }  

  //Main draw function
  drawSky();  
  
}

void drawSky()
{
 scale(.6);
 
 noFill();
 
 //draw night sky background
 noStroke();
 fill(6,37,57,skyFade);
 ellipse((width/2)+132,height/2,764,764);
 noFill();
    
    
 //draw background image
 shape(sky,280,17,764,764);
 
 //draw horizon outline
 stroke(255);
 strokeWeight(2);
 ellipse((width/2)+132,height/2,766,766); 
 

 //label cardinal directions
 //text("N", (width/2)+132, 2);
  
  //draw all objects, uses Star class
  
  //use mouse coordinates
  //ptX = mouseX;
  //ptY = mouseY;
  //ellipse(ptX, ptY, 20,20);
  
  counter = 0;
  
  for (int i = stars.size()-1; i >= 0; i--)
  {
    Star star = stars.get(i);
    star.display();
    //star.displayInfo();
    counter += star.overStar(ptX,ptY);

  }
  
  if (counter == 1 && skyFade < 150)
  {
    skyFade +=2;
  }
  if (counter == 0 && skyFade > 0)
  {
    skyFade -=10;
  }
  
 
}

void overStarOrig()
{
  
  
  if (int(sqrt(sq(724-(ptX*1.66))+sq(570-(ptY*1.66)))) < 10)
  {
    ellipse(724,570,50,50);
  }
  
}



// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos);
 // println(jointPos);
  
  PVector jointPos_Proj = new PVector(); 
  context.convertRealWorldToProjective(jointPos,jointPos_Proj);
 
  stroke(255);
  noFill();
  ellipse(jointPos_Proj.x, jointPos_Proj.y, 20,20);
  
  //use hand coordinates
  ptX = int(jointPos_Proj.x);
  ptY = int(jointPos_Proj.y);
  
  
  
  //context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  stroke(255);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);
  
  /*
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);
*/  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

