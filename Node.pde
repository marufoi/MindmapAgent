class Node {
    String str;

    int x, y; //Nodeの左上の座標
    int node_width, node_height=30;
    int pre_x, pre_y; //前の座標
    int preNode_x, preNode_y; //線を引くための前のnodeの座標

    boolean red_flag = false;
    boolean expand_mode = false;

    //新規作成のとき
    Node(String _str, int _x, int _y) {
        str = _str;
        x = _x-traX;
        y = _y-traY;
        node_width = int(textWidth(str)) * 2 + 16;
        pre_x = x+node_width / 2;
        pre_y = y+node_height / 2;
    }
    //追加作成のとき
    Node(String _str, int _x, int _y, int num) {
        for (int j = 0; j < n.size (); ++j) {
            if (n.get(j).red_flag) {
                num = j;
                break;
            }
        }
        str = _str;
        x = _x - traX;
        y = _y - traY;
        node_width = int(textWidth(str)) * 2 + 16;
        pre_x = n.get(num).x + n.get(num).node_width / 2; 
        pre_y = n.get(num).y + 15;
    }
    //expand_modeの時
    Node(String _str, int _x, int _y, int num, int hoge) {
        expand_mode = true;

        str = _str;
        x = (_x + n.get(randomNode).x) / 2 - traX;
        y = (_y + n.get(randomNode).y) / 2 - traY;

        node_width = int(textWidth(str)) * 2 +16;

        pre_x = n.get(num).x + n.get(num).node_width / 2; 
        pre_y = n.get(num).y + 15;

        preNode_x = n.get(randomNode).x + n.get(num).node_width / 2; 
        preNode_y = n.get(randomNode).y + 15;
        randomNode = -1;
    }

    void linedisp() {
        if (expand_mode) {
            pushMatrix();
            fill(0, 0, 255);
            if (mousePressed) {
                if (mouseButton == LEFT) {
                    traX += (mouseX-pmouseX)/2;
                    traY += (mouseY-pmouseY)/2;
                }
            }
            translate(traX, traY);
            //
            fill(0, 0, 255);
            stroke(0, 0, 255);
            line(x+node_width/2, y+node_height/2, pre_x, pre_y);
            line(x+node_width/2, y+node_height/2, preNode_x, preNode_y);
            popMatrix();
        } else {
            pushMatrix();
            if (mousePressed) {
                if (mouseButton == LEFT) {
                    traX += (mouseX-pmouseX)/2;
                    traY += (mouseY-pmouseY)/2;
                }
            }
            translate(traX, traY);
            fill(0, 0, 255);
            stroke(0);
            line(x+node_width/2, y+node_height/2, pre_x, pre_y);
            popMatrix();
        }
    }
    void textdisp(int i) {
        pushMatrix();

        translate(traX, traY);
        if (randomNode == i) {
            stroke(0, 0, 255);
            println("aoi");
        } else if (red_flag) {
            stroke(255, 0, 0);
        } else {
            stroke(0);
        }
        fill(255);
        rect(x, y, node_width, node_height);

        fill(0, 0, 0);
        textAlign(LEFT, CENTER);

        text(str, x+node_width/7, y+node_height/2);
        popMatrix();
    }
    void delete(int i) {
        if (x < mouseX &&
            y < mouseY &&
            x + node_width > mouseX &&
            y + node_height > mouseY) {
            if (mousePressed) {
                println(i+"delete");
                n.remove(i);
            }
        }
    }
    void select(int i) {
        int j;
        if (x < mouseX &&
            y < mouseY &&
            x + node_width > mouseX &&
            y + node_height > mouseY) {
            for (j = 0; j < n.size (); ++j) {
                if (n.get(j).red_flag) {
                    n.get(j).red_flag = false;
                    break;
                }
            }
            if (i==j) {
                red_flag = false;
            } else {
                red_flag = !red_flag;
            }
        }
    }
}