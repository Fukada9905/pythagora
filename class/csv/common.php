<?php
class csv_common extends csv_base{
	public function init(){
		try {
			$info = $this->pdo->getCsvInformation($this->output_method,$this->params["process_divide"]);
			if($info){
				$this->file_name = $info["file_name"] . date('YmdHis').".csv";
				$this->is_output_header = ($info["is_output_header"] == 1);
				$this->is_output_number = ($info["is_output_number"] == 1);
			}else{
				$this->file_name = SITE_TITLE . date('YmdHis').".csv";
				$this->is_output_header = 1;
				$this->is_output_number = 1;
			}
			$ret = $this->pdo->getCsvData($this->output_method,$this->params);
			
			if($ret){
				foreach ($ret[0] as $key => $val) {
					$this->headers[] = $key;
				}
				$this->data = $ret;
			}
		}catch (Exception $e){
			throw $e;
		}
	}
	public function lender(){
		//IN COMMON METHOD IS NOTHING TO DO
	}
}