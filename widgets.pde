abstract class Component extends Group {
  int x,y,w,h;
  String _id = "";
  
  Component position(int a, int b) {
    x=a; y=b; return this;
  }
  
  Component width(int a) {
    w=a; return this;
  }
  
  Component height(int a) {
    h=a; return this;
  }
  
  Component size(int a, int b) {
    w=a; h=b; return this;
  }
  
  Component id(String n) {
    _id = n; return this;
  }
  
  String id() {
    return _id;
  }
  
  void keyStroke(int k, int c, Action act) {}
  
  void mouseDown(float a, float b, Action act) {}
  
  void mouseUp(float a, float b, Action act) {}
  
  abstract void update();
 
}

abstract class Container extends Component {
  
  Component getById(String n) {
    Component c=null;
    for (int i=0; i<len();i++) {
      c = ((Component)get(i));
      if (c.id().equals(n)) 
        return c;
      else if (c instanceof Container) {
        Component x=null;
        x = ((Container)c).getById(n);
        if (x!=null) return x;
      } 
    }
    return null;
  }
  
  void keyStroke(int k, int c, Action act) {
    for (int i=0; i<len();i++)
      ((Component)get(i)).keyStroke(k,c,act);
  }
  
  void mouseDown(float a, float b, Action act) {
    for (int i=0; i<len();i++)
      ((Component)get(i)).mouseDown(a,b,act);
  }
  
  void mouseUp(float a, float b, Action act) {
    for (int i=0; i<len();i++)
      ((Component)get(i)).mouseUp(a,b,act);
  }
}

class Panel extends Container {
  
  void update() {
    for (int i=0; i<len();i++) {
      Component c = ((Component)get(i));
      c.update();
    }
  }
}

Panel newPanel() {
  return new Panel();
}

class Label extends Component {
  private String str;
  
  Label(String a) { str=a; }
  
  void update() {
    empty();
    add(newText(str,x,y+h/2));
  }
}

Label newLabel(String s) {
  return new Label(s);
}

Control focus;

abstract class Control extends Component {
  boolean hasFocus = false;
  String _value;
  
  Control value(String n) {
    _value = n; return this;
  }
  
  String value() {
    return _value;
  }
  
  void mouseDown(float a, float b, Action act) {
    if ((x<a)&&(a<x+w)&&(y<b)&&(b<y+h)) {
      if (focus!=null&&focus!=this) {
        focus.hasFocus=false;
        focus.update();
      }
      focus = this;
      hasFocus = true;
      if (act!=null) act.run(this);
    }
    update();
  }
}

class Button extends Control {
  private String str;
  int textAdjust = 6;
  int clr = 220;
  float curve = 0;
  Button(String l) { str = l;fillColor(clr); }
  Button(String l, float c) { str = l; curve = c; fillColor(clr); }
  void update() {
    empty();

    if (hasFocus) clr = #D3E7ED;
    add(newRect(x,y,w,h,curve));
    add(newText(str,x+w/2-str.length()*textAdjust,y+h/2));
  }
  
  void mouseUp(float a, float b, Action act) {
    if ((x<a)&&(a<x+w)&&(y<b)&&(b<y+h)) {
      if (focus==this) {
        focus = null;
        hasFocus = false;
        update();
      }
      if (act!=null) act.run(this);
    }
  }
}

Button newButton(String l) {
  return new Button(l);
}

Button newButton(String l, float c) {
  return new Button(l, c);
}

class TextComponent extends Control {
  String label;
  
  int start = 0;
  int _columns = 13;
  int clr = #96A4B0;
  TextComponent value(String a) {
    label = _value = a; return this;
  }
  
  TextComponent columns(int a) {
    _columns = a; return this;
  }
  void update() {
    empty();
    
    //if (hasFocus) clr = #D3E7ED;
    add(newRect(x,y,w,h));
    add(newText(label,x+4,y+h/2));
  }
}

class TextField extends TextComponent {
  
  void keyStroke(int keyValue, int keySpecial, Action act) {
    if (!hasFocus) return;
    if (act!=null) act.run(this);
    if (keyValue == BACKSPACE) {
      if (_value.length()!=0)
        _value = _value.substring(0,_value.length()-1);
    } else
      _value += char(keyValue);
      //_value += String.fromCharCode(keyValue);
    int len = _value.length();
    if (start+len>_columns) { 
      start = len-_columns;
      len = start+_columns;
    }
    label = _value.substring(start,len);
    update();
  }
}

TextField newTextField() {
  return new TextField();
}

class RadioButton extends Control {
  private String str;
  private RadioButtonGroup group;
  boolean checked;
  
  RadioButton(String l) { 
    str = l;
  }
  
  RadioButton group(RadioButtonGroup g) {
    group = g;
    g.add(this);
    return this;
  }
  
  void update() {
    empty();
    int clr = 255;
    _value = "";
    if (hasFocus) {
      checked = true;
      _value = "checked";
      if (group!=null) 
        group.checkRadio(this);
    }
    if (checked) clr = 0;
    add(newCircle(x+6,y+h/2,12));
    add(newCircle(x+6,y+h/2,8).fillColor(clr));
    add(newText(str,x+18,y+h/2));
  }
}

RadioButton newRadioButton(String l) {
  return new RadioButton(l);
}

class RadioButtonGroup extends Group {

  void checkRadio(RadioButton r) {
    RadioButton temp=null;
    for (int i=0; i<len();i++) {
      temp = (RadioButton)get(i);
      if (temp!=r) {
        temp.checked = false;
        temp.update();
      }
    }  
  }
}

class CheckBox extends Control {
  private String str;
  boolean checked = false;
  
  CheckBox(String l) { str = l; }
  
  void update() {
    empty();
    _value = "";
    add(newRect(x,y+h/2-6,12,12));
    if (hasFocus)
       checked = !checked;
    if (checked) {
      add(newPolyline(new float[] {x+1,y+5,x+6,y+11,x+11,y+1}).translate(0,h/2-6));
      _value = "checked";
    }
    add(newText(str,x+18,y+h/2));
  }
}

CheckBox newCheckBox(String l) {
  return new CheckBox(l);
}

class HBox extends Container {
  float _gap=4;
  
  HBox gap(float a) {
    _gap=a; return this;
  }
  
  void update() {
    int n = 0;
    int offset = x;
    float remain = w;
    for (int i=0; i<len();i++) {
      Component c = ((Component)get(i));
      if (c.w==0) n++;
      else remain -= c.w;
    }
    remain -= _gap*len()-1;
    for (int i=0; i<len();i++) {
      Component c = ((Component)get(i));
      c.x = offset;
      c.y = y;
      if (c.w==0) c.w = (int)remain/n;
      if (c.h==0) c.h = h;
      offset += _gap+c.w;
      c.update();
    }
  }
}

HBox newHBox() {
  return new HBox();
}

class VBox extends Container {
  float _gap=4;
  
  VBox gap(float a) {
    _gap=a; return this;
  }
  
  void update() {
    int n = 0;
    int offset = y;
    float remain = h;
    for (int i=0; i<len();i++) {
      Component c = ((Component)get(i));
      if (c.h==0) n++;
      else remain -= c.h;
    }
    remain -= _gap*len()-1;
    for (int i=0; i<len();i++) {
      Component c = ((Component)get(i));
      c.y = offset;
      c.x = x;
      if (c.h==0) c.h = (int)remain/n;
      if (c.w==0) c.w = w;
      offset += _gap+c.h;
      c.update();
    }
  }
}

VBox newVBox() {
  return new VBox();
}