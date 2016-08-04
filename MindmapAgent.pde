 //<>//
import java.awt.*; //<>//
import javax.swing.*;
import processing.net.*;

//mode変数
static final int NEW = 1;
static final int ADD = 2;
static final int SELECT = 3;
static final int DELETE = 4;
static final int EXPAND = 5;
static final int LOADIMG = 6;

//全体管理用変数
int mode = NEW;
int randomNode = -1;
int index_num = -1;
String node_word = "";
int agent_num = 0; //エージェントにランダムにセリフを喋らせる

//マルフォイタイマー分追加
PFont font; 
boolean flag; 
PImage img; 
int ms = 0; 
int s = 0; 
int m = 0; 
int startTime = -1; 
int currentTime = -1; 


//通信
Client myClient; 

//画像用変数
PImage imgA, imgB, imgr, imgl;//エージェント、吹き出し右、吹き出し左
PImage webImg =null;

//セントラルイメージの位置変数
int imgX, imgY;

//日本語入力パネル
JPanel panel = new JPanel();
JTextField text1;

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

///時間経過による評価セリフ参照用にTIMER=3を追加--------------
final int CENTER=0;
final int BOI=1;
final int AINOTE=3;
final int AIDUTI=2;
final int HUSOKU=4;
final int SUISEN=5;
final int TIMER=6;
int phase = CENTER;
int befS=0, befN=0, HUSOKU_N=0, HUSOKU_S=0;
;
int bef=0;

//String a="abc";
//String str = "へー、"+a+"!";
String [][] mes = { 
  {
    "何か考えたいことはある？", "困ってることとかないかな？", "簡単に考えてみよう"//セントラルイメージ引き出しセリフ候補
  }//セントラルイメージの作成:CENTER
  , {
    "そこからどんどん広げよう", "強みや弱みは？", "横のつながりは？", "面白く感じた部分はどこ？", "今この中で一番好きなのは？", "ここからもう伸びない？"
  }//列挙の促し:BOI
  , {
    "うんうん", "あー、それだよね", "わかるわかる"  
  }//合の手セリフ:AINOTE

  , {
    "へー、○○！", "ほうほう○○ね！", "これは良いアイデア出てるんじゃない？"  
  }//相槌:AIDUTI
  , {
    "うーん、他にもないかなぁ", "忘れてる事、ないかな？", "これに似てるのはない？"//気付きの促しセリフ候補
  }//列挙したノードの不足確認:HUSOKU

  , {
    "他には\"○○\"とかもあるみたい！", ""//サジェスト形態素解析 セリフ候補
  }//新規ノード候補推薦:SUISEN

  , {
    "もう○○分頑張ってるね！一休みしよう！", "まだ○○分しか経ってないよ！ゆっくり考えてみて"//時間経過による評価セリフ候補 
  }//時間経過による評価セリフ:TIMER


/*,{
 "ならここから考えてみようよ！","まだまだいけるよ！例えば・・・","だったらここからは？" //連結フェイズセリフ候補
 }*/
/*
  , {
 "さぁどんどん広げよう！", "これは良い発想だね！", "もっと知りたいな", "難しく考えすぎないで・・・", "僕も考えてみる！う～ん・・・", "ここからもう伸びない？", "考えてみよう(W)"//列挙フェイズセリフ候補
 }
 */
/*{
 "いいね！一緒に考えよう！", "また？よく考えるねぇ・・・"//履歴による評価セリフ候補
 }*/
};





float wheel = 0.0;//マウスの真ん中のグリグリ
int traX, traY;//マップ全体移動用変数

ArrayList<Node> n;



void setup () {
  ////////////タイマー用////////////////
  flag=false;

  startTime = millis();
  //////////////////////////
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

  //画像読み込み
  imgA = loadImage("usa.png");
  imgB = loadImage("usaB.png");
  imgr = loadImage("Fukimigiyo.png");
  imgl = loadImage("Fukihidariyo.png");
}

void draw() {
  background(255);

  ////////タイマー用///////////////////////////////////////////
  currentTime = millis(); 

  int ms = currentTime - startTime; 


  if (ms>=1000) { 

    s += 1; 

    ms = millis()%1000; 

    startTime = millis();
  } 
  //println(m, ":", s, ":");


  if (s>59) { 

    m += 1; 

    s=0;
  } 


  //////////////////////////////////////////////////////////////////    



  if (webImg != null) {
    image(webImg, width/2-webImg.width/2, height/2-webImg.height/2);
  }
  switch(mode) {
  case NEW:
    fill(0);
    text("新規作成モード", 10, 20);
    break;
  case ADD:
    fill(0);
    text("追加モード", 10, 20);
    break;
  case DELETE:
    fill(0);
    text("削除モード", 10, 20);
    for (int i = 0; i < n.size (); ++i) {
      n.get(i).delete(i);
    }
    break;
  case EXPAND:
    fill(0);
    text("考えてみようノード", 10, 20);
    break;
  default:
    break;
  }

  pushMatrix();

  scale(1+wheel/100);

  for (int i = 0; i < n.size (); ++i) {
    n.get(i).linedisp();
  }
  for (int i = 0; i < n.size (); ++i) {
    n.get(i).textdisp(i);
  }

  popMatrix();

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


  nowf = fcount;
  nowb = f;

  if (mouseButton == RIGHT) {
    /* String str = input();
     
     if(str ==""){
     }*/
    if (mode == EXPAND) {
      //randomNode
      for (int j = 0; j < n.size (); ++j) {
        if (n.get(j).red_flag) {
          //選択されてたら、そのインデックスをnumに入れる
          index_num = j;
          break;
        }
      }
      if (index_num < 0) {
        mode = ADD;
      }
      randomNode =int( random(0, n.size()));
      while (index_num == randomNode) {
        randomNode =int( random(0, n.size()));
      }
    }
    thread("input");
    // myClient.write(str);


    println("受信開始");
    println(myClient.read());
    println("受信完了");
  }
  if (mode == ADD) {
    for (int i = 0; i < n.size (); ++i) {
      n.get(i).select(i);
    }
  }
}

