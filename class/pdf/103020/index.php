<?php

class pdf_103020_index extends pdf_common{

	
	public function DoInit()
	{
		parent::DoInit();
		
		$this->number_format = array("ケース","バラ","PL積数","PL枚数","端数","重量");
		$this->right_align = array("ケース","バラ","PL積数","PL枚数","端数","重量","合計タイトル");
		
		$this->def_y = 32;
		
	}
	
	
	public function lender(){
		
		switch ($this->process_divide) {
			case "1":
			    $this->height = 7;
                $this->pdf->setCellPaddings(1.5,0,1.5,0);
				$this->lendarDivide1();
				break;
			case "2":
				$this->lendarDivide2();
				break;
			
		}
		
	}
	
	
	private function lendarDivide1(){
		
		$width1 = array(
			"業者名"=>23
		,	"車番"=>15
		,	"納品先CD"=>22
		,	"納品先名"=>54
		,	"納品先住所"=>78
		,	"備考"=>90
		);
		
		$width2 = array(
			"引当状況"=>23
		,	"伝票番号"=>15
		,	"荷主"=>9
		,	"商品CD"=>13
		,	"電略"=>24
		,	"ロット"=>18
		,	"ケース"=>12
		,	"PL積数"=>12
		,	"PL枚数"=>12
		,	"端数"=>12
		,	"バラ"=>12
		,	"出荷倉庫"=>30
		,	"重量"=>16
		,	"商品名称"=>49
		,	"規格"=>25
		);
		
		$width_total = array(
			"合計タイトル"=>102
		,	"ケース"=>12
		,	"PL積数"=>12
		,	"PL枚数"=>12
		,	"端数"=>12
		,	"バラ"=>12
		,	"出荷倉庫"=>30
		,	"重量"=>16
		);
		
		
		
		$this->width = array(
			$width1
		,	$width2
		);
		
		
		$this->DrawHeaderDivide1($this->data[0],true);
		
		$tmp_key = "";
		$tmp_denno = null;
		
		foreach ($this->data as $row){
			if(($tmp_key != $row["HEADER_KEY"]) && $tmp_key){
				$this->DrawHeaderDivide1($row);
			}
			if($row["DATA_DIVIDE"] == "1"){

                if($this->y_cnt > 23){
                    $this->DrawHeaderDivide1($row);
                }

                if($tmp_denno === null || $tmp_denno !== $row["車番"]){

                    $left = 0;
                    $no = 0;
                    foreach ($width1 as $key=>$width){
                        $no++;
                        $this->DrawDetails($row[$key],$key,$width,$left);
                        $left+=$width;
                        if ($no !== count($width1)) {
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

                if($this->y_cnt > 23){
                    $this->DrawHeaderDivide1($row);
                }

                $left = 0;
                $no = 0;
                foreach ($width2 as $key=>$width){
                    $no++;
                    $this->DrawDetails($row[$key],$key,$width,$left);
                    $left+=$width;
                    if ($no !== count($width2)) {
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
                $tmp_denno = $row["車番"];
			}
			else{
				if($this->y_cnt > 23){
					$this->DrawHeaderDivide1($row);
				}
				$left = 0;
				$no = 0;
				foreach ($width_total as $key=>$width){
					$this->DrawDetails($row[$key],$key,$width,$left,false,false,true);
					$left+=$width;
					if ($no !== count($width_total)) {
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
				if($row["DATA_DIVIDE"] == "2"){
					$this->pdf->Line(
							$this->def_x
							,   $this->def_y + ($this->height * ($this->y_cnt -1))
							,   $this->paper_size_w - ($this->def_x)
							,   $this->def_y + ($this->height * ($this->y_cnt -1))
							,   $this->line_style_header
					);
				}
				
				$this->pdf->Line(
							$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt -1))
						,   $this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
				
				$this->pdf->Line(
						$this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt -1))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
				
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
                $tmp_denno = null;
			}

			$tmp_key = $row["HEADER_KEY"];
			
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
		
		
		/*****************************************************************/
		/* START PAPER HEADER */
		/*****************************************************************/
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => 5
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => $this->title
		,   "align" => "C"
		);
		$this->pdf->setFont($this->font_family,$this->font_style,16);
		$this->SetCell($cell_params);
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size+1);
		
		
		$cell_params["w"]=19;
		$cell_params["h"]=6;
		$cell_params["maxh"]=6;
		$cell_params["y"]=18;
		$cell_params["txt"]="出荷日";
		$cell_params["align"]="L";
		
		
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]="運送会社CD";
		$this->SetCell($cell_params);
		
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=4;
		$cell_params["align"]="C";
		
		$cell_params["y"]=18;
		$cell_params["txt"]=":";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=30;
		$cell_params["align"]="L";
		$cell_params["y"]=18;
		$cell_params["txt"]=$data["出荷日"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]=$data["運送会社CD"];
		$this->SetCell($cell_params);
		
		
		$cell_params["w"]=19;
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["y"]=18;
		$cell_params["txt"]="納品日";
		$cell_params["align"]="L";
		
		
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]="運送会社名";
		$this->SetCell($cell_params);
		
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=4;
		$cell_params["align"]="C";
		
		$cell_params["y"]=18;
		$cell_params["txt"]=":";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=30;
		$cell_params["align"]="L";
		$cell_params["y"]=18;
		$cell_params["txt"]=$data["納品日"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]=$data["運送会社名"];
		$this->SetCell($cell_params);
		
		
		
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => 14
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => "事業所　:　".$data["事業所名称"]
		,   "align" => "R"
		);
		
		
		$this->SetCell($cell_params);
		
		
		
		$this->pdf->Line(
					190
				,   5
				,   244
				,   5
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
					190
				,   23
				,   244
				,   23
				,   $this->line_style_header
		);
		
		
		$this->pdf->Line(
					190
				,   5
				,   190
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
					208
				,   5
				,   208
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
					226
				,   5
				,   226
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
					244
				,   5
				,   244
				,   23
				,   $this->line_style_header
		);
		
		
		
		
		
		/*****************************************************************/
		/* START TABLE HEADER */
		/*****************************************************************/
		$this->pdf->setFont($this->font_family,"B",$this->font_size+1);
		
		$this->pdf->Line(
				$this->def_x
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->paper_size_w - ($this->def_x)
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->line_style_header
		);
		
		
		foreach ($this->width as $wid){
			
			$left = 0;
			$length = count($wid);     // 追加
			$no = 0;
			
			
			
			foreach ($wid as $key => $width){
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
			
			
			
		}
		
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);
		
		
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => 4
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => "出力日時　:　".$this->print_datetime
		,   "align" => "R"
		);
		
		$this->SetCell($cell_params);
		
		
	}
	
