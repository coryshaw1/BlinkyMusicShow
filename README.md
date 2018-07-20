BlinkyLightShow
===============

[![Demo video](https://i.imgur.com/J9L8C6j.png)](https://instagram.fhyw1-1.fna.fbcdn.net/vp/e9f9a1d90bce4f1bd22605ab4f3481d2/5B5447F8/t50.2886-16/11719633_859007807516632_674404249_n.mp4)

A processing program for BlinkyTapes to visualize any sound input based on sound energy, 
rather than frequency energy. 

There are currently 14 animations that are made to display colors in different ways 
based on how the Fast Fourier Transform of the audio is read.

Using sound energy compared to frequency energy doesn't allow for very accurate beat 
detection, but still offers very aesthetically pleasing visualizations. To use sound 
energy, an actual audio file must be read by the program. Using the sound energy 
allows for the user to simply run any music or audio through the audio input of 
a computer.

Keyboard Controls
-----------------
- '1' - Next animation
- '2' - Previous animation
- '3' - Back to animation 1
- 'f' - Toggle smoother color values
- 'r' - Random animation on every beat detection or a defined length of time
- 's' - Start/Stop all animations, including animation window, and turn lights to white

Requirements
------------

- Minim Processing Library - http://code.compartmental.net/tools/minim/
- Virtual Audio Cable - See below

Virtual Audio Cables (VAC)
--------------------

For your BlinkyLight to properly read the audio please look into the following software:

- VB-Audio Virtual Cable (Windows) - http://vb-audio.pagesperso-orange.fr/Cable/index.htm
- Soundflower (Mac) - http://code.google.com/p/soundflower/
- PulseAudio (GNU/Linux) - you can simply use 'pavucontrol' to graphically change the recording devices sources from your microphone (usually "Built-in Audio Analog Stereo", the basic analog stereo microphone input) to a monitor device ("Monitor of Built-in Audio Analog Stereo", in this case the built-in audio analog stereo is an output, which may not be obvious). If the monitor device doesn't exist, you can create it, see: https://wiki.archlinux.org/index.php/PulseAudio/Examples#ALSA_monitor_source

A good tutorial for setting up your VAC to output to your BlinkyTape is written here:
http://forums.blinkinlabs.com/index.php?p=/discussion/68/windows-soundflower-alternative-vb-audio-virtual-cable/p1

Folder contains
---------------

- BlinkyMusicShow.pde - Visualization process
- BlinkyTape.pde - BlinkyTape class file, written by BlinkinLabs
- SerialSelector - Class file for selecting a serial a BlinkyTape is connected to

License
-------
The MIT License (MIT)

Copyright (c) 2014 Cory Shaw

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
