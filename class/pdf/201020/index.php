<?php

class pdf_201020_index extends pdf_common{

	private $org_y;
	private $max_row;
	private $seach_conditions;
	
	
	public function DoInit()
	{
		
		parent::DoInit();
		$this->seach_conditions = unserialize($_SESSION["201020_SEARCH_HEADER"]);
		$sntnm = $this->params["sntnm"];
		$this->seach_conditions += array("センター"=>$sntnm);
		
		$this->number_format = array("ケース","バラ","パレット");
		$this->right_align = array("ケース","バラ","パレット");
		
		$this->def_y = 14;
		
	}
	
	public function lender(){
		$this->width = array(
			"入荷予定日"=>45
		,	"出荷元名称"=>76
		,	"荷主名"=>100
		,	"合計/ケース予定数"=>30
		,	"合計/パレット数"=>30
		);
		
		
		$this->DrawHeader($this->data[0],true);
		
		$is_draw_header = false;
		
		foreach ($this->data as $row){
			
			if($this->y_cnt > $this->max_row){
				$is_draw_header = true;
			}
			if($is_draw_header){
				$this->DrawHeader($row);
				$is_draw_header = false;
			}
			
			$left = 0;
			
			$length = count($this->width);     // 追加
			$no = 0;    // 追加
			
			foreach ($this->width as $key => $width){
				$no++;
				
				$this->DrawDetails($row[$key],$key,$width,$left,false, false,($row["DATA_DIVIDE"] !== "1"),($key==="管理区分"));
				$left+=$width;
				
				if ($no !== $length) {
					$this->pdf->Line(
							$this->def_x + $left
							, $this->def_y + ($this->height * ($this->y_cnt)) + 1
							, $this->def_x + $left
							, $this->def_y + ($this->height * ($this->y_cnt + 1)) - 1
							, $this->line_style_detail_v
					);
				}
			}
			
			
			if($row["DATA_DIVIDE"] === "2" || $row["DATA_DIVIDE"] === "3"){
				$cell_params = array(
						"x" => $this->def_x
				,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
				,   "w" => $this->paper_size_w - ($this->def_x * 2)
				,   "h" => $this->height
				,   "txt" => ""
				,   "fill" => true
				);
				$this->SetCell($cell_params);
				
				if($row["DATA_DIVIDE"] === "2"){
					$this->pdf->Line(
							$this->def_x
							,   $this->def_y + ($this->height * ($this->y_cnt))
							,   $this->paper_size_w - ($this->def_x)
							,   $this->def_y + ($this->height * ($this->y_cnt))
							,   $this->line_style_sub_header
					);
				}
				
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt+1))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt+1))
						,   $this->line_style_sub_header
				);
				
				
				
			}
			
			$this->y_cnt++;
			
			$this->pdf->Line(
					$this->def_x
					,   $this->def_y + ($this->height * ($this->y_cnt))
					,   $this->paper_size_w - ($this->def_x)
					,   $this->def_y + ($this->height * ($this->y_cnt))
					,   $this->line_style_detail
			);
			
		}
		
		
	}
	
	private function DrawHeader($data,$is_first = false){
		
		if(!$is_first){
			$this->def_y = $this->org_y;
			if($this->template){
				// PDFファイル読み込み
				$this->pdf->setSourceFile($this->template);
				$page = $this->pdf->importPage(1);
				$this->pdf->AddPage($this->land_scape,$this->format);
				$this->pdf->useTemplate($page);
			}
			else{
				$this->pdf->AddPage($this->land_scape,$this->format);
			}
			$this->y_cnt = 0;
		}
		else{
			$this->org_y = $this->def_y;
			$this->DrawConditionHeader();
		}

		
		//ROW HEADERS
		$this->pdf->Line(
				$this->def_x
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->paper_size_w - ($this->def_x)
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->line_style_header
		);
		
		$left = 0;
		$length = count($this->width);     // 追加
		$no = 0;
		foreach ($this->width as $key => $width){
			$no++;
			$this->DrawDetails($key, $key, $width, $left, true, false, true);
			$left+=$width;
			
			if ($no !== $length) {
				$this->pdf->Line(
						$this->def_x + $left
						, $this->def_y + ($this->height * ($this->y_cnt)) + 1
						, $this->def_x + $left
						, $this->def_y + ($this->height * ($this->y_cnt + 1)) - 1
						, $this->line_style_detail_v
				);
			}
		}
		$this->y_cnt++;
		
		$this->pdf->Line(
				$this->def_x
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->paper_size_w - ($this->def_x)
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->line_style_header
		);
		
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);
		
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => 4
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => $this->print_datetime
		,   "align" => "R"
		);
		
		$this->SetCell($cell_params);
		
		$this->max_row = $this->CalcMaxRow();
		
	}
	
	
	private function DrawConditionHeader(){
		
		
		//TITLE
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => 4
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => $this->title
		,   "align" => "C"
		);
		
		$this->pdf->setFont($this->font_family,$this->font_style,16);
		$this->SetCell($cell_params);
		
		//SEARCH CONDITIONS
		$this->pdf->setFont($this->font_family,"B",$this->font_size+2);
		
		$y = $this->def_y;
		foreach ($this->seach_conditions as $key => $val){
			$cell_params = array(
				"x" => $this->def_x
			,   "y" => $y
			,   "w" => 25
			,   "h" => 5
			,	"maxh" => 5
			,   "align" => "L"
			);
			
			$cell_params["txt"] = $key;
			$this->SetCell($cell_params);
			
			$cell_params["x"] = $this->def_x + 25;
			$cell_params["w"] = 5;
			$cell_params["txt"] = ":";
			$this->SetCell($cell_params);
			
			$cell_params["x"] = $this->def_x + 25 + 5;
			$cell_params["w"] = 200;
			$cell_params["txt"] = $val;
			$this->SetCell($cell_params);
			
			$y = $y+5;
		}
		
		
		$this->def_y = $y;
		$this->pdf->setFont($this->font_family,"B",$this->font_size);

	}
	
	private function CalcMaxRow(){
		
		return floor(($this->paper_size_h - $this->def_y - $this->org_y) / $this->height);
		
	}

}