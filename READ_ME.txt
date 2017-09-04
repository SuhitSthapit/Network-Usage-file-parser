This program is written by Suhit Sthapit. (UTS Id: 12673341)
There are three files attached in this zip file. They are:
1) net_stat.pl 
2) net_usage_file
3) READ_ME

net_stat.pl is the program.
net_usage_file is the sample file to be parsed.

The program net_stat.pl must be invoked as follows:
	net_stat.pl -option net_usage_file

The available options are:

(1)n:
   This option displays all the interfaces present in network usage file
(2)r:
   This option displays total number of units received for all interfaces
(3)t:
   This option displays total number of units transmitted for all interfaces
(4)i:
    This option takes 3 arguments and displays following information for a given interface:
	    (a)total number of units received for that interface.
	    (b)percentage of correctly received units received for that interface.
	    (c)total number of units transmitted for that interface.
	    (d)percentage of correctly transmitted units received for that interface.
(5)v:
    This option takes 2 arguments and displays information of developer of this program.