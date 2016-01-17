CREATE TABLE IF NOT EXISTS `fltbook_location` 
(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pilot_id` int(11) NOT NULL,
  `arricao` varchar(4) NOT NULL,
  `jumpseats` int(11) NOT NULL DEFAULT '0',
  `last_update` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

ALTER TABLE `phpvms_aircraft` ADD `airline` varchar(255) NOT NULL AFTER `icao`;

ALTER TABLE `phpvms_bids` ADD `aircraftid` int(11) NOT NULL AFTER `routeid`;