<?php
$pilotid = Auth::$userinfo->pilotid;
$last_location = FltbookData::getLocation($pilotid, 1);
$last_name = OperationsData::getAirportInfo($last_location->arricao);
?>
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">

<script src="http://code.jquery.com/jquery-latest.js"></script>

<script type="text/javascript" src="<?php echo fileurl('lib/js/jquery.dataTables.js');?>"></script>
<script type="text/javascript" src="<?php echo fileurl('lib/js/datatables.js');?>"></script>
<script type="text/javascript" src="<?php echo fileurl('lib/js/dataTables.bootstrap.min.js');?>"></script>
<script type="text/javascript" charset="utf-8">
	$(document).ready(function() {
	$('#tabledlist').dataTable( {
  "lengthMenu": [ [10, 25, 50, -1], [10, 25, 50, "All"] ]
} )});
</script>

<!-- Latest compiled and minified JavaScript - Modified to clear modal on data-dismiss -->
<script type="text/javascript" src="<?php echo SITE_URL;?>/lib/js/bootstrap.js"></script>

<br />		
<table id="tabledlist" class="table table-striped table-bordered table-hover">
<?php
if(!$allroutes)
{
?>
	<tr><td align="center">No flights from <?php echo $last_location->arricao.' ( '.$last_name->name.')' ;?>!</td></tr>
	
<?php
}
else
{
?>
<thead>
<tr id="tablehead">
            	<th>Airline</th>
                <th>Flight Number</th>
                <th>Origin</th>
                <th>Destination</th>
                <th>Aircraft</th>
                <th>Options</th>
</tr>
</thead>
<tbody>
<?php
foreach($allroutes as $route)
{
	if(Config::Get('RESTRICT_AIRCRAFT_RANKS') === true && Auth::LoggedIn())
	{
		if($route->aircraftlevel > Auth::$userinfo->ranklevel)
		{
			continue;
		}
	}
?>
<tr style="height:12px; font-size:14px; font-weight:normal;">
	<td width="16.5%" align="left" valign="middle"><img src="<?php echo SITE_URL?>/lib/images/airlinelogos/<?php echo $route->code;?>.png" alt="<?php echo $route->code;?>"></td>
	<td width="16.5%" align="center" valign="middle"><?php echo $route->code . $route->flightnum?></td>
	<td width="16.5%" align="center" valign="middle"><?php echo $route->depicao ;?></td>
	<td width="16.5%" align="center" valign="middle"><?php echo $route->arricao ;?></td>
	<td width="16.5%" align="left" valign="middle"><?php echo $route->aircraft ;?> 
        <div class="vertical-align-text pull-right" style="padding-left:6px;">
            <div class="font-small pull-right"><?php echo $route->flighttime; ?>h</div>
            <div class="font-small"><?php echo round($route->distance,0,PHP_ROUND_HALF_UP); ?>nm</div>
        </div>
    </td>
    <td width="16.5%" align="center" valign="middle">
    <input type="button" value="Details" class="btn btn-warning" onclick="$('#details_dialog_<?php echo $route->flightnum;?>').toggle()">
             
	   <?php 
        if(Config::Get('DISABLE_SCHED_ON_BID') == true && $route->bidid != 0)
	    {
        ?>
        <div class="btn btn-danger btn-sm sharp disabled">Booked</div>
        <?php
		}
        else
		{
		?>

    <a data-toggle="modal" href="<?php echo SITE_URL?>/action.php/Fltbook/confirm?id=<?php echo $route->id;?>&airline=<?php echo $route->code; ?>&aicao=<?php echo $route->aircrafticao;?>" data-target="#confirm" class="btn btn-success btn-md">Book</a>
        <?php                    
        }
        ?>
    </td>
</tr>

        <td colspan="6">
		
		<table cellspacing="0" cellpadding="0" border="1" id="details_dialog_<?php echo $route->flightnum;?>" style="display:none" width="100%">
		   
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Flight Brefing</font></th>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDeaprture:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php
			$name = OperationsData::getAirportInfo($route->depicao);
			echo "{$name->name}"?></b></td>
			<td align="left">&nbsp&nbspArrival:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php 
			$name = OperationsData::getAirportInfo($route->arricao);
			echo "{$name->name}"?></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspAircraft</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php 
			$plane = OperationsData::getAircraftByName($route->aircraft);
			echo $plane->fullname ; ?></b></td>
			<td align="left">&nbsp&nbspDistance:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->distance . Config::Get('UNITS') ;?></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDep Time:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<font color="red"><?php echo $route->deptime?> GMT</font></b></td>
			<td align="left">&nbsp&nbspArr Time:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<font color="red"><?php echo $route->arrtime?> GMT</font></b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspAltitude:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->flightlevel; ?> ft</b></td>
			<td align="left">&nbsp&nbspDuration:</td>
			<td colspan="0" align="left" ><font color="red"><b>&nbsp
			<?php 
			
			$dist = $route->distance;
			$speed = 440;
			$app = $speed / 60 ;
			$flttime = round($dist / $app,0)+ 20;
			$hours = intval($flttime / 60);
            $minutes = (($flttime / 60) - $hours) * 60;
			if($hours > "9" AND $minutes > "9")
			{
			echo $hours.':'.$minutes ;
			}
			else
			{
			echo '0'.$hours.':0'.$minutes ;
			}
			?> Hrs</b></font></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspDays</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo Util::GetDaysLong($route->daysofweek) ;?></b></td>
			<td align="left">&nbsp&nbspPrice:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp$<?php echo $route->price ;?>.00</b></td>
			</tr>
			<tr>
			<td align="left">&nbsp&nbspFlight Type:</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php
			if($route->flighttype == "P")
			{
			echo'Passenger' ;
			}
			if($route->flighttype == "C")
			{
			echo'Cargo' ;
			}
			if($route->flighttype == "H")
			{
			echo'Charter' ;
			}
			?></b></td>
			<td align="left">&nbsp&nbspFlown</td>
			<td colspan="0" align="left" ><b>&nbsp&nbsp<?php echo $route->timesflown ;?></b></td>
			</tr>
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Fuel Calculation for <?php 
			$plane = OperationsData::getAircraftByName($route->aircraft);
			echo $plane->fullname ; ?>
			</font></th>
			</tr>
			<?php
            $fuelflowB722 = 3800;
			$fuelhrB722 = 3000;
		    $fuelflowB738 = 1045;
            $fuelhrB738 = 3970;
			$fuelflowB744 = 1845;
			$fuelhrB744 = 7671;
			$fuelflowB763 = 1405;
			$fuelhrB763 = 4780;
            $fuelflowB772 = 2200;
			$fuelhrB772 = 6400;
			$fuelflowA30B = 1526;
			$fuelhrA30B = 8065;
		    $fuelflowA320 = 790;
			$fuelhrA320 = 3000;
		    $fuelflowA332 = 1433;
			$fuelhrA332 = 6375;
            $fuelflowA343 = 1829;
			$fuelhrA343 = 8300;
			$fuelflowF100 = 744;
			$fuelhrF100 = 2136;
			
			
            
                   
        if($route->aircraft == 'B737-800')
         {
         	$fuelflow = $fuelflowB738;
            $fuelhr = $fuelhrB738;
         }
         elseif($route->aircraft == 'B747-400')
         {
         	$fuelflow = $fuelflowB744;
            $fuelhr = $fuelhrB744;
         }
         elseif($route->aircraft == 'B767-300')
         {
         	$fuelflow = $fuelflowB763;
            $fuelhr = $fuelhrB744;
         }
		 elseif($route->aircraft == 'B777-200')
         {
         	$fuelflow = $fuelflowB772;
            $fuelhr = $fuelhrB772;
         }
         elseif($route->aircraft == 'B727-200')
         {
         	$fuelflow = $fuelflowB727;
            $fuelhr = $fuelhrB727;
         }
         elseif($route->aircraft == 'A300B2')
         {
         	$fuelflow = $fuelflowA30B;
            $fuelhr = $fuelhrA30B;
         }
         elseif($route->aircraft == 'A320-200')
         {
         	$fuelflow = $fuelflowA320;
            $fuelhr = $fuelhrA320;
         }
		 elseif($route->aircraft == 'A330-200')
         {
         	$fuelflow = $fuelflowA332;
            $fuelhr = $fuelhrA332;
         }
		 elseif($route->aircraft == 'A340-300')
         {
         	$fuelflow = $fuelflowA343;
            $fuelhr = $fuelhrA343;
         }
		 elseif($route->aircraft == 'F100')
         {
         	$fuelflow = $fuelflowF100;
            $fuelhr = $fuelhrF100;
         }
         
        $fldis = $route->distance / 100;
		$fuelnm = $fuelflow * $fldis;
        $fltaxi = 200;
		$flndg = $fuelhr * 3/4;
		$result = $fuelnm + $flndg + $fltaxi;
        ?> 	
						 <tr>
			             <td align="left" colspan="2">&nbsp&nbspAverage Cruise Speed:</td>
						 <td align="left" colspan="2">&nbsp&nbsp<b>430 kt/h - 800 km/h</b></td>
						 </tr>
						 <tr>
			             <td align="left" colspan="2">&nbsp&nbspFuel Per 1 Hour:</td>
						 <td align="left" colspan="2">&nbsp&nbsp<b><?php	echo $fuelhr ;?> kg - <?php echo ($fuelhr *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspFuel Per 100 NM:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $fuelflow ;?> kg - <?php echo ($fuelflow *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspTaxi Fuel:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $fltaxi ;?> kg - <?php echo ($fltaxi *2.2) ;?> lbs</b></td>
						 <tr>
						 <td align="left" colspan="2">&nbsp&nbspMinimum Fuel Requiered At Destination:</td>
						 <td align="left" colspan="2"><b>&nbsp&nbsp<?php echo $flndg ;?> kg - <?php echo ($flndg *2.2) ;?> lbs</b></td>
						 </tr>
						 <tr>
						 <td align="center" colspan="4"><font color="blue" size="4">Total Estimated Fuel Requiered For This Route:&nbsp;&nbsp;&nbsp;<?php echo round($result, 1) ;?> kg - <?php echo round(($result *2.2), 1) ;?> lbs</font></td>
						 </tr>
                         <tr>
						 <td align="center" colspan="4"><font size="3" color="red"><b>TO PREVENT ANY MISCALCULATION ADD 500 KG EXTRA!</b></font></td>                                  
                         </tr>
			</td>
			</tr>
			<tr>
			<th align="center" bgcolor="black" colspan="4"><font color="white">Flight Map</font></th>
			</tr>
			<tr>
			<td width="100%" colspan="4">
			<?php
			$string = "";
                        $string = $string.$route->depicao.'+-+'.$route->arricao.',+';
                        ?>

                        <img width="100%" src="http://www.gcmap.com/map?P=<?php echo $string ?>&amp;MS=bm&amp;MR=240&amp;MX=680x200&amp;PM=pemr:diamond7:red%2b%22%25I%22:red&amp;PC=%230000ff" />
</tr>
</td>
		 </table>	
        </td>

<div class="modal fade" id="confirm">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
      </div>
    </div>
  </div>
</div>
<?php
/* END OF ONE TABLE ROW */
}
}
?>
</tbody>
</table>
</div>
<hr>
<center><a href="<?php echo url('/Fltbook') ;?>"><input type="submit" class="btn btn-primary sharp" name="submit" value="Back to Flight Booking" ></a></center></div>
<br />
