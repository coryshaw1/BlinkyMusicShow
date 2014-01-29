// TODO: Make this threaded! We can't hit high framerates otherwise :-(

class BlinkyTape
{
  private String m_portName;  // TODO: How to request cu.* devices?
  private Serial m_outPort;

  private int m_numberOfLEDs;
  
  private PApplet _parent;
  
  private Boolean m_enableGammaCorrection;
  private float m_gammaValue;
  
  private byte[] m_data;
  private int m_dataIndex = 0;

  BlinkyTape(PApplet parent, String portName, int numberOfLEDs) {
    _parent = parent;
    m_data = new byte[numberOfLEDs * 3 + 1];
    m_portName = portName;
    m_numberOfLEDs = numberOfLEDs;
    
    m_enableGammaCorrection = true;
    m_gammaValue = 1.8;

    println("Connecting to BlinkyTape on: " + portName);
    try {
      m_outPort = new Serial(parent, portName, 115200);
      println(m_outPort.port);
    }
    catch (RuntimeException e) {
      println("LedOutput: Exception while making serial port: " + e);
    }
    
    for (int i=0; i < numberOfLEDs; i++) {
      m_data[i] = 0;
    } 
  }
  
   boolean isConnected() {
    return(m_outPort != null);
  }
  
  // Attempt to close the serial port gracefully, so we don't leave it hanging
  void close() {
    if(isConnected()) {
      try {
        m_outPort.stop();
      }
      catch (Exception e) {
        println("LedOutput: Exception while closing: " + e);
      }
    }
    
    m_outPort = null;
  }
  
  String getPortName() {
    return m_portName;
  }

  void resetTape() {
    m_outPort.stop();
    Serial s = new Serial(_parent, m_portName, 1200);  // Magic reset baudrate
    delay(100);
    s.stop();
  }
  
  void render(float x1, float y1, float x2, float y2) {
    render(get(), x1, y1, x2, y2);
  }
  
  // Update the blinkyboard with new colors
  void render(PImage image, float x1, float y1, float x2, float y2) {
    m_outPort.clear();
    
    image.loadPixels();
    
    // Note: this should be sized appropriately
    byte[] data = new byte[m_numberOfLEDs*3 + 1];
    int dataIndex = 0;

    // data is R,G,B
    for(int i = 0; i < m_numberOfLEDs; i++) {
      // Sample a point along the line
      int x = (int)((x2 - x1)/m_numberOfLEDs*i + x1);
      int y = (int)((y2 - y1)/m_numberOfLEDs*i + y1);
      
      int r = int(red(image.pixels[y*image.width+x]));
      int g = int(green(image.pixels[y*image.width+x]));
      int b = int(blue(image.pixels[y*image.width+x]));
      
      if (m_enableGammaCorrection) {
        r = (int)(Math.pow(r/256.0,m_gammaValue)*256);
        g = (int)(Math.pow(g/256.0,m_gammaValue)*256);
        b = (int)(Math.pow(b/256.0,m_gammaValue)*256);
      }

      data[dataIndex++] = (byte)min(254, r);
      data[dataIndex++] = (byte)min(254, g);
      data[dataIndex++] = (byte)min(254, b);
    }
    
    // Add a 0xFF at the end, to signal the tape to display
    data[dataIndex] = (byte)255;
    
    m_dataIndex = dataIndex;
    m_data = data;
  }
  
  void send() {
    startSend();
    while(sendNextChunk()) {
      delay(1);
    };
  }
  
  int m_currentChunkPos;
  
  void startSend() {
    m_currentChunkPos = 0;
  }
  
  // returns false if done
  boolean sendNextChunk() {
    // Don't send data too fast, the arduino can't handle it.
    int maxChunkSize = 63;
    
    if( m_currentChunkPos >= m_numberOfLEDs*3 + 1) {
      return false;
    }
    
    int currentChunkSize = min(maxChunkSize, m_numberOfLEDs*3 + 1 - m_currentChunkPos);
    byte[] test = new byte[currentChunkSize];
    
    for(int i = 0; i < currentChunkSize; i++) {
        test[i] = m_data[m_currentChunkPos + i];
    }
  
    m_outPort.write(test);
    
    m_currentChunkPos += maxChunkSize;
    return true;
  }
  
  // Some very simple routines for sending single pixels.
  void pushPixel(color c) {
    m_data[m_dataIndex++] = (byte)min(254, red(c));
    m_data[m_dataIndex++] = (byte)min(254, green(c));
    m_data[m_dataIndex++] = (byte)min(254, blue(c));
  }
  
  int getindex() {
    return m_dataIndex;
  }
  void setIndex(int i) {
    m_dataIndex = i;
  }
  
  // finalize - for use with pushPixel
  void update() {
    if( m_data[m_dataIndex] != (byte)255) {
      m_data[m_dataIndex++] = (byte)255;
    }
    send();
    m_dataIndex = 0;
  }
}

