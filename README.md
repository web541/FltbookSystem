# Fltbook-System
A redesigned phpVMS Module modified to allow pilots to select their own aircraft prior to booking a flight.

NOTE: Deprecated Repository, see updated version => https://github.com/web541/phpVMS-FltbookSystem-v2
--------------------
NOTICE: Majority of the code has originated from it's owners on the phpvms forums and has been compiled by Web541

    FrontSchedules - Simpilot
    RealScheduleLite - Simpilot
    FlightBookingSystem - Parkho
    
    
I Do not own any code from the above and all code provided by them belongs to their respective owners.

----------------------
Simple Instructions
----------------------

To work the airlines, please go into all your aircraft and select an airline from the dropdown then click save.
For all schedules that need to be imported, add a fake aircraft with the registration of the following format AIRCRAFTICAOAIRLINE
So for all schedules with American Airlines B738, you would make a dummy aircraft called B738AAL and then when importing schedules from your CSV, put B738AAL for your aircraft column.

----------------------
 Installation
----------------------

Backup all necessary files. I take no responsibility for you losing your files.

Place all the files in their respective directory.
Upload the fltbook.sql file to your sql database via phpmyadmin or similar

---------------------

Place this in your local.config.php file located in your core/ directory

  	Config::Set('JUMPSEAT_COST', '.25');
   
Change 25 to your Jumpseat Cost per nautical mile (nm)

2.
  Go to action.php (in phpVMS Root Directory) and find this line:
    
    error_reporting(E_ALL ^ E_NOTICE);
    
  and replace it with this line (temp fix to avoid strict standards):

    ini_set('error_reporting', E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);

----------------------

If you would like to show each airline image on the results page, save an image in the directory of lib/images/airlinelogos/ICAO.png
The ICAO is the $airline->code. 
If you want to remove it, go into Fltbook/schedule_results and find these lines

	<th>Airline</th>
	<td width="16.5%" align="left" valign="middle"><img src="<?php echo SITE_URL?>/lib/images/airlinelogos/<?php echo $route->code;?>.png" alt="<?php echo $route->code;?>"></td>

And simply delete them

----------------------
