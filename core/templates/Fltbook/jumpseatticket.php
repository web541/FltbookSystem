<div id="contenttext">
<h3>Confirm Jumpseat</h3>

<form action="<?php echo url('/Fltbook/jumpseatPurchase');?>" method="post">
     <table class="balancesheet" align="center">
        <tr>
            <td colspan="1">Jumpseat Confirmation</td>
        </tr>
        <tr>
            <td>Destination:<b> <?php echo $airport->name; ?></b></td>
        </tr>
        <tr>
            <td>Departure Date:<b> <?php echo date('m/d/Y') ?></b></td>
        </tr>
        <tr>
            <td>Total Cost:<b> $<?php echo $cost; ?></b></td>
        </tr>
    </table>
    <br />
    <center>
    <a href="<?php echo url('/Fltbook');?>"><input type="button" class="btn btn-success sharp" value="Cancel Jumpseat"></a>
	<input type="submit" value="Confirm Jumpseat">
    </center>
    <input type="hidden" name="id" id="id" value="<?php echo $airport->icao;?>" />
    <input type="hidden" name="cost" id="cost" value="<?php echo $cost; ?>" />
</form>
</div>
