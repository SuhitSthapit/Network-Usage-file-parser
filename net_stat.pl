#!/usr/bin/perl 
#Written by Suhit Sthapit
#UTS Student ID: 12673341

$error_message1 = "**********Require only 2 or 3 arguments!**********\n";
$error_message2 = "The program net_stat.pl must be invoked as follows:\n".
	"net_stat.pl -option (filename)\n\n";
$error_message3 =   "The available options are:\n".
	"(1)n:\n    This option displays all the interfaces present in network usage file\n".
	"(2)r:\n    This option displays total number of units received for all interfaces\n".	
	"(3)t:\n    This option displays total number of units transmitted for all interfaces\n".
	"(4)i:\n    This option takes 3 arguments and displays following information for a given interface:\n".
	"    (a)total number of units received for that interface\n".
	"    (b)percentage of correctly received units received for that interface\n".
	"    (c)total number of units transmitted for that interface\n".
	"    (d)percentage of correctly transmitted units received for that interface\n".
	"(5)v:\n    This option takes 2 arguments and displays information of developer of this program.\n";
$error_message_for_i = "The program net_stat.pl must be invoked as follows:\n".
	"net_stat.pl -i (interface_name) (filename)\n\n";

if (@ARGV < 2 or @ARGV > 3)   ###check if there are appropriate no of arguments
{
	die $error_message1 . $error_message2 . $error_message3; #exit with error message
}

#array to hold all the options 
@option = ("n", "r", "t", "i", "v");
$temp = "false";  #To check if the user entered option is correct or not
$result = "false";  ### To check if given multi options are valid or not

if ($ARGV[0] =~ m/^-(\w)$/)  ## case for one option only
{
	foreach $opt (@option){
		if ($opt eq $1) 
		{
			$user_option = $1;
			$temp = "true";
		}	
	}
	if ($temp ne "true"){
		die "The entered option -$1 is incorrect!\n". "You can only enter one of following option:\n".
		    $error_message3 . "\n" . $error_message2;	
	}
}

elsif ($ARGV[0] =~ m/^-(\w{2,5})$/)  ##case for many options 
{
	foreach $values (split //, $1){
		foreach $availableOpt (@option){
			if ($values eq $availableOpt){
				$result = "true"; 
				last;
			}
			else{
			$result ="false"; }
		}
		if ($result eq "false") { last;}
	}
	if ($result eq "true"){	
		die "The entered options -$1 are valid but you can only enter one option at a time!\n" . $error_message3 . "\n" . $error_message2;
	}
	else{
		die "The entered options -$1 are not valid. Enter only one option at a time.\n\n" . $error_message2. $error_message3;		
	}
}

else  ##case for unavailable options 
{
	die "The option you entered is not valid at all!\n\n" . $error_message2 . $error_message3;  #exit with err_msg
}

#### if there are 2 or 3 arguments
$filename = "net_usage_file";
if (@ARGV == 2){
	if ($user_option eq "i"){
		die "The entered option $user_option only takes 3 arguments\n".
		$error_message_for_i;
	}
	$filename = $ARGV[1];
}
elsif (@ARGV == 3){
	$interface_name = $ARGV[1];
	if ($user_option eq "i"){
		$filename = $ARGV[2]; 
	}
}

#Open the given file in the argument
if ( @ARGV>1)
{
	(-e $filename) or die "The file doesn't exist!\n". 
		 "Make sure your file exist or not. And, also make sure that" .
		 " you entered the correct filename in the argument!\n".
            	 "The filename is: net_usage_file\n". $error_message2;	 #to check existence of file
        (-r $filename) or die "The given file cannot be read.\nPlease change the permission of ".
		"file as 'Readable', so that the file can be parsed!\n".
		 $error_message2; ##to check readable file
	if (!open(INFILE, $filename))
	{
		die "Failed to open the file!\n". 
		    "Make sure you entered the correct filename in the argument!\n".
            	    "The filename is: net_usage_file\n".
		    $error_message2; ### to check the file can be opened or not
	}	
}

#### if there is two arguments and option is -v
if (@ARGV == 2){
	if ($user_option eq "v"){
		print "Name: Suhit\nSurname: Sthapit\nStudent ID: 12673341\n".
		      "Date of Completion: June 05, 2017\n";	
		exit;
	} 
}
elsif (@ARGV == 3){
	if ($user_option eq "v"){
		die "The entered option -$user_option only takes 2 arguments!\n".          			$error_message2;	
	}
}


#### if there are 2 or 3 arguments

$counter = 0; #to count lines in file
$total_units_received = 0;
$total_units_transmitted = 0;


$correct_interface_name = "true";

while ($line = <INFILE>)
{	
	if ($counter == 0){
	$counter++;
	next;	
	}
	$counter++;
	chomp ($line);
	@word = split (/\s+/,$line);
	
	if ($user_option eq "n"){
		push @interfaces, $word[0];
	}
	elsif ($user_option eq "r"){
		$total_units_received += $word[1] + $word[2] + $word[3];
	}
	elsif ($user_option eq "t"){
		$total_units_transmitted += $word[4] + $word[5] + $word[6];
	}
	elsif ($user_option eq "i"){
 		if($word[0] eq $interface_name){
			$total_units_received = $word[1] + $word[2] + $word[3];
			$total_units_transmitted = $word[4] + $word[5] + $word[6];
			$perc_correct_rec = $word[1] * 100 / ($word[1] + $word[2] + $word[3]);
			$perc_correct_trans = $word[4] * 100 / ($word[4] + $word[5] + $word[6]);
			print "Interface $word[0]:\n".
			      "Total number of units received: $total_units_received\n". 			        			sprintf ('Percentage of correctly received units: %.3f',$perc_correct_rec).
	   	              "%\nTotal number of units transmitted: $total_units_transmitted\n".
		        sprintf ("Percentage of correctly transmitted units: %.3f",$perc_correct_trans).
                        "%\n";
			if ($perc_correct_rec < 99.000 or $perc_correct_trans < 99.000){
				print "Attention: significant errors over this interface\n";	
			}
			exit;     	 
		}
		else{
		$correct_interface_name = "false";
		}		
	}
}

if ($counter == 1 and @ARGV == 2)  #When there is only one line in the file
{
	if ($user_option eq "n"){
		print "No Interfaces present\n";
	}
	elsif ($user_option eq "r"){
		print "Total number of units received: $total_units_received\n";
	}
	elsif ($user_option eq "t"){
		print "Total number of units transmitted: $total_units_received\n";
	}		
}
elsif ($counter != 1 and @ARGV == 2) #When there are many lines in the file
{	
	if ($user_option eq "n"){
		print "Interfaces:\n";
		foreach $value (@interfaces){		
		print "$value\n";		
		}
	}
	elsif ($user_option eq "r"){
		print "Total number of units received: $total_units_received\n";
	}
	elsif ($user_option eq "t"){
		print "Total number of units transmitted: $total_units_transmitted\n";
	}
}
elsif ($counter == 1 and $correct_interface_name eq "true"){
	print "Interface $interface_name not found\n";
}
elsif ($correct_interface_name eq "false"){
	print "Interface $interface_name not found\n";
}
else{
	die "The entered option -$user_option only takes 2 arguments!\n\n".
	$error_message2;
}

close (INFILE);
##end 

###Written by:
#### Suhit Sthapit
### UTS Student no: 12673341
