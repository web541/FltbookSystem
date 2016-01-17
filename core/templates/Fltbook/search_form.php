<?php
$pilotid = Auth::$userinfo->pilotid;
$last_location = FltbookData::getLocation($pilotid, 1);
$last_name = OperationsData::getAirportInfo($last_location->arricao);
if(!$last_location)
{
echo FltbookData::updatePilotLocation(Auth::$userinfo->hub);
}

?>
<script src="http://code.jquery.com/jquery-latest.js"></script>

<script>
$('#jumpseat').on('shown.bs.modal', function () {
  $('#myInput').focus()
})
</script>
<script>
$(document).ready(function(){
	$("select").change(function () {
		var cost = "";
		$("select option:selected").each(function (){
			cost = $(this).attr("name");
                        airport = $(this).text();
		});
		$("input[name=cost]").val( cost );
                $("input[name=airport]").val( airport );
		}).trigger('change');
});
</script>
<form action="<?php echo url('/Fltbook');?>" method="post">
    <table class="balancesheet" align="center">
	<tr>
		<td colspan="5"><strong>Schedule Search</strong></td>
	</tr>
    
    <tr>
        <td>Current Location:</td>
        <td>
            <div><span class="pull-left"><input id="depicao" name="depicao" type="hidden" value="<?php echo $last_location->arricao?>"><font color="red"><?php echo $last_location->arricao?> - <?php echo $last_name->name?></font></span>
</div>
        </td>
    </tr>
        <tr>
            <td>Select An Airline:</td>
            <td>
                <select class="search" name="airline">
                    <option value="">All</option>
                    <?php
                        foreach ($airlines as $airline)
                            {echo '<option value="'.$airline->code.'">'.$airline->name.'</option>';}
                    ?>
                </select>
            </td>
        </tr>
        <tr>
            <td>Select An Aircraft Type:</td>
            <td>
                <select class="search" name="aircraft">
                    <option value="">All</option>
                    <?php
						$airc = FltbookData::routeaircraft($last_location->arricao);
						if(!$airc)
							{
								echo '<option>No Aircraft Available!</option>';
							}
						else
							{
								foreach ($airc as $air)
									{
									$ai = FltbookData::getaircraftbyID($air->aircraft);
					?>
							<option value="<?php echo $ai->icao ;?>"><?php
							echo $ai->name ;?></option>
					<?php
									}
							}
                    ?>
                </select>
            </td>
        </tr>
        <tr>
            <td>Select Arrival Airfield:</td>
            <td>
                <select class="search" name="arricao">
                    <option value="">All</option>
                    <?php
						$airs = FltbookData::arrivalairport($last_location->arricao);
						if(!$airs)
							{
								echo '<option>No Airports Available!</option>';
							}
						else
							{
								foreach ($airs as $air)
									{
										$nam = OperationsData::getAirportInfo($air->arricao);
										echo '<option value="'.$air->arricao.'">'.$air->arricao.' - '.$nam->name.'</option>';
									}
							}
                    ?>
                </select>
            </td>
        </tr>
		<tr>
		        
				<td align="center" colspan="2">
                <input type="hidden" name="action" value="search" />
                <a href="<?php echo url('/schedules/bids') ;?>"><input type="button" value="Remove Bid"></a>
                <input border="0" type="submit" name="submit" value="Search">
				</td>			
		
            
        </tr>
        <br />
        
    </table>
</form>
<br />
<hr>
<br />
<h3><b>Pilot Transfer</b></h3>
<ul>
	<li>Your Bank limit is : <?php echo FinanceData::FormatMoney(Auth::$userinfo->totalpay) ;?></li>
</ul>
<br />
<form action="<?php echo url('/Fltbook/jumpseat');?>" method="post">
	<table class="balancesheet" width="80%" align="center">
<thead>
	<tr class="balancesheet_header">
		<td colspan="5">Airport Selection</td>
	</tr>
    	<tr>
		<td align="center">Transfer to:</td>
            <td align="left">
                <select class="search" name="depicao" onchange="listSel(this,'cost')">
                    <option value="" selected disabled>Select Airport</option>
                    <?php
                        foreach ($airports as $airport){
                            $distance = round(SchedulesData::distanceBetweenPoints($last_name->lat, $last_name->lng, $airport->lat, $airport->lng), 0);
                            $permile = Config::Get('JUMPSEAT_COST');
                            $cost = ($permile * $distance);
                            $check = PIREPData::getLastReports(Auth::$userinfo->pilotid, 1,1);
                            if($cost >= Auth::$userinfo->totalpay)
                               {
                                continue;
                               }
                            elseif($check->accepted == PIREP_ACCEPTED || !$check)
							   {
								 echo "<option name='{$cost}' value='{$airport->icao}'>{$airport->icao} - {$airport->name}    /Cost - $ {$cost}</option>";
							   }
                                ?>
                               
                               <hr> 
                 <?php                   
                         }
                    ?> 
                    </select>
                 <?php
					if(Auth::$userinfo->totalpay == "0")
                        {
					?>
                            <INPUT TYPE="submit" VALUE="Go!" disabled="disabled"> 
					<?php
					    }
					else
                        {
					?>
							<INPUT TYPE="submit" VALUE="Go!">
					<?php
						}
					?>
            	     </td>
                </select>
            </td>
         </tr>
         </table>
         <input type="hidden" name="cost">
         <input type="hidden" name="airport">
</form>
