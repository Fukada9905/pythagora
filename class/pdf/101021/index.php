<?php

class pdf_101021_index extends pdf_common{

	protected $date_divide;
	
	public function DoInit()
	{
		$this->SetParams();

		parent::DoInit();
		
		
		$this->number_format = array("ケース","バラ");
		$this->right_align = array("ケース","バラ");
		
		if($this->process_divide == "1"){
			$this->def_y = 24;
			if($this->date_divide === "1"){
				$this->title = $this->title . "(トータル)";
			}
			else{
				$this->title = $this->title . "(日別)";
			}
		}
		else{
			$this->def_y = 38;
		}
		
	}

    protected function SetParams(){
		
		$this->date_divide = $this->params["params_date_divide"];
		
		$this->params["process"] = $_SESSION["100000_PROCESS_DIVIDE"];
		
		$arr_jgscd = array();
		if($_SESSION["100000_JGSCD"]){
			$arr_jgscd = array_map(function($value){
				return "'".$value["id"] ."'";
			},$_SESSION["100000_JGSCD"]);
		}
		$jgscd = !($arr_jgscd) ? null : implode(",",$arr_jgscd);
		
		$this->params["JGSCD"] = $jgscd;
		
		$arr_sntcd = array();
		if($_SESSION["101021_SNTCD"]){
			$arr_sntcd = array_map(function($value){
				return "('".$value["JGSCD"] ."','".$value["SNTCD"] ."')";
			},$_SESSION["101021_SNTCD"]);
		}
		$sntcd = !($arr_sntcd) ? null : implode(",",$arr_sntcd);
		
		$this->params["SNTCD"] = $sntcd;
		
		$arr_ptncd = array();
		if($_SESSION["100000_PTNCD"]){
			$arr_ptncd = array_map(function($value){
				return $value["id"];
			},$_SESSION["100000_PTNCD"]);
		}
		$ptncd = !($arr_ptncd) ? null : implode(",",$arr_ptncd);

        $arr_nnsicd = array();
        if($_SESSION["101021_NNSICD"]){
            $arr_nnsicd = array_map(function($value){
                return "'".$value["id"] ."'";
            },$_SESSION["101021_NNSICD"]);
        }
        $nnsicd = !($arr_nnsicd) ? null : implode(",",$arr_nnsicd);

        $this->params["NNSICD"] = $nnsicd;

		if($ptncd){
			$this->params["management_cd"] = $ptncd;
		}
		
	}
	