	private function lendarDivide2(){
		
		$width1 = array(
			"業者名"=>23.5
		,	"車番"=>14.5
		,	"納品先CD"=>22
		,	"納品先名"=>54
		,	"納品先住所"=>78
		,	"備考"=>90
		);
		
		$width2 = array(
			"引当状況"=>23.5
		,	"伝票番号"=>14.5
		,	"荷主"=>9
		,	"商品CD"=>13
		,	"電略"=>30
		,	"ロット"=>12
		,	"ケース"=>12
		,	"PL積数"=>12
		,	"PL枚数"=>12
		,	"端数"=>12
		,	"バラ"=>12
		,	"運送会社"=>30
		,	"重量"=>16
		,	"商品名称"=>49
		,	"規格"=>25
		);
		
		$width_total = array(
			"合計タイトル"=>102
		,	"ケース"=>12
		,	"PL積数"=>12
		,	"PL枚数"=>12
		,	"端数"=>12
		,	"バラ"=>12
		,	"出荷倉庫"=>30
		,	"重量"=>16
		);
		
		
		
		$this->width = array(
			$width1
		,	$width2
		);
		
		
		$this->DrawHeaderDivide2($this->data[0],true);
		
		$tmp_key = "";
		
		foreach ($this->data as $row){
			if(($tmp_key != $row["HEADER_KEY"]) && $tmp_key){
				$this->DrawHeaderDivide2($row);
			}
			if($row["DATA_DIVIDE"] == "1"){
				foreach ($this->width as $wid){
					if($this->y_cnt > 20){
						$this->DrawHeaderDivide2($row);
					}
					
					$left = 0;
					$no = 0;
					foreach ($wid as $key=>$width){
						$no++;
						$this->DrawDetails($row[$key],$key,$width,$left);
						$left+=$width;
						if ($no !== count($wid)) {
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
			else{
				if($this->y_cnt > 20){
					$this->DrawHeaderDivide2($row);
				}
				$left = 0;
				$no = 0;
				foreach ($width_total as $key=>$width){
					$this->DrawDetails($row[$key],$key,$width,$left,false,false,true);
					$left+=$width;
					if ($no !== count($width_total)) {
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
				if($row["DATA_DIVIDE"] == "2"){
					$this->pdf->Line(
							$this->def_x
							,   $this->def_y + ($this->height * ($this->y_cnt -1))
							,   $this->paper_size_w - ($this->def_x)
							,   $this->def_y + ($this->height * ($this->y_cnt -1))
							,   $this->line_style_header
					);
				}
				
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt -1))
						,   $this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
				
				$this->pdf->Line(
						$this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt -1))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
				
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_header
				);
				
			}
			$tmp_key = $row["HEADER_KEY"];
			
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
		
		
		/*****************************************************************/
		/* START PAPER HEADER */
		/*****************************************************************/
		$cell_params = array(
				"x" => $this->def_x
		,   "y" => 5
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => $this->title
		,   "align" => "C"
		);
		$this->pdf->setFont($this->font_family,$this->font_style,16);
		$this->SetCell($cell_params);
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size+1);
		
		
		$cell_params["w"]=19;
		$cell_params["h"]=6;
		$cell_params["maxh"]=6;
		$cell_params["y"]=18;
		$cell_params["txt"]="出荷日";
		$cell_params["align"]="L";
		
		
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]="出荷倉庫CD";
		$this->SetCell($cell_params);
		
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=4;
		$cell_params["align"]="C";
		
		$cell_params["y"]=18;
		$cell_params["txt"]=":";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=30;
		$cell_params["align"]="L";
		$cell_params["y"]=18;
		$cell_params["txt"]=$data["出荷日"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]=$data["出荷倉庫CD"];
		$this->SetCell($cell_params);
		
		
		$cell_params["w"]=19;
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["y"]=18;
		$cell_params["txt"]="納品日";
		$cell_params["align"]="L";
		
		
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]="出荷倉庫名";
		$this->SetCell($cell_params);
		
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=4;
		$cell_params["align"]="C";
		
		$cell_params["y"]=18;
		$cell_params["txt"]=":";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=30;
		$cell_params["align"]="L";
		$cell_params["y"]=18;
		$cell_params["txt"]=$data["納品日"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]=$data["出荷倉庫名"];
		$this->SetCell($cell_params);
		
		
		
		$cell_params = array(
				"x" => $this->def_x
		,   "y" => 14
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => "事業所　:　".$data["事業所名称"]
		,   "align" => "R"
		);
		
		
		$this->SetCell($cell_params);
		
		
		
		$this->pdf->Line(
				190
				,   5
				,   244
				,   5
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
				190
				,   23
				,   244
				,   23
				,   $this->line_style_header
		);
		
		
		$this->pdf->Line(
				190
				,   5
				,   190
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
				208
				,   5
				,   208
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
				226
				,   5
				,   226
				,   23
				,   $this->line_style_header
		);
		
		$this->pdf->Line(
				244
				,   5
				,   244
				,   23
				,   $this->line_style_header
		);
		
		
		
		
		
		/*****************************************************************/
		/* START TABLE HEADER */
		/*****************************************************************/
		$this->pdf->setFont($this->font_family,"B",$this->font_size+1);
		
		$this->pdf->Line(
				$this->def_x
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->paper_size_w - ($this->def_x)
				,   $this->def_y + ($this->height * ($this->y_cnt))
				,   $this->line_style_header
		);
		
		
		foreach ($this->width as $wid){
			
			$left = 0;
			$length = count($wid);     // 追加
			$no = 0;
			
			
			
			foreach ($wid as $key => $width){
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
			
			
			
		}
		
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);
		
		
		$cell_params = array(
				"x" => $this->def_x
		,   "y" => 4
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => 10
		,	"maxh" => 10
		,   "txt" => "出力日時　:　".$this->print_datetime
		,   "align" => "R"
		);
		
		$this->SetCell($cell_params);
		
		
	}



}