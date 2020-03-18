<?php

class pdf_101051_index extends pdf_101021_index{

    protected function SetParams(){
		
		$this->date_divide = $this->params["params_date_divide"];
		
		$this->params["process"] = $_SESSION["100000_PROCESS_DIVIDE"];

	}


}