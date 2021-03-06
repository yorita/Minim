/* delayExample<br/>
 * is an example of using the Delay UGen in a continuous sound example.
 * <p>
 * For more information about Minim and additional features, 
 * visit http://code.compartmental.net/minim/
 * <p>
 * author: Anderson Mills<br/>
 * Anderson Mills's work was supported by numediart (www.numediart.org)
 */

// import everything necessary to make sound.
import ddf.minim.*;
import ddf.minim.ugens.*;

// create all of the variables that will need to be accessed in
// more than one methods (setup(), draw(), stop()).
Minim minim;
AudioOutput out;
Delay myDelay;

// setup is run once at the beginning
void setup()
{
  // initialize the drawing window
  size( 512, 200, P2D );

  // initialize the minim and out objects
  minim = new Minim(this);
  out = minim.getLineOut( Minim.MONO, 2048 );
  
  // initialize myDelay1 with continual feedback and audio passthrough
  myDelay = new Delay( 0.6, 0.9, true, true );
  // create the Blip that will be used
  Oscil myBlip = new Oscil( 245.0, 0.3, Waves.saw( 15 ) );
  
  // create an LFO to be used for an amplitude envelope
  Oscil myLFO = new Oscil( 1, 0.3, Waves.square( 0.95 ) );
  // offset the center value of the LFO so that it outputs 0 
  // for the long portion of the duty cycle
  myLFO.offset.setLastValue( 0.3f );

  myLFO.patch( myBlip.amplitude );
  
 // and the Blip is patched through the delay into the sum.
 myBlip.patch( myDelay ).patch( out );
}

// draw is run many times
void draw()
{
  // erase the window to dark grey
  background( 64 );
  // draw using a light gray stroke
  stroke( 192 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }  
}

// when the mouse is moved, change the delay parameters
void mouseMoved()
{
  // set the delay time by the horizontal location
  float delayTime = map( mouseX, 0, width, 0.0001, 0.5 );
  myDelay.setDelTime( delayTime );
  // set the feedback factor by the vertical location
  float feedbackFactor = map( mouseY, 0, height, 0.0, 0.99 );
  myDelay.setDelAmp( feedbackFactor );
}
