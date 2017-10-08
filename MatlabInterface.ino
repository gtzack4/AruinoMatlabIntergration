
#define BAUDRATE 2000000
String inputString = "";         // a String to hold incoming data
String dataString1 = "";         // a String to hold incoming data
String dataString2 = "";         // a String to hold incoming data
String dataString3 = "";         // a String to hold incoming data
String dataString4 = "";         // a String to hold incoming data
String functionName = "";         // a String to hold incoming data

boolean stringComplete = false;  // whether the string is complete
// function list
void handShake();
void function1();
void setup()  
{
  Serial.begin(BAUDRATE);
  // reserve 20 bytes for the inputString:
  inputString.reserve(20);
  dataString1.reserve(20);
  dataString2.reserve(20);
  dataString3.reserve(20);
  dataString4.reserve(20);
  functionName.reserve(20);
}
void loop() 
{
  if (stringComplete)
  {
    if (functionName == "handShake"){
      handShake();
    }else if (functionName == "function1"){
      function1();
      // make your own function names and calls
    }else if (functionName == "function2"){
      
    }else if (functionName == "function3"){
      
    }else if (functionName == "function4"){
      
    
    }
    stringComplete = false;
  }
}

/////////////////functions////////////////////////////////
void handShake(){
  Serial.println("Hey Matlab this is Arduino.");
}

void function1(){
  Serial.println("function1");
}

void function2(){
  
}

void function3(){
  
}

void function4(){
  
}


void serialEvent() { //interrups when data is available
  stringComplete = true;
  //Serial.println("serialEvent");
  while (Serial.available()) {
    
    // get the new byte:
    char inChar = (char)Serial.read();
    
    // add it to the inputString:
    inputString += inChar;
    
    // if the incoming character is a newline, set a flag so the main loop can
    // do something about it:
    if (inChar == '\n') {
      stringComplete = true;
      //Serial.println(inputString);
    }
    //delay(2); // needed for 96k baudrate
  }
  //get index of all : 
  int idx1 = inputString.indexOf(":");
  int idx2 = inputString.indexOf(":",idx1+1);
  int idx3 = inputString.indexOf(":",idx2+1);
  int idx4 = inputString.indexOf(":",idx3+1);
  // parse input string
  functionName = inputString.substring(0     ,idx1);
  dataString1 = inputString.substring(idx1+1, idx2);
  dataString2 = inputString.substring(idx2+1, idx3);
  dataString3 = inputString.substring(idx3+1, idx4);
  dataString4 = inputString.substring(idx4);
  // clear inputString for next mesage
  inputString = "";
}


