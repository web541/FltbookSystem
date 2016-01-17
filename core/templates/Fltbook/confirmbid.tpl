<style>
.sharp {
	border-radius: 0;	
	margin-left: 3px;
	margin-right: 3px;
}
</style>
<div class="container-fluid">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">&times;</button>
      <h4 class="modal-title">Confirm Booking <!-- <?php echo $routeid; ?> | <?php echo $airline; ?> | <?php echo $aicao; ?> --></h4>
    </div>
        <div class="modal-body">
          <h3>Select Aircraft Registration</h3>
    <form action="<?php echo url('/schedules/addbid');?>" method="post">
		<select class="form-control" name="aircraftid" id="aircraftid">
			<option value="" selected disabled>Select Your Aircraft</option>
            <?php
            
            $allaircraft = FltbookData::getAllAircraftFltbook($airline, $aicao);
                        
            foreach($allaircraft as $aircraft)
            {
            	$icaoairline = "{$aircraft->icao}{$airline}";
                if($aircraft->registration == $icaoairline) {
                	echo '';
                } else {
                $sel = ($_POST['aircraft'] == $aircraft->name || $bid->registration == $aircraft->registration)?'selected':'';
                
                echo '<option value="'.$aircraft->id.'" '.$sel.'>'.$aircraft->registration.' - '.$aircraft->icao.' - '.$aircraft->name.'</option>';
        		}
        }
        ?>
		</select>
        <hr />
        <input type="hidden" name="routeid" value="<?php echo $routeid; ?>" />
        <input type="submit" name="submit" class="btn btn-success" value="Book" />
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
    </form>
        </div>
    <!-- 
        <a class="btn btn-success" href="<?php echo url('/schedules/addbid/'.$routeid.'?id='.$aircraft->id);?>">Book</a>
    -->
</div>