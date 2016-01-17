<?php
ini_set('error_reporting', E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED);
class Fltbook extends CodonModule {
	
	public $title = 'Flight Booking';
	
	public function index() {
		if(!Auth::LoggedIn()) {
			$this->set('message', 'You must be logged in to access this feature!');
			$this->render('core_error.tpl');
			return;
		} else {
			 if(isset($this->post->action))
				{
					if($this->post->action == 'search') {
					$this->search();
					}
				}
				else
				{
					 $this->set('airports', OperationsData::GetAllAirports());
					 $this->set('airlines', OperationsData::getAllAirlines());
					 $this->set('aircrafts', OperationsData::getAllAircraft('true'));
					 $this->set('countries', FltbookData::findCountries());
					 $this->show('Fltbook/search_form');
				}
			}
	}	
	
	public function search() {
				$arricao = DB::escape($this->post->arricao);
                $depicao = DB::escape($this->post->depicao);
                $airline = DB::escape($this->post->airline);
                $aircraft = DB::escape($this->post->aircraft);
                
                if(!$airline)
                    {
                        $airline = '%';
                    }
                if(!$arricao)
                    {
                        $arricao = '%';
                    }
                if(!$depicao)
                    {
                        $depicao = '%';
                    }
                if($aircraft == !'')
                {
                    $aircrafts = FltbookData::findaircraft($aircraft);
                    foreach($aircrafts as $aircraft)
                    {
                        $route = FltbookData::findschedules($arricao, $depicao, $airline, $aircraft->id);
                        if(!$route){$route=array();}
                        if(!$routes){$routes=array();}
                        $routes = array_merge($routes, $route);
                    }
                }
                else
                {
                $routes = FltbookData::findschedule($arricao, $depicao, $airline);
                }

		$this->set('allroutes', $routes);
		$this->show('Fltbook/search_results');
	}
	
	public function confirm() {
		$routeid = $this->get->id;
		$airline = $this->get->airline;
		$aicao = $this->get->aicao;
		
		$this->set('aicao', $aicao);
		$this->set('airline', $airline);
		$this->set('routeid', $routeid);
		$this->render('Fltbook/confirmbid');
	}
	
	public function jumpseat() {
		if(!Auth::LoggedIn()) {

		$this->set('message', 'You must be logged in to access this feature!');
		$this->render('core_error.tpl');
		return;
		
		} else {
			
		$icao = DB::escape($this->post->depicao);
		$this->set('airport', OperationsData::getAirportInfo($icao));
		$this->set('cost', DB::escape($this->post->cost));
		$this->show('Fltbook/jumpseatticket');
			
		}
	}
	
	public function jumpseatPurchase() {
		$id = DB::escape($this->post->id);
		$cost = DB::escape($this->post->cost);
		$curmoney = Auth::$userinfo->totalpay;
		$total = ($curmoney - $cost);
		FltbookData::jumpseatpurchase(Auth::$userinfo->pilotid, $total);
		FltbookData::updatePilotLocation($id);
		header('Location: '.url('/Fltbook'));
	}
	
}