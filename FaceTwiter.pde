import com.temboo.core.*;
import com.temboo.Library.Twitter.Search.*;
import oscP5.*;
import netP5.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

//OSC
Robot robot;
int i;  
OscP5 oscP5;
NetAddress myRemoteLocation;
int Col=10;

// Create a session using your Temboo account application details
TembooSession session = new TembooSession("XXXX", "myFirstApp", "XXXXXX");

// The name of your Temboo Twitter Profile 
String twitterProfile = "XXXX";

// Declare font and text strings
PFont fontTweet, fontInstructions;
String searchText, tweetText, instructionText;

// Create a JSON object to store the search results
JSONObject searchResults;

void setup() {
  size(700, 350);
  //size(400,400);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,8338);
  // Set up font
  fontTweet = createFont("Courier", 30);
  fontInstructions = createFont("Courier", 20);

  // Set a search term and instructions
  searchText = "Welbeck";
  instructionText = "Press any key to load a new tweet about '"+searchText+"'"; 

  // Display initial tweet
  runTweetsChoreo(); // Run the Tweets Choreo function
  getTweetFromJSON(); // Parse the JSON response
  displayText(); // Display the response
    try
  { 
    robot = new Robot();
  } 
  catch(AWTException e)
  {
    e.printStackTrace();
  }
}

void draw() {
  if (keyPressed) {
    runTweetsChoreo(); // Run the Tweets Choreo function
    getTweetFromJSON(); // Parse the JSON response
    displayText(); // Display the response
  }
}

void runTweetsChoreo() {
  // Create the Choreo object using your Temboo session
  Tweets tweetsChoreo = new Tweets(session);

  // Set Profile
  tweetsChoreo.setCredential(twitterProfile);

  tweetsChoreo.setAccessTokenSecret("XXXXX");
  // Set inputs
  tweetsChoreo.setQuery(searchText);

  // Run the Choreo and store the results
  TweetsResultSet tweetsResults = tweetsChoreo.run();
  
  // Store results in a JSON object
  searchResults = parseJSONObject(tweetsResults.getResponse());
}

void getTweetFromJSON() {
  JSONArray statuses = searchResults.getJSONArray("statuses"); // Create a JSON array of the Twitter statuses in the object
  JSONObject tweet = statuses.getJSONObject(0); // Grab the first tweet and put it in a JSON object
  tweetText = tweet.getString("text"); // Pull the tweet text from tweet JSON object
}

void displayText() {
  println(tweetText); // Print tweet to console

  int margin = 30; // Set margins for text box
  background(255); // Clear background
  // Display tweet
  fill(0); // Set font color
  textFont(fontTweet); // Set tweet font
  text(tweetText, margin, margin, width-margin*3, height-margin*3); // Display tweet text box

  // Display instructions
  fill(0); // Set instruction box color
  rect(0, height-margin*2, width, margin*2); // Draw instruction box rectangle
  fill(255); // Set font color
  textFont(fontInstructions); // Set instructions font
  text(instructionText, margin, height-margin); // Display instructions text
}
//OSC
void oscEvent(OscMessage theOscMessage) {
  String tag =theOscMessage.typetag();
  String addr =theOscMessage.addrPattern();

  int val0= int(theOscMessage.get(0).floatValue());
  /* print the address pattern and the typetag of the received OscMessage */
  print("### received an osc message.");
  print(" addrpattern: "+theOscMessage.addrPattern());
  println(" typetag: "+tag);
  
  if(addr.indexOf("/gesture/nostrils") !=-1){   // Filters out any toggle buttons
        i = int((addr.charAt(1) )) - 0x30;   // returns the ASCII number so convert into a real number by subtracting 0x30
        i= int(theOscMessage.get(0).floatValue());     //  Puts button value into led[i]
        println("Int:" + i);
 }
  if(i==6){
    
   robot.keyPress(KeyEvent.VK_A);
   Col=255;
   
}
else
Col = 0;
}
