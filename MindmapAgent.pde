import java.awt.*;
import javax.swing.*;
//////////////////////////tuusin//////////////
import processing.net.*; 

Client myClient; 
int dataIn; 


String str="1";


///////////////////////////////////////////////

//int s,ss;


///////////////////////AGENT/////////////////

float x = 0;
float y = 0;

int dir_x = 1;
int dir_y = 1;
int speed = 1;
int fcount=0;
int f=0;

float ichix =-1;
float ichiy =-1;

float sa_x=-1;
float sa_y=-1;

float x_speed = -1;
float y_speed = -1;

int nowf = -1;

int nowb = -1;

boolean Rflag=false, Lflag=false;

//int morning=0,afternoon=0,evening=0;
//int hour = hour();

//int zahyo_x = 0;
//int zahyo_y = 0;

PImage imgA, imgB, imgr, imgl;//エージェント、吹き出し右、吹き出し左





/////////////////////////////////////////////////





boolean rand = true;


final int center=0, boi=1, node=2;
int phase = center;
int befS=0, befN=0;
int bef=0;

String [][] mes = { 
  {
    "セントラルイメージを書いてみよう", "考えたいものの名前でいいよ"
  }
  , {
    "いくつかBOIを伸ばしてみて", "あと１つか２つ作れない？"
  }
  , {
    "そこからどんどん広げよう", "強みや弱みは？", "横のつながりは？", "面白く感じた部分はどこ？", "今この中で一番好きなのは？", "ここからもう伸びない？"
  }
};

PImage webImg =null;
int imgX, imgY;
boolean newcreate = true;//新規作成モード　デフォルトでは新規作成
boolean addcreate = false;//追加作成モード　  
boolean delete_flag = false;
boolean select = false;  
boolean ndndcreate = false;//考えてみようノード機能


float wheel = 0.0;//マウスの真ん中のグリグリ
int traX, traY;//マップ全体移動用変数

ArrayList<Node> n;

JPanel panel = new JPanel();
JTextField text1;

void setup () {
  frameRate(30);

  size(512, 512);
  n =  new ArrayList<Node>();

  BoxLayout layout = new BoxLayout(panel, BoxLayout.Y_AXIS);
  panel.setLayout(layout);

  panel.add(new JLabel("入力"));
  text1 = new JTextField();
  panel.add(text1);


  myClient = new Client(this, "127.0.0.1", 8083); 
  //myClient.write(input());
}

void draw() {
  background(255);
  if (webImg != null) {
    image(webImg, width/2-webImg.width/2, height/2-webImg.height/2);
  }
  //println("mouseX:"+int(mouseX/(1+wheel))+"mouseY:"+int(mouseY/(1+wheel)));
  if (newcreate) {
    fill(0);
    text("新規作成モード", 10, 20);
  } else if (addcreate) {
    fill(0);
    text("追加モード", 10, 20);
  } else if (delete_flag) {
    fill(0);
    text("削除モード", 10, 20);
    for (int i = 0; i < n.size (); ++i) {
      n.get(i).delete(i);
    }
  } else if (ndndcreate) {
    fill(0);
    text("考えてみようノード", 10, 20);
  } 


  pushMatrix();

  scale(1+wheel/100);

  for (int i = 0; i < n.size (); ++i) {
    n.get(i).linedisp();
  }
  for (int i = 0; i < n.size (); ++i) {
    n.get(i).textdisp();
  }


  //text(agent(),20,10);  //テキスト表示
  popMatrix();

  /*
    if(webImg != null){
   webImg.resize(webImg.width/10,webImg.height/10);
   image(webImg,imgX,imgY);
   println("img!");  
   
   }*/


  imgA = loadImage("usa.png");
  imgB = loadImage("usaB.png");
  imgr = loadImage("Fukimigiyo.png");
  imgl = loadImage("Fukihidariyo.png");

  //translate(width/2,height/2);
  /*  x += dir_x * speed;
   y += dir_y * speed;
   
   if ( ( x < 0 ) || ( x > width - imgA.width ) ) {
   dir_x = - dir_x;
   }
   
   if ( ( y < 0 ) || ( y > height - imgA.height ) ) {
   dir_y = - dir_y;
   }*/
  // println(mouseX,mouseY);

  //  text("これってどういう意味？",x,y);

  if (f-nowb<3) {
    x += x_speed;
    y += y_speed;
  } else if (f-nowb==3) {
    if (nowf-fcount>0) {
      x += x_speed;
      y += y_speed;
    }
  }


  if (x<248) {
    image(imgA, x, y);
    image(imgl, x-180, y-100);
    text(agent(), x-140, y-45);  //テキスト表示
  } else if (x>248) {
    image(imgB, x, y);
    image(imgr, x-75, y-100);
    text(agent(), x-10, y-45);  //テキスト表示
  }

  fcount++;
  if (fcount==30) {
    fcount=0;
    f++;
  }

  if ( myClient.available() > 0) {////通信
    println(myClient.readString() );
  }
}

