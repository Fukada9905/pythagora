<?php

class pdf_common extends pdf_base{

	protected $right_align = array();
	protected $center_align = array();
	protected $number_format = array();
	
	public function DoInit()
	{
		try {
			$info = $this->pdo->getPdfInformation($this->output_method,$this->process_divide);
			if($info){
				$this->file_name = $info["file_name"] . date('YmdHi').".pdf";
				$this->title = $info["file_name"];
				$this->is_print_pager = ($info["is_print_pager"] === "1") ? true : false;
				$this->format = $info["paper_size"];
				$this->land_scape = $info["land_scape"];
				$this->template = ($info["template_file_name"]) ? PDF_TEMPLATE_DIR. mb_substr($info["template_file_name"],-4) === ".pdf" ? $info["template_file_name"] : $info["template_file_name"] . ".pdf" : null;
			}else{
				$this->file_name = SITE_TITLE . date('YmdHis').".pdf";
				$this->title = SITE_TITLE . date('YmdHis');
				$this->is_print_pager = true;
				$this->format = "A4";
				$this->land_scape = "L";
				$this->template = null;
			}
			$ret = $this->pdo->getPdfData($this->output_method,$this->process_divide,$this->params);
			
			if($ret){
				$this->data = $ret;
			}
		}catch (Exception $e){
			throw $e;
		}
	}
	
	public function lender(){}
	
	protected function DrawDetails($value,$key,$width,$left,$is_header = false, $is_big = false, $is_bold = false, $is_italic = false, $is_html = false, $is_fill = false, $double_height = false)
	{

	    $value = ($value == null) ? "" : $value;

	    $height = $double_height ? $this->height * 2 : $this->height;
		$cell_params = array(
		  "x" => $this->def_x + $left
		, "y" => $this->def_y + ($this->height * $this->y_cnt)
		, "w" => $width
		, "h" => $height
        , "maxh" => $height
		, "txt" => $value
		, "ishtml"=>$is_html
        , "fill"=>$is_fill
		);
		
		
		//NUMBER FORMAT
		if (!$is_header && common_functions::is_in_array($key, $this->number_format)) {
			$cell_params["txt"] = common_functions::NumberFormat($cell_params["txt"]);
		}
		
		//ALIGN
		if (!$is_header) {
			if (common_functions::is_in_array($key, $this->right_align)) {
				$cell_params["align"] = "R";
			}
			if (!$is_header && common_functions::is_in_array($key, $this->center_align)) {
				$cell_params["align"] = "C";
			}
		} else {
			$cell_params["align"] = "C";
		}
		
		//FONT BIG & BOLD & ITALIC
		if($is_big || $is_bold || $is_italic){
			if($is_big){
				$font_size = $this->font_size+1;
			}
			else{
				$font_size = $this->font_size;
			}
			
			if($is_bold){
				$font_style = "B";
			}
			elseif ($is_italic){
				$font_style = "I";
			}
			else{
				$font_style = $this->font_style;
			}
			//SET NEW FONT STYLES
			$this->pdf->setFont($this->font_family,$font_style,$font_size);
		}
		
		//DRAW
		$this->SetCell($cell_params);
		
		//RESET
		if($is_big || $is_bold || $is_italic){
			$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);
		}
	}

}