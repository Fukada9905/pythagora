<?php
require '../config.php';

class pg_101011_index extends page_front
{
	private $_date_conditions;
	private $_date_conditions_divide;
	private $_data = array();
	
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
		
		
		$date_divide = $_SESSION["101010_DATE_DIVIDE"];
		$date_from = ($_SESSION["101010_DATE_FROM"]) ? $_SESSION["101010_DATE_FROM"] : null;
		$date_to = ($_SESSION["101010_DATE_TO"]) ? $_SESSION["101010_DATE_TO"] : null;

		switch($date_divide){
            case "2":
                $date_divide_title = "納品日";
                break;
            case "3":
                $date_divide_title = "伝票日付";
                break;
            case "4":
                $date_divide_title = "取込日";
                break;
            default:
                $date_divide_title = "出荷日";
                break;
        }
		if(!$date_from && !$date_to){
			$date_divide_text = "指定なし";
		}
		else{
			
			$date_divide_text =  !($date_from) ? "指定なし" : $date_from;
			$date_divide_text .= " ~ ";
			$date_divide_text .= !($date_to) ? "指定なし" : $date_to;
		}
		$this->_date_conditions_divide = $date_divide_title;
		$this->_date_conditions = $date_divide_title . " : " . $date_divide_text;


		if($_SESSION["101010_NINUSHI"]){
		    $data = array();
		    foreach ($_SESSION["101010_NINUSHI"] as $row){
		        $data[] = array("NNSICD"=>$row["id"],"NNSINM"=>$row["name"]);
            }
            $this->_data = $data;
        }
		else{
            $this->_data = $this->pdo->getNinushiList();
        }

		$nnsi_header = array();
		foreach ($this->_data as $row){
			$nnsi_header += array($row["NNSICD"]=>$row["NNSINM"]);
		}
		$nnsi_header += array("TOTAL"=>"合計");
		$_SESSION["101011_NNSI_HEADER"] = serialize($nnsi_header);
		
		parent::setJgsOrPartners("100000");
		
		$search_array = array();
		if(!$this->_is_partner){
			if(!$this->_is_partner_select){
				$jgstxt = !($_SESSION["100000_JGSCD"]) ? "指定なし" : $_SESSION["100000_JGSCD"][0]["id"] ."　". $_SESSION["100000_JGSCD"][0]["name"];
				$search_array += array("事業所"=>$jgstxt);
			}
			else{
				$ptntxt = !($_SESSION["100000_PTNCD"]) ? "指定なし" : $_SESSION["100000_PTNCD"][0]["id"] ."　". $_SESSION["100000_PTNCD"][0]["name"];
				$search_array += array("業者"=>$ptntxt);
			}
		}
		$search_array += array($date_divide_title=>$date_divide_text);
		
		
		$_SESSION["101011_SEARCH_HEADER"] = serialize($search_array);
		
		
		
	}
	protected function render(){
		parent::render();
		$this->template->date_conditions_divide = $this->_date_conditions_divide;
		$this->template->date_conditions = $this->_date_conditions;
		$this->template->data = $this->_data;
		$this->template->render(TEMPLATE_DIR. DS . '101/011.tpl.php');
	}
}

$page = new pg_101011_index();
$page->run();