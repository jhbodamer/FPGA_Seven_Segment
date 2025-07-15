This was a simple project I did as an introduction to VHDL. I wrote two VHDL files with the accompanying constraints file. 
The first spells out my name "John" on the display as shown below.

<img src="John.jpg" alt="Example Image" width="400"/>

The second file is a stopwatch-style counter with accuracy down to a centisecond. One button resets the counter and the other stops it.

<img src="Timer.jpg" alt="Example Image" width="400"/>
With the common anode configuration, the bus called digit is used to select one digit at a time by setting it low, using a FSM to cycle through the four digits quickly.
The picture below shows both the pin connections and which segment each of the bits in the 8 bit bus correspond to. I also included a wiring diagram.

<img src="John.jpg" alt="SegmentLayouts.jpg" width="400"/>
<img src="sevenseg_schematic.svg" alt="Example Image" width="400"/>
