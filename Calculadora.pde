import java.util.Stack;

Group screen;
Panel panel;
String operActual = "";
String actual = "0";
String anterior = "0";
TextField text;
Modelo modelo = new Modelo();

void setup() {
  size(242,336);
  screen = newGroup();
  color blanco = 255;
  color gris = #76888E;
  color amarillo = #FDBC40;
  color naranja = #F5923E;
  color rojo = #FC5652;
  color verde = #35C749;
  
  Rect frame = newRect(0,0,241,335,5);
  frame.fillColor(gris);
  
  panel = newPanel();
  
  panel.add(newVBox().gap(0).position(10,5).size(60,10)
      .add(newHBox().gap(10)
        .add(newButton("", 10).fillColor(rojo).strokeColor(rojo))
        .add(newButton("", 10).fillColor(amarillo).strokeColor(amarillo))
        .add(newButton("", 10).fillColor(verde).strokeColor(verde)))
        );

  panel.add(
    newVBox().gap(10).position(2,18).size(237,70)
    .add(newHBox()
      .add(newTextField().columns(12).value("0").id("resultado"))
      .fontSize(40).fontColor(255).strokeColor(gris).fillColor(gris))
    );
    
  panel.add(newVBox().gap(0.5).position(2,85).size(240,60)
      .add(newHBox().gap(0.5).position(0,0).size(237,50)
        .add(newButton("C").id("C").strokeColor(gris))
        .add(newButton("+/-").id("+/-").strokeColor(gris))
        .add(newButton("%").id("%").strokeColor(gris))
        .add(newButton("÷").id("÷").strokeColor(gris).fontColor(blanco).fillColor(naranja)).fontSize(22)
    )
    .add(newHBox().gap(0.5).position(0,0).size(237,50)
      .add(newButton("7").id("7").strokeColor(gris))
      .add(newButton("8").id("8").strokeColor(gris))
      .add(newButton("9").id("9").strokeColor(gris))
      .add(newButton("x").id("x").strokeColor(gris).fontColor(blanco).fillColor(naranja)).fontSize(22)
    )
    .add(newHBox().gap(0.5).position(0,0).size(237,50)
      .add(newButton("4").id("4").strokeColor(gris))
      .add(newButton("5").id("5").strokeColor(gris))
      .add(newButton("6").id("6").strokeColor(gris))
      .add(newButton("-").id("-").strokeColor(gris).fontColor(blanco).fillColor(naranja)).fontSize(22)
    )
    .add( newHBox().gap(0.5).position(0,0).size(237,50)
      .add(newButton("1").id("1").strokeColor(gris))
      .add(newButton("2").id("2").strokeColor(gris))
      .add(newButton("3").id("3").strokeColor(gris))
      .add(newButton("+").id("+").strokeColor(gris).fontColor(blanco).fillColor(naranja)).fontSize(22)
    )
    .add( newHBox().gap(0.5).position(0,0).size(237,50)
      .add(newButton("0").id("0").size(118,50).strokeColor(gris))
      .add(newButton(",").id(".").strokeColor(gris))
      .add(newButton("=").id("=").strokeColor(gris).fontColor(blanco).fillColor(naranja)).fontSize(22)
    )
  );
  
    
  panel.update();
  
  screen.add(frame).add(panel);
}

void draw() {
  background(255);
  screen.draw();
  //panel.draw();
}

void mousePressed() {
  panel.mouseDown(mouseX,mouseY,new Click());
}

void mouseReleased() {
  panel.mouseUp(mouseX,mouseY,null);
}

void keyPressed() {
  panel.keyStroke(key,keyCode,null);
}

class Click extends Action {
  void run(Graphic g) {
    Control c = (Control)g;
    text = (TextField)panel.getById("resultado");
    switch(c.id()){
      case "C":
        anterior = "0";
        actual = "0";
        modelo.limpiar();
        break;
      case "+/-":
        if(actual.charAt(0) == '-')
          actual = actual.substring(1);
        else
          actual = "-" + actual;
        break;
      case "%":
        actual = Float.parseFloat(actual)/100 + "";
        break;
      case "÷":
        modelo.agregarOperando(Float.parseFloat(actual));
        modelo.dividir();
        break;
      case "x":
        modelo.agregarOperando(Float.parseFloat(actual));
        modelo.multiplicar();
        break;
      case "-":
        modelo.agregarOperando(Float.parseFloat(actual));
        modelo.restar();
        break;
      case "+":
        modelo.agregarOperando(Float.parseFloat(actual));
        modelo.sumar();
        break;
      case "=":
        modelo.agregarOperando(Float.parseFloat(actual));
        break;
    }
    mostrar(c.id());
    text.update();
    //println(modelo.toString());
    
  }  
}

