/**
 * Read Contacts
 * by Aaron Zarraga - Sensel, Inc
 * 
 * This opens a Sensel sensor, reads contact data, and prints the data to the console.
 */

boolean sensel_sensor_opened = false;
SenselDevice sensel;

void setup() 
{
  DisposeHandler dh = new DisposeHandler(this);
  sensel = new SenselDevice(this);
  
  sensel_sensor_opened = sensel.openConnection();
  
  if(!sensel_sensor_opened)
  {
    println("Unable to open Sensel sensor!");
    exit();
    return; 
  }
  
  //Enable contact sending
  sensel.setFrameContentControl(SenselDevice.SENSEL_FRAME_CONTACTS_FLAG);
  
  //Enable scanning
  sensel.startScanning();
}

void draw() 
{
  if(!sensel_sensor_opened)
    return;
 
  SenselContact[] c = sensel.readContacts();
  
  if(c == null)
  {
    println("NULL CONTACTS");
    return;
  }
   
  for(int i = 0; i < c.length; i++)
  {
    int force = c[i].total_force;
    float sensor_x_mm = c[i].x_pos_mm;
    float sensor_y_mm = c[i].y_pos_mm;
    
    int id = c[i].id;
    int event_type = c[i].type;
    
    String event;
    switch (event_type)
    {
      case SenselDevice.SENSEL_EVENT_CONTACT_INVALID:
        event = "invalid"; 
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_START:
        event = "start";   
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_MOVE:
        event = "move";
        break;
      case SenselDevice.SENSEL_EVENT_CONTACT_END:
        event = "end";
        break;
      default:
        event = "error";
    }
    
    println("Contact ID " + id + ", event=" + event + ", mm coord: (" + sensor_x_mm + ", " + sensor_y_mm + "), force=" + force); 
  }
  
  if(false) // Set to true to see accelerometer data
  {
    float[] acc_data = sensel.readAccelerometerData();
    println("Acc Data: (" + acc_data[0] + ", " + acc_data[1] + ", " + acc_data[2] + ")");
  }
  
  if(c.length > 0)
    println("****");
}

public class DisposeHandler 
{   
  DisposeHandler(PApplet pa)
  {
    pa.registerMethod("dispose", this);
  }  
  public void dispose()
  {      
    println("Closing sketch");
    if(sensel_sensor_opened)
    {
      sensel.stopScanning();
      sensel.closeConnection();
    }
  }
}
