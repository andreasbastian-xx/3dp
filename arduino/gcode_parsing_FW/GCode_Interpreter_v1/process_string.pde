// our point structure to make things nice.
struct LongPoint {
  long x;
  long y;
  long z;
};

struct FloatPoint {
  float x;
  float y;
  float z;
};

FloatPoint current_units;
FloatPoint target_units;
FloatPoint delta_units;

FloatPoint current_steps;
FloatPoint target_steps;
FloatPoint delta_steps;

//absolute mode
boolean abs_mode = false;   //0 = incremental; 1 = absolute

//default to inches for units
float x_units = X_STEPS_PER_INCH;
float y_units = Y_STEPS_PER_INCH;
float z_units = Z_STEPS_PER_INCH;
float curve_section = CURVE_SECTION_INCHES;
float zp = 0;//previous z val--for keeping track of layers

//our direction vars
byte x_direction = 1;
byte y_direction = 1;
byte z_direction = 1;

//init our string processing
void init_process_string()
{
  //init our command
  for (byte i=0; i<COMMAND_SIZE; i++)
    Word[i] = 0;
  serial_count = 0;
}

//our feedrate variables.
float feedrate = 0.0;
long feedrate_micros = 0;

//Read the string and execute instructions
void process_string(char instruction[], int Size)
{
  //the character / means delete block... used for comments and stuff.
  if (instruction[0] == '/')
  {
    Serial.println("ok");
    return; 
  }

  //init baby!
  FloatPoint fp;
  fp.x = 0.0;
  fp.y = 0.0;
  fp.z = 0.0;

  byte code = 0;


  //what line are we at?
  //	long line = -1;
  //	if (has_command('N', instruction, Size))
  //		line = (long)search_string('N', instruction, Size);

  /*
	Serial.print("line: ");
   	Serial.println(line);
   	Serial.println(instruction);
   */
  //did we get a gcode?
  if (
  has_command('G', instruction, Size) ||
    has_command('X', instruction, Size) ||
    has_command('Y', instruction, Size) ||
    has_command('Z', instruction, Size)
    )
  {
    //which one?
    code = (int)search_string('G', instruction, Size);

    // Get co-ordinates if required by the code type given
    switch (code)
    {

    case 0:

    case 1:

    case 2:

    case 3:

      if(abs_mode)//use relative positioning
      {
        //we do it like this to save time. makes curves better.
        //eg. if only x and y are specified, we dont have to waste time looking up z.
        if (has_command('X', instruction, Size))
          fp.x = search_string('X', instruction, Size);
        else
          fp.x = current_units.x;

        if (has_command('Y', instruction, Size))
          fp.y = search_string('Y', instruction, Size);
        else
          fp.y = current_units.y;

        if (has_command('Z', instruction, Size))
          fp.z = search_string('Z', instruction, Size);
        else
          fp.z = current_units.z;

        if(zp != fp.z)
        {
          //Serial.print("Zdiff = ");
          //Serial.println(fabs(fp.z-zp),DEC);
          //doZ(fabs(fp.z-zp));
          //doZ(0.01);
        }
        zp = fp.z;

      }
      else//use absolute positioning:
      {
        fp.x = search_string('X', instruction, Size) + current_units.x;
        fp.y = search_string('Y', instruction, Size) + current_units.y;
        fp.z = search_string('Z', instruction, Size) + current_units.z;

      }
      break;
    }

    //do something!
    switch (code)
    {
      //Rapid Positioning
      //Linear Interpolation
      //these are basically the same thing.
      //////////////////////////////////////////////////////////////////////////
    case 0:

      //////////////////////////////////////////////////////////////////////////
    case 1:
      //set our target.
      set_target(fp.x, fp.y, fp.z);

      //do we have a set speed?
      if (has_command('G', instruction, Size))
      {
        //adjust if we have a specific feedrate.
        if (code == 1)
        {
          //how fast do we move?
          feedrate = search_string('F', instruction, Size);
          if (feedrate > 0)
            feedrate_micros = calculate_feedrate_delay(feedrate);
          //nope, no feedrate
          else
            feedrate_micros = getMaxSpeed();
        }
        //use our max for normal moves.
        else
          feedrate_micros = getMaxSpeed();
      }
      //nope, just coordinates!
      else
      {
        //do we have a feedrate yet?
        if (feedrate > 0)
          feedrate_micros = calculate_feedrate_delay(feedrate);
        //nope, no feedrate
        else
          feedrate_micros = getMaxSpeed();
      }

      //finally move.
      dda_move(feedrate_micros);
      break;

      //Clockwise arc
      //////////////////////////////////////////////////////////////////////////
    case 2:
      //Counterclockwise arc
      //////////////////////////////////////////////////////////////////////////
    case 3:

      FloatPoint cent;

      // Centre coordinates are always relative
      cent.x = search_string('I', instruction, Size) + current_units.x;
      cent.y = search_string('J', instruction, Size) + current_units.y;
      float angleA, angleB, angle, radius, length, aX, aY, bX, bY;

      aX = (current_units.x - cent.x);
      aY = (current_units.y - cent.y);
      bX = (fp.x - cent.x);
      bY = (fp.y - cent.y);

      if (code == 2) { // Clockwise
        angleA = atan2(bY, bX);
        angleB = atan2(aY, aX);
      } 
      else { // Counterclockwise
        angleA = atan2(aY, aX);
        angleB = atan2(bY, bX);
      }

      // Make sure angleB is always greater than angleA
      // and if not add 2PI so that it is (this also takes
      // care of the special case of angleA == angleB,
      // ie we want a complete circle)
      if (angleB <= angleA) angleB += 2 * M_PI;
      angle = angleB - angleA;

      radius = sqrt(aX * aX + aY * aY);
      length = radius * angle;
      int steps, s, step;
      steps = (int) ceil(length / curve_section);

      FloatPoint newPoint;
      for (s = 1; s <= steps; s++) {
        step = (code == 3) ? s : steps - s; // Work backwards for CW
        newPoint.x = cent.x + radius * cos(angleA + angle * ((float) step / steps));
        newPoint.y = cent.y + radius * sin(angleA + angle * ((float) step / steps));
        set_target(newPoint.x, newPoint.y, fp.z);

        // Need to calculate rate for each section of curve
        if (feedrate > 0)
          feedrate_micros = calculate_feedrate_delay(feedrate);
        else
          feedrate_micros = getMaxSpeed();

        // Make step
        dda_move(feedrate_micros);
      }

      break;

      //Dwell
      //////////////////////////////////////////////////////////////////////////
    case 4:

      delay((int)search_string('P', instruction, Size));
      break;

      //Inches for Units
      //////////////////////////////////////////////////////////////////////////
    case 20:

      x_units = X_STEPS_PER_INCH;
      y_units = Y_STEPS_PER_INCH;
      z_units = Z_STEPS_PER_INCH;
      curve_section = CURVE_SECTION_INCHES;

      calculate_deltas();
      break;

      //mm for Units
      //////////////////////////////////////////////////////////////////////////
    case 21:

      x_units = X_STEPS_PER_MM;
      y_units = Y_STEPS_PER_MM;
      z_units = Z_STEPS_PER_MM;
      curve_section = CURVE_SECTION_MM;

      calculate_deltas();
      break;

      //go home.
      //////////////////////////////////////////////////////////////////////////
    case 28:
      set_target(0.0, 0.0, 0.0);
      dda_move(getMaxSpeed());
      break;

      //go home via an intermediate point.
      //////////////////////////////////////////////////////////////////////////
    case 30:
      fp.x = search_string('X', instruction, Size);
      fp.y = search_string('Y', instruction, Size);
      fp.z = search_string('Z', instruction, Size);

      //set our target.
      if(abs_mode)
      {
        if (!has_command('X', instruction, Size))
          fp.x = current_units.x;
        if (!has_command('Y', instruction, Size))
          fp.y = current_units.y;
        if (!has_command('Z', instruction, Size))
          fp.z = current_units.z;

        set_target(fp.x, fp.y, fp.z);
      }
      else
        set_target(current_units.x + fp.x, current_units.y + fp.y, current_units.z + fp.z);

      //go there.
      dda_move(getMaxSpeed());

      //go home.
      set_target(0.0, 0.0, 0.0);
      dda_move(getMaxSpeed());
      break;

      //Absolute Positioning
      //////////////////////////////////////////////////////////////////////////
    case 90:
      abs_mode = true;
      break;

      //Incremental Positioning
      //////////////////////////////////////////////////////////////////////////
    case 91:
      abs_mode = false;
      break;

      //Set as home
      //////////////////////////////////////////////////////////////////////////
    case 92:
      set_position(0.0, 0.0, 0.0);
      break;

      /*
			//Inverse Time Feed Mode
       			case 93:
       
       			break;  //TODO: add this
       
       			//Feed per Minute Mode
       			case 94:
       
       			break;  //TODO: add this
       */

    default:
      Serial.print("huh? G");
      Serial.println(code,DEC);
    }
  }

  //find us an m code.
  //MCODES ARE USED FOR TOOLHEAD CONTROL
  
  //they don't seem to be executing now...
  //////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////
  if (has_command('M', instruction, Size))
  {

    code = search_string('M', instruction, Size);
    Serial.print("Got M ");
    Serial.println(code, DEC);
    switch (code)
    {
      //TODO: this is a bug because search_string returns 0.  gotta fix that.

      //turn extruder on, forward
    case 101:
      Serial.print("Got M");
      Serial.println(code,DEC);
      laserOn();
      //extruder_set_direction(1);
      //extruder_set_speed(extruder_speed);
      break;

      //turn extruder on, reverse
    case 102:
      laserOff();
      Serial.println("Laser Off 102");
      //extruder_set_direction(0);
      //extruder_set_speed(extruder_speed);
      break;

      //turn extruder off
    case 103:
      Serial.print("Got M");
      Serial.println(code,DEC);
      laserOff();
      //extruder_set_speed(0);
      break;

    default:
      Serial.print("Unhandled M");
      Serial.println(code,DEC);
    }		
  }

  //tell our host we're done.
  Serial.println("ok");
  //	Serial.println(line, DEC);
}

//look for the number that appears after the char key and return it
double search_string(char key, char instruction[], int string_Size)
{
  char temp[10] = "";

  for (byte i=0; i<string_Size; i++)
  {
    if (instruction[i] == key)
    {
      i++;      
      int k = 0;
      while (i < string_Size && k < 10)
      {
        if (instruction[i] == 0 || instruction[i] == ' ')
          break;

        temp[k] = instruction[i];
        i++;
        k++;
      }
      return strtod(temp, NULL);
    }
  }

  return 0;
}

//look for the command if it exists.
bool has_command(char key, char instruction[], int string_Size)
{
  for (byte i=0; i<string_Size; i++)
  {
    if (instruction[i] == key)
      return true;
  }

  return false;
}









