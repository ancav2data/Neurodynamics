#include <linux/module.h>    // header files for RTAI calculation
#include <asm/io.h>	     // and user space - kernel space communication
#include <math.h>
#include <rtai.h>
#include <rtai_sched.h>
#include <rtai_fifos.h>
#include <linux/comedi.h>    // header files for data acquistion with the
#include <linux/comedilib.h> // complete interface of Comedi

#define TICK_PERIOD 50000    // tickrate: 50000 ns = 0.050 ms -> 20 kHz
#define TASK_PRIORITY 1	     // priority to be given to the task, highest priority is 0
#define STACK_SIZE 10000     // size of the stack to e used by the new task
#define FIFO 0		     // first in first out data structure
#define FIFO1 1		     // for communication with user space
#define FIFO2 2
#define FIFO3 3
#define FIFO4 4
#define FIFO4 5
#define FIFO4 6
#define FACTOR 10/65536	     // factor for the voltage output
#define TIMESTEP 0.05	     // Euler step	

static RT_TASK task;	     // real-time task
int subdevice = 0;           // input subdevice
int chan = 0;                // channel
int range = 1;               // input range
int range1 = 2;              // output range
int aref = AREF_DIFF;        // reference of the device; differential inputs/outputs
comedi_t *device;	     // represent an open Comedi device
lsampl_t datab;	             // represent data values in libcomedi
int pdatab;		     // data buffer for writing

// Model of a basket cell
float mv;	  	     // membrane voltage in mV
	 
float Iapp;	 	     // stimulus in uA/cm^2
float INa;	  	     // Na+ current
float IK;	 	     // K+ current
float IL;	 	     // leak current
float Iion;	 	     // ionic current

float VNa = 55;  	     // reversal potential of the Na+ current in mV
float VK = -90;   	     // reversal potential of the K+ current in mV
float VL = -65;   	     // reversal potential of the leak current in mV

float gNa = 35;	  	     // conductance of the Na+ current in mS/cm^2
float gK = 9;	  	     // conductance of the K+ current in mS/cm^2
float gL = 0.1;	  	     // conductance of the leak current in mS/cm^2

float k = 5; 	     // smaller k -> IK is slower -> AHP amplitude more negative
float Cmem = 1;	  	     // membrane capacitance density in uF/cm^2

float h;	  	     // inactivation varible h
float n;	  	     // activation varible n
float minf;
float alpham;
float alphah;
float alphan;
float betam;
float betah;
float betan;

float time;		     // time stamp

// Program
static void fun(int t)
{
	while (1) {
		rtf_get(FIFO1, &Iapp, sizeof(Iapp));
		// get the stimulus value from the userspace
		comedi_data_read(device,subdevice,chan,range,aref,&datab);
		// read single sample from channel
		// Comedi device, subdevice, channel, range, analog reference type, data
		mv=100*((float)datab*FACTOR-5);
		// converting voltages to samples	

		alpham = -0.1*(mv+35)/(exp(-0.1*(mv+35))-1); 	           // alpha m
		alphah = 0.07*exp(-(mv+58)/20);              	           // alpha h
		alphan = -0.01*(mv+34)/(exp(-0.1*(mv+34))-1); 	           // alpha n
	
		betam = 4*exp(-(mv+60)/18);			           // beta m              
      betah = 1/(exp(-0.1*(mv+28))+1);		           // beta h
		betan = 0.125*exp(-(mv+44)/80);			           // beta n

		minf = alpham/( alpham + betam );		           // minf
		h = h + TIMESTEP* k*(alphah*(1-h) - betah*h);            // dh/dt
		n = n + TIMESTEP* k*(alphan*(1-n) - betan*n);	           // dn/dt

		INa = gNa*minf*minf*minf*h*(mv-VNa);		           // Na+ current
		IK = gK*n*n*n*n*(mv-VK);         		           // K+ current
		IL = gL*(mv-VL);				        // leakage current

		Iion = INa + IK + IL;				           // ionic current
			
		pdatab=3.2768*iion+32768; 			 	   // converting samples to voltages
		comedi_data_write(device,1,chan,range1,aref,pdatab);  	   // write single sample to channel
		// device, subdevice, channel, range, analog reference type, data

		rtf_put(FIFO, &mv, sizeof(mv));
		// put the membrane voltage of the basket cell to the userspace
		time = rt_get_cpu_time_ns(); 			 	   // get the current time
		rtf_put(FIFO2, &time, sizeof(time)); 		 	   // put the time stamp to the userspace
		rtf_put(FIFO3, &ina, sizeof(ina));
		rtf_put(FIFO4, &ik, sizeof(ik));
		rtf_put(FIFO5, &il, sizeof(il));
		rtf_put(FIFO6, &iion, sizeof(iion));
		rt_task_wait_period();				 	   // wait until next period
	}
}

int init_module(void)
{
	RTIME tick_period;						   // period timer
	rt_set_periodic_mode(); 					   // set timer mode
	rt_task_init(&task, fun, 1, STACK_SIZE, TASK_PRIORITY, 1, 0);      // create a periodic task
	// task, task function, pass single integer value data, stack size, task priority, flag, signal
	rtf_create(FIFO, 8000);						   // create a real-time FIFO in kernel space
	rtf_create(FIFO1, 8000);
	rtf_create(FIFO2, 20000);
	rtf_create(FIFO3, 8000);
	rtf_create(FIFO4, 8000);
	rtf_create(FIFO5, 8000);
	rtf_create(FIFO6, 8000);
	
	// start timer and periodic task
	tick_period = start_rt_timer(nano2count(TICK_PERIOD)); 
	// convert nanoseconds to internal count units and start timer
	rt_task_make_periodic(&task, rt_get_time() + tick_period, tick_period);
	// task gets suitable for periodic execution; task, start time (get the current time), period
	mv = -64;							   // membrane voltage at the beginning in mV
	h = 0;								   // inactivation varible h
	n = 0;								   // activation varible n
	device=comedi_open("/dev/comedi0"); 				   // open a Comedi device
	comedi_data_read_hint(device,subdevice,chan,range,aref);	   // tell driver which channel is the next
	// device, subdevice, channel, range, analog reference type
	return 0;
}

void cleanup_module(void)
{
	comedi_data_write(device,1,chan,0,aref,32768);
	comedi_close(device);   					   // close a Comedi device
	stop_rt_timer();       						   // stop timer
	rtf_destroy(FIFO);     						   // close a real-time FIFO in kernel space
	rtf_destroy(FIFO1);
	rtf_destroy(FIFO2);
	rtf_destroy(FIFO3);
	rtf_destroy(FIFO4);
	rtf_destroy(FIFO5);
	rtf_destroy(FIFO6);
	rt_task_delete(&task);  					   // delete a real-time task
	return;
}