void mostrar (String symbol){
   if(!symbol.equals("C")&& !symbol.equals("+/-") && !symbol.equals("%") && !symbol.equals("+")
     && !symbol.equals("-") && !symbol.equals("x") && !symbol.equals("÷") && !symbol.equals("=")){
     if(actual.equals("0"))
       actual = symbol;
     else
       actual += symbol; 
    }
    else if(symbol.equals("+") || symbol.equals("-") || symbol.equals("x") || symbol.equals("÷")){   
       if(anterior.equals("0"))
         anterior = actual + symbol;
       else
         anterior = anterior + actual + symbol;
       actual = "0";
    }
    else if(symbol.equals("=")){
       anterior = actual = modelo.resultado() + "";
       modelo.agregarOperando(Float.parseFloat(actual));
       anterior = "0"; 
    }
   
    println("Anterior: " + anterior + " Actual: " + actual);
    
    if(anterior.equals("0"))
       text.value(actual);
    else if(actual.equals("0"))
      text.value(anterior);      
    else
      text.value(anterior + actual);
      
}

  
  public class Modelo {

    ArrayList<Object> expEntreFija;

    public Modelo() {
        expEntreFija = new ArrayList();
    }

    private boolean precedencia(String tope, String nuevo) {
        println("Verificando precendencia de: " + tope + ", " + nuevo);
        boolean bandera = true;
        if (("+".equals(nuevo) || "-".equals(nuevo)) && !"(".equals(tope)) {
            bandera = false;
        }
        return bandera;
    }

    public void limpiar() {
        expEntreFija.clear();
    }

    public float resultado() {
        float resultado = 0.0;
        if (!expEntreFija.isEmpty()) {
            println("Expresión a desarrollar: " + expEntreFija.toString());
            resultado = resolverExpPostFija(pasarAPostFijo());
            println("Resultado: " + resultado);
        }
        return resultado;
    }

    public void agregarOperando(float operando) {
        expEntreFija.add(operando);
    }

    public void sumar() {
        expEntreFija.add("+");
    }

    public void restar() {
        expEntreFija.add("-");
    }

    public void multiplicar() {
        expEntreFija.add("*");
    }

    public void dividir() {
        expEntreFija.add("/");
    }

    public void raizCuadrada(float operando) {
        expEntreFija.add(Math.sqrt(operando));
    }

    public void porcentaje(float operando) {
        expEntreFija.add(operando / 100);
    }

    public void reciproco(float operando) {
        expEntreFija.add(1 / operando);
    }

    private ArrayList<Object> pasarAPostFijo() {

        Stack<Object> operadores = new Stack();
        ArrayList<Object> expPostFija = new ArrayList();
        int cont = 0;
        while (!expEntreFija.isEmpty()) {
            cont++;
            Object simbolo = expEntreFija.remove(0);
            println("Simbolo en turno " + cont + ": " + simbolo);
            if (simbolo instanceof Float) {
                expPostFija.add(simbolo);
                println("Pasando a postFija desde if 1: " + simbolo + " " + expPostFija.size());
            }
            if (simbolo == "+" || simbolo == "-" || simbolo == "*" || simbolo == "/") {
                while (!operadores.isEmpty() && !precedencia(operadores.elementAt(0).toString(), simbolo.toString())) {
                    println("Pasando a postFija desde if 2: " + operadores.get(0) + " " + expPostFija.size());
                    expPostFija.add(operadores.remove(0));
                }
                operadores.add(0, simbolo);
                println("Pasando a operadores desde if 2: " + simbolo + " " + operadores.size());
            }
            if (simbolo == "(") {
                operadores.add(0, simbolo);
                println("Pasando a operadores desde if 3: " + simbolo + " " + operadores.size());
            }
            if (simbolo == ")") {
                while (operadores.elementAt(0) != "(") {
                    expPostFija.add(operadores.get(0));
                    println("Pasando a postFija desde if 4: " + simbolo + " " + expPostFija.size());
                }
                operadores.get(0);
            }
        }

        while (!operadores.isEmpty()) {
            expPostFija.add(operadores.remove(0));
        }
        return expPostFija;
    }

    
    private float resolverExpPostFija(ArrayList<Object> expPostFija) {
        println("Expresión recibida: " + expPostFija.toString());
        float resultado = (float) 0;
        Stack<Object> operandos = new Stack();

        while (!expPostFija.isEmpty()) {
            Object simbolo = expPostFija.remove(0);
            if (simbolo instanceof Float) {
                operandos.add(0, simbolo);
            }
            if (simbolo == "+") {
                float b = (float) operandos.remove(0);
                float a = (float) operandos.remove(0);
                operandos.add(0, a + b);
            }
            if (simbolo == "-") {
                float b = (float) operandos.remove(0);
                float a = (float) operandos.remove(0);
                operandos.add(0, a - b);
            }
            if (simbolo == "*") {
                float b = (float) operandos.remove(0);
                float a = (float) operandos.remove(0);
                operandos.add(0, a * b);
            }
            if (simbolo == "/") {
                float b = (float) operandos.remove(0);
                float a = (float) operandos.remove(0);
                operandos.add(0, a / b);
            }
        }
        resultado = (float) operandos.remove(0);

        return resultado;
    }
    
    public String toString(){
      
      return expEntreFija.toString();
    }

}



  