/* This is a bridge between Julia and Comedi, written by Martin Karlsson
 * and Jacob Mejvik at Dept. Automatic Control, Lund University.*/

#include <stdio.h>      /* for printf() */
#include <comedilib.h>


int range = 0;
int aref = AREF_GROUND;
comedi_t *device;
comedi_range * range_info;
lsampl_t maxdata;

int comedi_write(int comediNbr, int subdev, int chan, double physical_value) {
	static int comedi_value;
	static int retval;
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	comedi_value = comedi_from_phys(physical_value, range_info, maxdata);
	retval = comedi_data_write(device, subdev, chan, range, aref, comedi_value);
    return retval;
}

double comedi_read(int comediNbr, int subdev, int chan) {
	static double physical_value;
	lsampl_t comedi_value;
	comedi_data_read(device, subdev, chan, range, aref, &comedi_value);
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	physical_value = comedi_to_phys(comedi_value, range_info, maxdata);
	return physical_value;
}

// comedi_path example: "/dev/comedi0"
int comedi_start(char* comedi_name) {
	device = comedi_open(comedi_name);
		if(device == NULL)
	{
		comedi_perror("comedi_open_error");
		return -1;
	}
	comedi_set_global_oor_behavior(COMEDI_OOR_NUMBER);
	return 0;
}

void comedi_write_zero(int comediNbr, int subdev, int chan) {
	static double physical_value_zero = 0.0;
	static lsampl_t comedi_value;
	range_info = comedi_get_range(device, subdev, chan, range);
	maxdata = comedi_get_maxdata(device, subdev, chan);
	comedi_value = comedi_from_phys(physical_value_zero, range_info, maxdata);
	comedi_data_write(device, subdev, chan, range, aref, comedi_value);
}

void comedi_stop(int comediNbr) {
	comedi_close(device);
}
