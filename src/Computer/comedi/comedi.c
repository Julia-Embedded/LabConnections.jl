/* This is a bridge between Julia and Comedi, written by Martin Karlsson
 * and Jacob Mejvik at Dept. Automatic Control, Lund University.*/

#include <stdio.h>      /* for printf() */
#include <comedilib.h>


int range = 0;
int aref = AREF_GROUND;
comedi_t *device;
comedi_range * range_info;
lsampl_t maxdata;

// Send physical value from computer to process:
int comedi_write(int comediNbr, int subdev, int chan, double physical_value) {
	static int comedi_value;
	static int retval;
	// Convert physical value to comedi value:
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	comedi_value = comedi_from_phys(physical_value, range_info, maxdata);
	// Send the converted value to device:
	retval = comedi_data_write(device, subdev, chan, range, aref, comedi_value);
    return retval;
}

// Get physical value from process to computer:
double comedi_read(int comediNbr, int subdev, int chan) {
	static double physical_value;
	lsampl_t comedi_value;
	// Get comedi value:
	comedi_data_read(device, subdev, chan, range, aref, &comedi_value);
	// Convert comedi value to physical value:
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	physical_value = comedi_to_phys(comedi_value, range_info, maxdata);
	// Return the converted value:
	return physical_value;
}

// comedi_path example: "/dev/comedi0"
int comedi_start(char* comedi_name) {
    // Check for connection:
	device = comedi_open(comedi_name);
		if(device == NULL)
	{
		comedi_perror("comedi_open_error");
		return -1;
	}
	// Set out-of-range behavior. This affects the behavior of comedi_to_phys 
	// when converting endpoint sample values, that is, sample values equal to 
	// 0 or maxdata. With COMEDI_OOR_NUMBER, the endpoint values
	// are converted similarly to other values.
	comedi_set_global_oor_behavior(COMEDI_OOR_NUMBER);
	return 0;
}

// Send physical value zero from computer to process. This might, for instance,
// be useful prior to closing the connection with the process.
void comedi_write_zero(int comediNbr, int subdev, int chan) {
	static double physical_value_zero = 0.0; // Physical value zero to send.
	static lsampl_t comedi_value;
	// Convert physical value zero to comedi value:
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	comedi_value = comedi_from_phys(physical_value_zero, range_info, maxdata);
	// Send converted value to process.
	comedi_data_write(device, subdev, chan, range, aref, comedi_value);
}

// Shut down communication between computer and process.
void comedi_stop(int comediNbr) {
	comedi_close(device);
}
