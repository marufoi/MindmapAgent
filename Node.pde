class Node{
    String str;
    
    int x,y;
    int nWidth,nHeight=30;
    int px,py;
    int px2,py2;
    
    boolean red_flag = false;
    boolean ndndcreate = false;
    
    //新規作成のとき
    Node(String _str,int _x,int _y){
        str = _str;
        x = _x-traX;
        y = _y-traY;
        nWidth = int(textWidth(str))*2+8+8;
        px = x+nWidth/2;
        py = y+nHeight/2;
    }
    //追加作成のとき
    Node(String _str,int _x,int _y,int num){
        for (int j = 0; j < n.size(); ++j) {
            if (n.get(j).red_flag) {
                num = j;
                break;
            }
        }
        
        str = _str;
        x = _x-traX;
        y = _y-traY;
        nWidth = int(textWidth(str))*2+8+8;
        px = n.get(num).x+n.get(num).nWidth/2; 
        py = n.get(num).y+15;
    }
 //ndndcreateの時
    Node(String _str,int _x,int _y,int num,int hoge){
      ndndcreate = true;
        for (int j = 0; j < n.size(); ++j) {
            if (n.get(j).red_flag) {
                num = j;
                break;
            }
        }
        int randomNode =int( random(0,n.size()));
        while(num == randomNode){
          randomNode =int( random(0,n.size()));
        }
    
        str = _str;
        x = (_x+n.get(randomNode).x)/2-traX;
        y = (_y+n.get(randomNode).y)/2-traY;
        
        nWidth = int(textWidth(str))*2+8+8;
        
        px = n.get(num).x+n.get(num).nWidth/2; 
        py = n.get(num).y+15;
        
        px2 = n.get(randomNode).x+n.get(num).nWidth/2; 
        py2 = n.get(randomNode).y+15;
    }

    void linedisp(){
      if(ndndcreate){
           pushMatrix();
        if(mousePressed){
            if (mouseButton == LEFT) {
                traX += (mouseX-pmouseX)/2;
                traY += (mouseY-pmouseY)/2;
            }
        }
        translate(traX, traY);
        //fill(0);
        stroke(0);
        line(x+nWidth/2, y+nHeight/2, px, py);
        line(x+nWidth/2, y+nHeight/2, px2, py2);
        popMatrix();
        
      }
      else{
        pushMatrix();
        if(mousePressed){
            if (mouseButton == LEFT) {
                traX += (mouseX-pmouseX)/2;
                traY += (mouseY-pmouseY)/2;
            }
        }
        translate(traX, traY);
        //fill(0);
        stroke(0);
        line(x+nWidth/2, y+nHeight/2, px, py);
        popMatrix();
    }
    }
    void textdisp(){
        pushMatrix();
        
        translate(traX, traY);
        if(red_flag){
            stroke(255,0,0);
        }
        else{
            stroke(0);    
        }
        fill(255);
        rect(x,y,nWidth,nHeight);

        fill(0,0,0);
        textAlign(LEFT,CENTER);
        
        text(str,x+nWidth/7,y+nHeight/2);
        popMatrix();
    }
    void delete(int i){
        if(x < mouseX &&
           y < mouseY &&
           x + nWidth > mouseX &&
           y + nHeight > mouseY){
            if(mousePressed){
                println(i+"delete");
                n.remove(i);
            }
        }
        
    }
    void select(int i){
        int j;
        if (x < mouseX &&
            y < mouseY &&
            x + nWidth > mouseX &&
            y + nHeight > mouseY) {
            for (j = 0; j < n.size(); ++j) {
                if (n.get(j).red_flag) {
                    n.get(j).red_flag = false;
                    break;
                }
            }
            if(i==j){
                red_flag = false;
            }
            else {
                red_flag =! red_flag;
            }
            
            
        }
    }

}
