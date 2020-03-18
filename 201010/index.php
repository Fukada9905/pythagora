<?php
require '../config.php';

class pg_201010_index extends page_front
{
	private $_date_conditions;
	private $_recent_date;
	
	public function __construct()
	{
		parent::__construct();
	}
	protected function load()
	{
		if ($this->isProcess()) {
			
			$this->process();
		}
		$this->view();
	}
	protected function process(){}
	protected function view(){

		//$this->_recent_date = $this->pdo->getRecentDate();
		
		$date_from = ($_SESSION["201000_DATE_FROM"]) ? $_SESSION["201000_DATE_FROM"] : date('Y/m/d');
		$date_to = ($_SESSION["201000_DATE_TO"]) ? $_SESSION["201000_DATE_TO"] : '';
		
		if(!$date_from && !$date_to){
			$date_divide_text = "指定なし";
		}
		else{
			$date_divide_text =  !($date_from) ? "指定なし" : $date_from;
			$date_divide_text .= " ~ ";
			$date_divide_text .= !($date_to) ? "指定なし" : $date_to;
		}
		$this->_date_conditions = $date_divide_text;
		
		parent::setJgsOrPartners("200000");
		
		$search_array = array();
		if(!$this->_is_partner){
			if(!$this->_is_partner_select){
				$jgstxt = !($_SESSION["200000_JGSCD"]) ? "指定なし" : $_SESSION["200000_JGSCD"][0]["id"] ."　". $_SESSION["200000_JGSCD"][0]["name"];
				$search_array += array("事業所"=>$jgstxt);
			}
			else{
				$ptntxt = !($_SESSION["200000_PTNCD"]) ? "指定なし" : $_SESSION["200000_PTNCD"][0]["id"] ."　". $_SESSION["200000_PTNCD"][0]["name"];
				$search_array += array("業者"=>$ptntxt);
			}
		}
		//$search_array += array("データ更新日"=>$this->_recent_date);
		$search_array += array("入荷予定日"=>$date_divide_text);
		
		
		$_SESSION["201010_SEARCH_HEADER"] = serialize($search_array);
		
	}
	protected function render(){
		parent::render();
		//$this->template->recent_date = $this->_recent_date;
		$this->template->date_conditions = $this->_date_conditions;
		$this->template->render(TEMPLATE_DIR. DS . '201/010.tpl.php');
	}
}

$page = new pg_201010_index();
$page->run();