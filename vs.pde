/*
height: 320
 license: gpl-3.0
 *//* Visual Structure Library *//* Copyright (c) 2016 Armando Arce, GPL3 */abstract class Graphic {
  protected Transform transform=null; 
  protected Graphic parent=null; 
  protected Style style=null; 
  protected Info info=null; 
  boolean isVisible=true; 
  Graphic visible(boolean v) {
    isVisible=v; 
    return this;
  }
  Graphic parent(Graphic g) {
    parent=g; 
    return this;
  }
  Graphic info(Info i) {
    info=i; 
    return this;
  }
  Graphic fillColor(color f) {
    if (style==null) style=new Style(); 
    style.fillColor(f); 
    return this;
  }
  Graphic strokeColor(color s) {
    if (style==null) style=new Style(); 
    style.strokeColor(s); 
    return this;
  }
  Graphic strokeWidth(float w) {
    if (style==null) style=new Style(); 
    style.strokeWidth(w); 
    return this;
  }
  Graphic translate(float a, float b) {
    if (transform==null) transform=new Transform(); 
    transform.translation(a, b); 
    return this;
  }
  Graphic scale(float a, float b) {
    if (transform==null) transform=new Transform(); 
    transform.scalation(a, b); 
    return this;
  }
  Graphic rotate(float a) {
    if (transform==null) transform=new Transform(); 
    transform.rotation(a); 
    return this;
  }
  Graphic resetTrans() {
    if (transform==null) transform=new Transform(); 
    transform.reset(); 
    return this;
  }
  void preDraw() {
    if (System.style==null) System.style=newStyle() .fillColor(255) .strokeColor(0) .strokeWidth(1); 
    if (style!=null) {
      System.pushStyle(new Style()); 
      if (style.stroke_width>0) System.stroke_width *=style.stroke_width; 
      style.setProp();
    }
    System.style.draw(); 
    if (transform!=null) {
      pushMatrix(); 
      transform.draw();
    }
  }
  abstract void draw(); 
  void postDraw() {
    if (style!=null) {
      System.popStyle(); 
      if (style.stroke_width>0) System.stroke_width /=style.stroke_width;
    }
    if (transform!=null) popMatrix();
  }
  void click(float x, float y, Action act) {
  };
}
abstract class Action {
  abstract void run(Graphic g);
}
abstract class Info {
}
class Transform {
  final int TRANSLATE=0; 
  final int SCALE=1; 
  final int ROTATE=2; 
  private ArrayList trans; 
  class Method {
    int type; 
    float x, y; 
    Method(int t, float a, float b) {
      type=t; 
      x=a; 
      y=b;
    }
  }
  Transform() {
    trans=new ArrayList();
  }
  Transform translation(float x, float y) {
    trans.add(new Method(TRANSLATE, x, y)); 
    return this;
  }
  Transform scalation(float x, float y) {
    trans.add(new Method(SCALE, x, y)); 
    return this;
  }
  Transform rotation(float x) {
    trans.add(new Method(ROTATE, x, 0)); 
    return this;
  }
  Transform reset() {
    trans.clear(); 
    return this;
  }
  void draw() {
    for (int i=0; i<trans.size(); i++) {
      Method m=(Method)trans.get(i); 
      switch (m.type) {
      case TRANSLATE: 
        translate(m.x, m.y); 
        break; 
      case SCALE: 
        scale(m.x, m.y); 
        break; 
      case ROTATE: 
        rotate(radians(m.x)); 
        break;
      }
    }
  }
}
Transform newTransform() {
  return new Transform();
}
class Style {
  static final int NONE=-1; 
  color fill_color=MAX_INT; 
  color stroke_color=MAX_INT; 
  float stroke_width=0; 
  Style() {
  }
  Style fillColor(color a) {
    fill_color=a; 
    return this;
  }
  Style strokeColor(color a) {
    stroke_color=a; 
    return this;
  }
  Style strokeWidth(float a) {
    stroke_width=a; 
    return this;
  }
  void setProp() {
    if (fill_color!=MAX_INT) System.style.fill_color=fill_color; 
    if (stroke_color!=MAX_INT) System.style.stroke_color=stroke_color; 
    if (stroke_width!=0) System.style.stroke_width=stroke_width;
  }
  void draw() {
    if (System.style.fill_color==NONE) noFill(); 
    else if (System.style.fill_color!=MAX_INT) fill(System.style.fill_color); 
    if (System.style.stroke_color==NONE) noStroke(); 
    else if (System.style.stroke_color!=MAX_INT) stroke(System.style.stroke_color); 
    if (System.style.stroke_width!=0) strokeWeight(System.stroke_width);
  }
}
Style newStyle() {
  return new Style();
}
static class System {
  static float stroke_width=1; 
  static float xCoord; 
  static float yCoord; 
  static Symbol symbol=null; 
  static Style style=null; 
  static Font font=null; 
  static ArrayList styles=new ArrayList(); 
  static ArrayList fonts=new ArrayList(); 
  static ArrayList symbols=new ArrayList(); 
  static void reset() {
    stroke_width=1;
  }
  static void pushStyle(Style s) {
    s.fill_color=System.style.fill_color; 
    s.stroke_color=System.style.stroke_color; 
    s.stroke_width=System.style.stroke_width; 
    styles.add(s);
  }
  static void popStyle() {
    System.style=(Style)styles.get(styles.size()-1); 
    styles.remove(styles.size()-1);
  }
  static void pushFont(Font f) {
    f.font_size=System.font.font_size; 
    f.text_align_v=System.font.text_align_v; 
    f.text_align_h=System.font.text_align_h; 
    f.text_color=System.font.text_color; 
    fonts.add(f);
  }
  static void popFont() {
    System.font=(Font)fonts.get(fonts.size()-1); 
    fonts.remove(fonts.size()-1);
  }
  static void pushSymbol() {
    symbols.add(System.symbol);
  }
  static void popSymbol() {
    System.symbol=(Symbol)symbols.get(symbols.size()-1); 
    symbols.remove(symbols.size()-1);
  }
}
class Group extends Graphic {
  private ArrayList children; 
  private Font font; 
  private Symbol _symbol; 
  Group() {
    children=new ArrayList();
  }
  Group fillColor(color f) {
    super.fillColor(f); 
    return this;
  }
  Group strokeColor(color s) {
    super.strokeColor(s); 
    return this;
  }
  Group strokeWidth(float w) {
    super.strokeWidth(w); 
    return this;
  }
  Group translate(float a, float b) {
    super.translate(a, b); 
    return this;
  }
  Group scale(float a, float b) {
    super.scale(a, b); 
    return this;
  }
  Group rotate(float a) {
    super.rotate(a); 
    return this;
  }
  Group fontSize(int s) {
    if (font==null) font=newFont(); 
    font.size(s); 
    return this;
  }
  Group fontFamily(String f) {
    if (font==null) font=newFont(); 
    font.family(f); 
    return this;
  }
  Group fontAlign(int a, int b) {
    if (font==null) font=newFont(); 
    font.align(a, b); 
    return this;
  }
  Group fontRotation(int a) {
    if (font==null) font=newFont(); 
    font.rotation(a); 
    return this;
  }
  Group fontColor(int c) {
    if (font==null) font=newFont(); 
    font.colour(c); 
    return this;
  }
  Group symbol(float[] v) {
    if (_symbol==null) _symbol=newSymbol(); 
    _symbol.vertices=v; 
    return this;
  }
  Group symbolMode(int m) {
    if (_symbol==null) _symbol=newSymbol(); 
    _symbol.mode=m; 
    return this;
  }
  Group add(Graphic g) {
    children.add(g); 
    g.parent(this); 
    return this;
  }
  int len() {
    return children.size();
  }
  Graphic get(int i) {
    return (Graphic)children.get(i);
  }
  Group empty() {
    children.clear(); 
    return this;
  }
  void click(float x, float y, Action act) {
    for (int i=0; i<len(); i++) ((Graphic)get(i)).click(x, y, act);
  }
  void preDraw() {
    super.preDraw(); 
    if (font!=null) {
      System.pushFont(new Font()); 
      font.setProp();
    }
    System.font.draw(); 
    if (_symbol!=null) {
      System.pushSymbol();
    }
  }
  void postDraw() {
    if (font!=null) System.popFont(); 
    if (_symbol!=null) System.popSymbol(); 
    super.postDraw();
  }
  void draw() {
    if (!isVisible) return; 
    if (System.font==null) System.font=newFont().size(12) .align(LEFT, CENTER).colour(0); 
    if (System.symbol==null) System.symbol=newSymbol(); 
    preDraw(); 
    for (int i=0; i<children.size(); i++) ((Graphic)children.get(i)).draw(); 
    postDraw();
  }
}
Group newGroup() {
  return new Group();
}
class Font {
  protected PFont font=null; 
  protected String font_family=null; 
  protected int font_size=0; 
  protected int text_align_v=-1; 
  protected int text_align_h=-1; 
  protected int text_color=MAX_INT; 
  protected int text_rotation=0; 
  Font() {
  }
  Font family(String f) {
    font_family=f; 
    return this;
  }
  Font size(int s) {
    font_size=s; 
    return this;
  }
  Font align(int a, int b) {
    text_align_h=a; 
    text_align_v=b; 
    return this;
  }
  Font colour(int c) {
    text_color=c; 
    return this;
  }
  Font rotation(int a) {
    text_rotation=a; 
    return this;
  }
  void setProp() {
    if ((font==null)&&(font_family!=null)) font=loadFont(font_family); 
    if (font_size!=0) System.font.font_size=font_size; 
    if (text_align_v!=-1) System.font.text_align_v=text_align_v; 
    if (text_align_h!=-1) System.font.text_align_h=text_align_h; 
    if (text_color!=MAX_INT) System.font.text_color=text_color; 
    if (text_rotation!=0) System.font.text_rotation=text_rotation;
  }
  void draw() {
    if (System.font.font!=null) textFont(System.font.font); 
    if (System.font.font_size!=0) textSize(System.font.font_size); 
    if (System.font.text_align_v!=-1) textAlign(System.font.text_align_h, System.font.text_align_v); 
    if (System.font.text_color!=MAX_INT) fill(System.font.text_color);
  }
}
Font newFont() {
  return new Font();
}
class Rect extends Graphic {
  float x, y, w, h, r; 
  boolean rounded; 
  Rect(float a, float b, float c, float d) {
    x=a;
    y=b;
    w=c;
    h=d;
    rounded=false;
  }
  Rect(float a, float b, float c, float d, float e) {
    x=a;
    y=b;
    w=c;
    h=d;
    r=e;
    rounded=true;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    if (rounded) rect(x, y, w, h, r); 
    else rect(x, y, w, h); 
    postDraw();
  }
}
Rect newRect(float a, float b, float c, float d) {
  return new Rect(a, b, c, d);
}
Rect newRect(float a, float b, float c, float d, float e) {
  return new Rect(a, b, c, d, e);
}
class Arc extends Graphic {
  float x1, x2, x3, y1, y2, y3; 
  Arc(float a, float b, float c, float d, float e, float f) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
    x3=e;
    y3=f;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    arc(x1, y1, x2, y2, x3, y3); 
    postDraw();
  }
}
Arc newArc(float a, float b, float c, float d, float e, float f) {
  return new Arc(a, b, c, d, e, f);
}
class Bezier extends Graphic {
  float x1, x2, x3, x4, y1, y2, y3, y4; 
  Bezier(float a, float b, float c, float d, float e, float f, float g, float h) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
    x3=e;
    y3=f;
    x4=g;
    y4=h;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    bezier(x1, y1, x2, y2, x3, y3, x4, y4); 
    postDraw();
  }
}
Bezier newBezier(float a, float b, float c, float d, float e, float f, float g, float h) {
  return new Bezier(a, b, c, d, e, f, g, h);
}
class Curve extends Graphic {
  float x1, x2, x3, x4, y1, y2, y3, y4; 
  Curve(float a, float b, float c, float d, float e, float f, float g, float h) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
    x3=e;
    y3=f;
    x4=g;
    y4=h;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    curve(x1, y1, x2, y2, x3, y3, x4, y4); 
    postDraw();
  }
}
Curve newCurve(float a, float b, float c, float d, float e, float f, float g, float h) {
  return new Curve(a, b, c, d, e, f, g, h);
}
class Ellipse extends Graphic {
  float x, y, rx, ry; 
  Ellipse(float a, float b, float c, float d) {
    x=a;
    y=b;
    rx=c;
    ry=d;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    ellipse(x, y, rx, ry); 
    postDraw();
  }
}
Ellipse newEllipse(float x, float y, float a, float b) {
  return new Ellipse(x, y, a, b);
}
class Circle extends Graphic {
  float x, y, r; 
  Circle(float a, float b, float c) {
    x=a;
    y=b;
    r=c;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    ellipse(x, y, r, r); 
    postDraw();
  }
}
Circle newCircle(float a, float b, float c) {
  return new Circle(a, b, c);
}
class Line extends Graphic {
  float x1, x2, y1, y2; 
  Line(float a, float b, float c, float d) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    line(x1, y1, x2, y2); 
    postDraw();
  }
}
Line newLine(float a, float b, float c, float d) {
  return new Line(a, b, c, d);
}
class Triangle extends Graphic {
  float x1, x2, x3, y1, y2, y3; 
  Triangle(float a, float b, float c, float d, float e, float f) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
    x3=e;
    y3=f;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    triangle(x1, y1, x2, y2, x3, y3); 
    postDraw();
  }
}
Triangle newTriangle(float a, float b, float c, float d, float e, float f) {
  return new Triangle(a, b, c, d, e, f);
}
class Quad extends Graphic {
  float x1, x2, x3, x4, y1, y2, y3, y4; 
  Quad(float a, float b, float c, float d, float e, float f, float g, float h) {
    x1=a;
    y1=b;
    x2=c;
    y2=d;
    x3=e;
    y3=f;
    x4=g;
    y4=h;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    quad(x1, y1, x2, y2, x3, y3, x4, y4); 
    postDraw();
  }
}
Quad newQuad(float a, float b, float c, float d, float e, float f, float g, float h) {
  return new Quad(a, b, c, d, e, f, g, h);
}
class Text extends Graphic {
  float x, y, w, h; 
  String str; 
  Font font; 
  Text(String s, float a, float b, float c, float d) {
    str=s;
    x=a;
    y=b;
    w=c;
    h=d;
  }
  Text(String s, float a, float b) {
    str=s;
    x=a;
    y=b;
  }
  Text fontSize(int s) {
    if (font==null) font=newFont(); 
    font.size(s); 
    return this;
  }
  Text fontFamily(String f) {
    if (font==null) font=newFont(); 
    font.family(f); 
    return this;
  }
  Text fontAlign(int a, int b) {
    if (font==null) font=newFont(); 
    font.align(a, b); 
    return this;
  }
  Text fontRotation(int a) {
    if (font==null) font=newFont(); 
    font.rotation(a); 
    return this;
  }
  Text fontColor(int c) {
    if (font==null) font=newFont(); 
    font.colour(c); 
    return this;
  }
  void preDraw() {
    super.preDraw(); 
    if (font!=null) {
      System.pushFont(new Font()); 
      font.setProp();
    }
    System.font.draw();
  }
  void postDraw() {
    if (font!=null) System.popFont(); 
    super.postDraw();
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    if ((w==0)&&(h==0)) text(str, x, y); 
    else text(str, x, y, w, h); 
    postDraw();
  }
}
Text newText(String s, float a, float b, float c, float d) {
  return new Text(s, a, b, c, d);
}
Text newText(String s, float a, float b) {
  return new Text(s, a, b);
}
class Bounds {
  float xMin, yMin, xMax, yMax; 
  Bounds(float a, float b, float c, float d) {
    xMin=a; 
    yMin=b; 
    xMax=c; 
    yMax=d;
  }
  Bounds(Bounds b) {
    xMin=b.xMin;
    yMin=b.yMin;
    xMax=b.xMax;
    yMax=b.yMax;
  }
  float w() {
    return xMax-xMin;
  }
  float h() {
    return yMax-yMin;
  }
  Bounds include(float x, float y) {
    if (x<xMin) xMin=x; 
    if (x>xMax) xMax=x; 
    if (y<yMin) yMin=y; 
    if (y>yMax) yMax=y; 
    return this;
  }
  Bounds union(Bounds b) {
    include(b.xMin, b.yMin); 
    include(b.xMax, b.yMax); 
    return this;
  }
  Bounds translate(float x, float y) {
    xMin +=x; 
    xMax +=x; 
    yMin +=y; 
    yMax +=y; 
    return this;
  }
}
class Shape extends Graphic {
  protected float[] coords; 
  private Bounds bnds; 
  boolean closed; 
  Shape(float[] a, boolean m) {
    coords=a; 
    closed=m; 
    createBounds();
  }
  float[] vertices() {
    return coords;
  }
  Bounds bounds() {
    return bnds;
  }
  void draw() {
    if (!isVisible) return; 
    preDraw(); 
    beginShape(); 
    for (int i=0; i<coords.length/2; i++) vertex(coords[i*2], coords[i*2+1]); 
    if (closed) endShape(CLOSE); 
    else endShape(); 
    postDraw();
  }
  void createBounds() {
    for (int i=0; i<coords.length/2; i++) {
      if (bnds==null) bnds=new Bounds(coords[i*2], coords[i*2+1], coords[i*2], coords[i*2+1]); 
      else bnds.include(coords[i*2], coords[i*2+1]);
    }
  }
}
class Polygon extends Shape {
  Polygon(float[] a) {
    super(a, true);
  }
}
Polygon newPolygon(float[] a) {
  return new Polygon(a);
}
class Polyline extends Shape {
  Polyline(float[] a) {
    super(a, false);
  }
}
Polyline newPolyline(float[] a) {
  return new Polyline(a);
}
class Symbol {
  float[] vertices; 
  int mode; 
  Symbol() {
    vertices=new float[]{-0.5, 0.5, 0.5, 0.5, 0.5, -0.5, -0.5, -0.5};
  }
  Symbol(float[] v, int m) {
    vertices=v; 
    mode=m;
  }
}
Symbol newSymbol() {
  return new Symbol();
}
class Mark extends Graphic {
  float x, y, w, h; 
  Symbol _symbol; 
  Mark(float a, float b, float c, float d) {
    x=a; 
    y=b; 
    w=c; 
    h=d;
  }
  Mark symbol(float[] v) {
    if (_symbol==null) _symbol=newSymbol(); 
    _symbol.vertices=v; 
    return this;
  }
  Mark symbolMode(int m) {
    if (_symbol==null) _symbol=newSymbol(); 
    _symbol.mode=m; 
    return this;
  }
  void draw() {
    if (!isVisible) return; 
    if (System.symbol==null) System.symbol=newSymbol(); 
    Symbol temp=null; 
    preDraw(); 
    if (_symbol!=null) {
      temp=System.symbol; 
      System.symbol=_symbol;
    }
    float[] coords=System.symbol.vertices; 
    beginShape(); 
    for (int i=0; i<coords.length/2; i++) vertex(x+coords[i*2]*System.stroke_width*w, y+coords[i*2+1]*System.stroke_width*h); 
    endShape(CLOSE); 
    if (_symbol!=null) System.symbol=temp; 
    postDraw();
  }
}
Mark newMark(float a, float b, float c, float d) {
  return new Mark(a, b, c, d);
}