void mousePressed() {

  sa_x = mouseX-x;
  sa_y = mouseY-y;

  x_speed = sa_x/3;
  y_speed = sa_y/3;

  x_speed = x_speed/30;
  y_speed = y_speed/30;

  println(x_speed);

  nowf = fcount;
  nowb = f;

  if (mouseButton == RIGHT) {
    thread("input");
    //myClient.write(str);


    //println("受信開始");
    //println(myClient.read());
    //println("受信完了");
  }
  if (addcreate) {
    for (int i = 0; i < n.size (); ++i) {
      n.get(i).select(i);
    }
  }
}

void keyPressed() {
  if (key == 'i') {
    String url ="";// = input();
    println(url);
    String str[] = loadStrings("https://www.googleapis.com/customsearch/v1?key=AIzaSyCDIu0aU964IOLmx8MACeLpjXwTgf2ZwcQ&cx=000893818175528849387:9ml_7eulfck&searchType=image&q="+url);
    imgX = mouseX;
    imgY = mouseY;


    for (int i = 0; i<str.length; i++) {
      if (str[i].indexOf("\"link\"") != -1) {
        println(str[i]);
        println();
        String tmp = str[i].substring(str[i].indexOf("h"));
        println("OK!　　　　　　"+tmp.substring(0, tmp.length()-2));
        webImg = loadImage(tmp.substring(0, tmp.length()-2));
        break;
      }
    }
  }
  //新規作成モード
  if (key == 'n') {
    newcreate = true;
    addcreate = false;
    delete_flag = false;
    ndndcreate = false;
  }
  //追加作成モード
  if (key == 'a') {
    addcreate = true;
    newcreate = false;
    delete_flag = false;
    ndndcreate = false;
  }
  if (key == 'r') {
    wheel = 0;
  }
  if (key == 'd') {
    delete_flag = true;
    addcreate = false;
    newcreate = false;
    ndndcreate = false;
  }
  if (key == 's') {
    select = true;
    addcreate = false;
    newcreate = false;
    delete_flag = false;
    ndndcreate = false;
  }
  if (key == 'w') {
    select = false;
    addcreate = false;
    newcreate = false;
    delete_flag = false;
    ndndcreate = true;
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  //translate(mouseX, mouseY);
  if (e>0) {
    wheel++;
  } else {
    wheel--;
  }
}


void input() {
  JOptionPane.showConfirmDialog(
  null, // オーナーウィンドウ
  panel, // メッセージ
  "日本語入力", // ウィンドウタイトル
  JOptionPane.OK_CANCEL_OPTION, // オプション（ボタンの種類）
  JOptionPane.QUESTION_MESSAGE);  // メッセージタイプ（アイコンの種類）
  str = text1.getText(); //変数にテキストの内容を入れる

  if (newcreate) {
    n.add(new Node(str, mouseX, mouseY ));
  } else if (addcreate) {
    n.add(new Node(str, mouseX, mouseY, n.size()-1));
  } else if (ndndcreate) {
    n.add(new Node(str, mouseX, mouseY, n.size()-1, 1));
    println("ndndcreate");
  }
}

String agent() {
  String message ="";
  switch(phase) {
  case center : 
    if (n.size()!=0) {
      message ="";
      befS = frameCount;
      phase = boi;
    } else if (frameCount>900)
      message = mes[center][1]; //考えたいものの名前でいいよ
    else
      message = mes[center][0]; //セントラルイメージを書いてみて
    break;
  case boi  : 
    if ( n.size()<5 ) {
      if ( (frameCount-befS) < 150)
        message = mes[boi][0]; //いくつかBOIを伸ばしてみて
      else
        message = mes[boi][1]; //あと１つか２つ作れない？
    } else {
      befS = frameCount;
      befN = n.size();
      bef = 0;
      phase = node;
    }
    break;
  case node  :  
    if (n.size() > befN) {
      befS = frameCount;
      int r = int(random(1, 4));
      if (r==4)
        r=3;
      bef = r;
    } else if ( (frameCount-befS) > 150 ) {
      befS = frameCount;
      int r=int(random(4, 6));
      if (r==6)
        r=5;
      bef = r;
    }

    message = mes[node][bef]; //今この中で一番好きなのは？、ここからもう伸びない？ 
    befN = n.size();
    break;
  default : 
    message = "エラー";
    break;
  }
  return message;
}