void keyPressed() {
  if (key == 'i') {
    mode = LOADIMG;
    input();
  }
  //新規作成モード
  if (key == 'n') {
    mode = NEW;
  }
  //追加作成モード
  if (key == 'a') {
    mode = ADD;
  }
  if (key == 'r') {
    wheel = 0;
  }
  if (key == 'd') {
    mode = DELETE;
  }
  if (key == 's') {
    mode = SELECT;
  }
  if (key == 'w') {
    mode = EXPAND;
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
  int ok_cancel = JOptionPane.showConfirmDialog(
    null, // オーナーウィンドウ
    panel, // メッセージ
    "日本語入力", // ウィンドウタイトル
    JOptionPane.OK_CANCEL_OPTION, // オプション（ボタンの種類）
    JOptionPane.QUESTION_MESSAGE);  // メッセージタイプ（アイコンの種類）
  if (ok_cancel == 0) {
    node_word = text1.getText(); //変数にテキストの内容を入れる
    if (node_word.length() > 0) {
      //myClient.write(node_word);
      if (mode == NEW ) {
        n.add(new Node(node_word, mouseX, mouseY ));
      } else if (mode == ADD) {
        n.add(new Node(node_word, mouseX, mouseY, n.size()-1));
      } else if (mode == EXPAND) {
        n.add(new Node(node_word, mouseX, mouseY, index_num, randomNode));
        index_num = -1;
        randomNode = -1;
      } else if (mode == LOADIMG) {
        loadWeb_image(node_word);
      }

      if (phase==BOI) {
        phase = AIDUTI;
        befS=frameCount;
        befN=n.size();
        agent_num = (int)random(1, 3);
      } else if ( (phase == AIDUTI) || phase == AINOTE) {
        agent_num = (int)random(1, 3);
      } else if (phase == HUSOKU) {
        HUSOKU_S = frameCount;
      } else if (phase == HUSOKU) {
        HUSOKU_S = frameCount;
      }
    }
    node_word = "";
    text1.setText("");
  }
}
////////////////////////////エージェントのセリフ部分//////////////////////////////
String agent() {
  String message ="";
  switch(phase) {
  case CENTER : 
    if (n.size()!=0) {//セントラルイメージが作成されたら
      message ="";
      befS = frameCount;
      phase = BOI;//次のフェイズに
      agent_num = (int)random(0, 6);
    } else if (frameCount>300)//frameRate(30)書かずに10秒経過 
      message = mes[CENTER][2]; //簡単に考えてみよう
    else
      message = mes[CENTER][0]; //セントラルイメージを書いてみて
    break;
  case BOI  : 
    //if ( n.size()<5 ) {
    if ( (frameCount-befS) < 150) 
      message = mes[BOI][agent_num]; //いくつかBOIを伸ばしてみて
    else {
      agent_num = (int)random(0, 6);
      befS = frameCount;
      //message = mes[BOI][1]; //あと１つか２つ作れない？
    }
    //}
    break;
  case AIDUTI  :
    if ( (n.size() - befN) == 4) {//必要個数を変えるにはここを変える
      phase = AINOTE;
      befS = frameCount;
      befN = n.size();
    } else {
      message = mes[AIDUTI][agent_num];
      //agent_num = (int)random(1, 3);
    }
    break;
  case AINOTE:
    if ( (n.size() - befN) == 2 ) {//必要個数を変えるにはここを変える
      phase = HUSOKU;
      befS = frameCount;
      befN = n.size();
      HUSOKU_N = befN;
      HUSOKU_S = befS;
    } else {
      message = mes[AINOTE][agent_num];
    }
    break;
  case HUSOKU :
    if ( (frameCount - befS) > 150) {
      befS = frameCount;
      agent_num = (int)random(1, 3);
    } else {
      message = mes[HUSOKU][agent_num];
    }
    befN = n.size();
    if ( ( (befN - HUSOKU_N -1) == 3) || ( (frameCount - HUSOKU_S) > 450) ) {
      phase = BOI;  //後でSUISENに変える
      befN = n.size();
      befS = frameCount;
    }
    break;

  default : 
    message = "エラー";
    break;
  }
  //時間経過による評価セリフを選択
  if (m>2) {//経過時間が一定以上なら
    if (s<15) {  //15秒間時間に関することを言う
      if (n.size()>7) {  //ノードが一定数以上なら
        message = mes[TIMER][0];  //もう○○分頑張ってるね！一休みしよう！
      } else {
        message = mes[TIMER][1];  //まだ○○分しか経ってないよ！ゆっくり考えてみて
      }
    }
  }
  println("pahse="+phase+"message"+message);
  return message;
}
void loadWeb_image(String word) {
  println(word);
  //api_keyの更新が必要
  String str[] = loadStrings("https://www.googleapis.com/customsearch/v1?key=AIzaSyCDIu0aU964IOLmx8MACeLpjXwTgf2ZwcQ&cx=000893818175528849387:9ml_7eulfck&searchType=image&q="+word);
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