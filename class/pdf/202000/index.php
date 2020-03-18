<?php

class pdf_202000_index extends pdf_common{


	public function DoInit()
	{
		parent::DoInit();
		
		$this->def_y = 32;
		$this->number_format = array("CS","バラ");
		$this->right_align = array("CS","バラ");
		
	}
	
	public function lender(){
		
		$this->width = array(
			"伝票日付"=>20
		,	"伝票番号"=>18
		,	"コード/電略"=>27
		,	"商品名称"=>57
		,	"ロット"=>18
		,	"CS"=>18
		,	"バラ"=>18
		,	"備考"=>55
		,	"業者名"=>50
		);
		
		$this->DrawHeader($this->data[0],true);
		
		
		foreach ($this->data as $row){
			
			if($this->y_cnt > 20){
				$this->DrawHeader($row);
			}
			$left = 0;
			
			$length = count($this->width);     // 追加
			$no = 0;    // 追加
			
			foreach ($this->width as $key => $width){
				$no++;
				$this->DrawDetails($row[$key],$key,$width,$left);
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
					,   $this->line_style_detail
			);
		}
	}
	
	
	private function DrawHeader($data,$is_first = false){
		
		if(!$is_first){
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
		$this->pdf->setFont($this->font_family,"B",$this->font_size+2);
		
		$cell_params = array(
			"x" => $this->def_x
		,	"y" => 16
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "納品日 : " . $data["納品日"]
		,   "align" => "L"
		);
		$this->SetCell(array_merge($this->params,$cell_params));
		
		
		$cell_params = array(
			"x" => $this->def_x
		,	"y" => 22
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "入荷先 : " . $data["入荷先"]
		,   "align" => "L"
		);
		$this->SetCell($cell_params);
		
		
		$cell_params = array(
			"x" => $this->def_x + (($this->paper_size_w - ($this->def_x * 2)) / 2)
		,	"y" => 16
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "荷主 : " . $data["荷主"]
		,   "align" => "R"
		);
		$this->SetCell($cell_params);
		
		
		$this->pdf->setFont($this->font_family,"B",$this->font_size);
		
		
		
		
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
			$this->DrawDetails($key,$key,$width,$left,true);
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
		
		
	}
 



}