	public function lender(){
		
		if(!($this->data)){
			$cell_params = array(
					"x" => $this->def_x
			,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
			,   "w" => $this->paper_size_w - ($this->def_x * 2)
			,   "h" => $this->paper_size_h - ($this->def_y * 2)
			,   "maxh" => $this->paper_size_h - ($this->def_y * 2)
			,   "txt" => "出力対象データがありません"
			,   "align" => 'C'
			);
			$this->SetCell($cell_params);
		}
		else{
			switch($this->process_divide){
				case "1":
					$this->lendarDivide1();
					break;
				case "2":
					$this->lendarDivide2();
					break;
			}
		}
		
	}
	
	
	private function lendarDivide1(){
		
		$this->width = array(
			"荷主"=>35
		,	"商品コード"=>35
		,	"電略"=>35
		,	"ロット"=>35
		,	"ケース"=>20
		,	"バラ"=>20
		,	"管理区分"=>14
		);
		
		
		
		$this->DrawHeaderDivide1($this->data[0],true);
		
		$is_draw_header = false;
		
		foreach ($this->data as $row){
			
			if($this->y_cnt > 32){
				$is_draw_header = true;
			}
			if($is_draw_header){
				$this->DrawHeaderDivide1($row);
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
			
			if($row["DATA_DIVIDE"] === "1" && (trim($row["管理区分"]))){
				
				$this->pdf->SetFillColor(245,245,245);
				
				$cell_params = array(
						"x" => $this->def_x
				,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
				,   "w" => $this->paper_size_w - ($this->def_x * 2)
				,   "h" => $this->height
				,   "txt" => ""
				,   "fill" => true
				);
				$this->SetCell($cell_params);
				
				$this->pdf->SetFillColor($this->fill_color_r,$this->fill_color_g,$this->fill_color_g);
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
			
			if($row["DATA_DIVIDE"] === "3"){
				$is_draw_header = true;
			}
			
			
		}
		
	}
	
	private function DrawHeaderDivide1($data,$is_first = false){
		
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
		,   "txt" => "センター名 : " . $data["センターコード"] . "　" .$data["センター名"]
		,   "align" => "L"
		);
		$this->SetCell(array_merge($this->params,$cell_params));


        switch($this->date_divide){
            case "2":
                $date_title = "納品日";
                break;
            case "3":
                $date_title = "伝票日付";
                break;
            case "4":
                $date_title = "取込日";
                break;
            default:
                $date_title = "出荷日";
                break;
        }
		
		$cell_params = array(
			"x" => $this->def_x + (($this->paper_size_w - ($this->def_x * 2)) / 2)
		,	"y" => 16
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => $date_title . " : " . $data["日付"]
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
			$this->DrawDetails($key,$key,$width,$left,true,false,true);
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

	
	private function lendarDivide2(){
		
		$this->width = array(
			"商品コード"=>50
		,	"電略"=>50
		,	"ロット"=>40
		,	"ケース"=>20
		,	"バラ"=>20
		,	"管理区分"=>14
		);
		
		
		$this->DrawHeaderDivide2($this->data[0],true);
		
		$is_draw_header = false;
		
		foreach ($this->data as $row){
			
			if($this->y_cnt > 30){
				$is_draw_header = true;
			}
			if($is_draw_header){
				$this->DrawHeaderDivide2($row);
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
			
			if($row["DATA_DIVIDE"] === "1" && (trim($row["管理区分"]))){
				
				$this->pdf->SetFillColor(245,245,245);
				
				$cell_params = array(
						"x" => $this->def_x
				,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
				,   "w" => $this->paper_size_w - ($this->def_x * 2)
				,   "h" => $this->height
				,   "txt" => ""
				,   "fill" => true
				);
				$this->SetCell($cell_params);
				
				$this->pdf->SetFillColor($this->fill_color_r,$this->fill_color_g,$this->fill_color_g);
			}
			
			if($row["DATA_DIVIDE"] === "2"){
				$cell_params = array(
						"x" => $this->def_x
				,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
				,   "w" => $this->paper_size_w - ($this->def_x * 2)
				,   "h" => $this->height
				,   "txt" => ""
				,   "fill" => true
				);
				$this->SetCell($cell_params);
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_sub_header
				);
				
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt+1))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt+1))
						,   $this->line_style_sub_header
				);
				
				$is_draw_header = true;
				
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
	
	private function DrawHeaderDivide2($data,$is_first = false){
		
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
		
		
		$quad = ($this->paper_size_w - ($this->def_x * 2)) / 4;
		$cell_params = array(
			"x" => $this->def_x
		,	"y" => 16
		,   "w" => $quad
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "出荷日　:　" . $data["出荷日"]
		,   "align" => "L"
		);
		$this->SetCell(array_merge($this->params,$cell_params));
		
		
		$quad = ($this->paper_size_w - ($this->def_x * 2)) / 4;
		$cell_params = array(
			"x" => $this->def_x + $quad
		,	"y" => 16
		,   "w" => $quad
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "納品日　:　" . $data["納品日"]
		,   "align" => "L"
		);
		$this->SetCell(array_merge($this->params,$cell_params));
		
		
		$cell_params = array(
				"x" => $this->def_x + (($this->paper_size_w - ($this->def_x * 2)) / 2)
		,	"y" => 16
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "荷主名　：　" . $data["荷主コード"] . "　" . $data["荷主名"]
		,   "align" => "R"
		);
		$this->SetCell($cell_params);
		
		$cell_params = array(
				"x" => $this->def_x + (($this->paper_size_w - ($this->def_x * 2)) / 2)
		,	"y" => 21
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "運送業者名　:　" . $data["運送業者コード"] . "　". $data["運送業者名"]
		,   "align" => "R"
		);
		$this->SetCell(array_merge($this->params,$cell_params));
		
		
		$this->pdf->setFont($this->font_family,"B",14);
		
		$cell_params = array(
			"x" => $this->def_x
		,	"y" => 24
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 14
		,	"maxh" => 14
		,   "txt" => "納品先名 : " . $data["納品先名"]
		,   "align" => "L"
		);
		$this->SetCell(array_merge($this->params,$cell_params));
		
		$this->pdf->setFont($this->font_family,"B",$this->font_size+2);
		
		
		
		
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
			$this->DrawDetails($key,$key,$width,$left,true,false,true);
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