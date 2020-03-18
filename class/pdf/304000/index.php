<?php

class pdf_304000_index extends pdf_common{

	private $counts = array("前残","入庫","出庫","在庫","PL");

	public function DoInit()
	{
		parent::DoInit();
		
		$this->def_y = 36;
		$this->number_format = array("CS","バラ");
		$this->right_align = array_merge(array("入目","コメントタイトル"),$this->counts);
		$this->center_align = array("未","K","S","品目計");
		
	}
	
	public function lender(){
		
		
		$width1 = array(
			' '=>8
		,	'外装商品CD'=>30
		,	'電略'=>28
		,	'入目'=>10
		,	'規格'=>28
		,	'商品名'=>90
		);
		
		$width2 = array(
			'未'=>8
		,	'ロット'=>30
		,	'K'=>14
		,	'S'=>14
		,	' '=>38
		,	'前残'=>16.5
		,	'入庫'=>16.5
		,	'出庫'=>16.5
		,	'在庫'=>24
		,	'PL'=>16.5
		);
		
		
		$width3 = array(
			'品目計'=>104
		,	'前残'=>16.5
		,	'入庫'=>16.5
		,	'出庫'=>16.5
		,	'在庫'=>24
		,	'PL'=>16.5
		);
		
		
		$width4 = array(
			'空'=>8
		,	'コメントテキスト'=>68
		,	'コメントタイトル'=>28
		,	'コメント内容'=>90
		);
		
		$this->width = array(
			$width1
		,	$width2
		);
		
		$this->DrawHeader($this->data[0],true);
		
		$tmp_shcd = "";
		
		$totals = array();
		$all_totals = array();
		
		foreach ($this->counts as $val){
			$totals[$val]["ケース"] = 0;
			$totals[$val]["バラ"] = 0;
			
			$all_totals[$val]["ケース"] = 0;
			$all_totals[$val]["バラ"] = 0;
		}
		
		
		
		foreach ($this->data as $row){
			
			$wid_length = 0;
			$left = 0;
			
			if($tmp_shcd != $row["外装商品CD"] && ($tmp_shcd)){
				
				$wid3_length = 0;
				
				foreach ($width3 as $key=>$width){
					if(in_array($key,$this->counts)){
						if($key == "在庫"){
							$this->DrawDetails(common_functions::NumberFormat($totals[$key]["ケース"],2)."<br>".common_functions::NumberFormat($totals[$key]["バラ"],2),$key,$width,$left,false,false,false,false,true);
						}
						else{
							$this->DrawDetails(common_functions::NumberFormat($totals[$key]["ケース"],2)."\r\n".common_functions::NumberFormat($totals[$key]["バラ"],2),$key,$width,$left);
						}
						
					}
					else{
						$this->DrawDetails("品　　　目　　　計",$key,$width,$left);
					}
					
					$left+=$width;
					if ($wid3_length !== count($width3)) {
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
				
				$totals = array();
				foreach ($this->counts as $val){
					$totals[$val]["ケース"] = 0;
					$totals[$val]["バラ"] = 0;
				}
			}
			
			foreach ($this->width as $wid){
				$wid_length++;
				if($wid_length == 1 && $tmp_shcd == $row["外装商品CD"]){
					continue;
				}
				if($this->y_cnt > 30){
					$this->DrawHeader($row);
				}
				$left = 0;
				
				$length = count($wid);
				$no = 0;
				
				foreach ($wid as $key=>$width){
					$no++;
					if(in_array($key,$this->counts)){
						$is_big = (intval($row["入庫ケース"]) != 0 || intval($row["入庫バラ"]) != 0 || intval($row["出庫ケース"]) != 0 || intval($row["出庫バラ"]) != 0);
						if($key == "在庫"){
							$zaiko_case_text = ($row["在庫ケース"] != $row["元在ケース"]) ? '<span style="color:#FF0000;">'.common_functions::NumberFormat($row["在庫ケース"],1) .'</span>&nbsp;&nbsp;&nbsp;<span style="text-decoration: line-through;">' . common_functions::NumberFormat($row["元在ケース"],1) . '</span>' : common_functions::NumberFormat($row["在庫ケース"],2);
							$zaiko_bara_text = ($row["在庫バラ"] != $row["在庫バラ"]) ? '<span style="color:#FF0000;">'.common_functions::NumberFormat($row["在庫バラ"],1) .'</span>&nbsp;&nbsp;&nbsp;<span style="text-decoration: line-through;">' . common_functions::NumberFormat($row["元在バラ"],1) . '</span>' : common_functions::NumberFormat($row["在庫バラ"],2);
							$this->DrawDetails($zaiko_case_text."<br>".$zaiko_bara_text,$key,$width,$left,false,false,$is_big,false,true);
						}
						else{
							$this->DrawDetails(common_functions::NumberFormat($row[$key."ケース"],2)."\r\n".common_functions::NumberFormat($row[$key."バラ"],2),$key,$width,$left,false,false,$is_big);
						}
						$totals[$key]["ケース"] += intval($row[$key."ケース"]);
						$totals[$key]["バラ"] += intval($row[$key."バラ"]);
						
						$all_totals[$key]["ケース"] += intval($row[$key."ケース"]);
						$all_totals[$key]["バラ"] += intval($row[$key."バラ"]);
					}
					else{
						$this->DrawDetails($row[$key],$key,$width,$left);
					}
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
				if($wid_length == 1){
					$cell_params = array(
							"x" => $this->def_x
					,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
					,   "w" => $this->paper_size_w - ($this->def_x * 2)
					,   "h" => $this->height
					,   "txt" => ""
					,   "fill" => true
					);
					
					$this->SetCell($cell_params);
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
			
			if($row["報告者コメント"] || $row["確認者コメント"]){
				$this->DrawDetails("コメント",'コメントテキスト',$width4["コメントテキスト"],$width4["空"],false,false,true);
				$this->DrawDetails("報告者\r\n確認者",'コメントタイトル',$width4["コメントタイトル"],$width4["空"]+$width4["コメントテキスト"]);
				
				$this->pdf->Line(
						$this->def_x + 104
						, $this->def_y + ($this->height * ($this->y_cnt)) + 1
						, $this->def_x + 104
						, $this->def_y + ($this->height * ($this->y_cnt + 1)) - 1
						, $this->line_style_detail_v
				);
				
				$this->DrawDetails($row["報告者コメント"]."\r\n".$row["確認者コメント"],'コメント内容',$width4["コメント内容"],$width4["空"]+$width4["コメントテキスト"]+$width4["コメントタイトル"]);
				
				$this->y_cnt++;
				$this->pdf->Line(
						$this->def_x
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->paper_size_w - ($this->def_x)
						,   $this->def_y + ($this->height * ($this->y_cnt))
						,   $this->line_style_detail
				);
			}
			
			$tmp_shcd = $row["外装商品CD"];
			
			
		}
		
		$left = 0;
		
		$wid3_length = 0;
		
		foreach ($width3 as $key=>$width){
			if(in_array($key,$this->counts)){
				$this->DrawDetails(common_functions::NumberFormat($totals[$key]["ケース"],2)."\r\n".common_functions::NumberFormat($totals[$key]["バラ"],2),$key,$width,$left);
			}
			else{
				$this->DrawDetails("品　　　目　　　計",$key,$width,$left);
			}
			
			$left+=$width;
			if ($wid3_length !== count($width3)) {
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
		
		$totals = array();
		foreach ($this->counts as $val){
			$totals[$val]["ケース"] = 0;
			$totals[$val]["バラ"] = 0;
		}
		
		$left = 0;
		
		$wid3_length = 0;
		
		foreach ($width3 as $key=>$width){
			if(in_array($key,$this->counts)){
				$this->DrawDetails(common_functions::NumberFormat($all_totals[$key]["ケース"],2)."\r\n".common_functions::NumberFormat($all_totals[$key]["バラ"],2),$key,$width,$left);
			}
			else{
				$this->DrawDetails("合　　　　　　　計",$key,$width,$left);
			}
			
			$left+=$width;
			if ($wid3_length !== count($width3)) {
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
				,   $this->line_style_sub_header
		);
		
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
		,   "align" => "L"
		);
		$this->pdf->setFont($this->font_family,$this->font_style,16);
		$this->SetCell($cell_params);
		$this->pdf->setFont($this->font_family,$this->font_style,$this->font_size+1);
		
		$cell_params["w"]=15;
		$cell_params["h"]=6;
		$cell_params["maxh"]=6;
		$cell_params["y"]=18;
		$cell_params["txt"]="棚卸日";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]="倉庫";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=30;
		$cell_params["txt"]="荷主";
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=5;
		$cell_params["align"]="C";
		
		$cell_params["y"]=18;
		$cell_params["txt"]=":";
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$this->SetCell($cell_params);
		
		$cell_params["y"]=30;
		$this->SetCell($cell_params);
		
		$cell_params["x"]+=$cell_params["w"];
		$cell_params["w"]=($this->paper_size_w / 2) - $cell_params["x"];
		$cell_params["align"]="L";
		$cell_params["y"]=18;
		$cell_params["txt"]=$data["棚卸日"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=24;
		$cell_params["txt"]=$data["倉庫"];
		$this->SetCell($cell_params);
		
		$cell_params["y"]=30;
		$cell_params["txt"]=$data["荷主"];
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]=100;
		$cell_params["w"]=20;
		$cell_params["y"]=12;
		$cell_params["txt"]="報告者";
		$this->SetCell($cell_params);
		
		$cell_params["x"]=115;
		$cell_params["w"]=33;
		$cell_params["txt"]=$data["報告者会社名"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=148;
		$cell_params["w"]=32;
		$cell_params["txt"]=$data["報告者名前"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=180;
		$cell_params["w"]=$this->paper_size_w - $this->def_x - 180;
		$cell_params["txt"]=$data["報告日"];
		$cell_params["align"]="R";
		$this->SetCell($cell_params);
		
		$cell_params["x"]=100;
		$cell_params["y"]=18;
		$cell_params["txt"]="確認者";
		$cell_params["align"]="L";
		$this->SetCell($cell_params);
		
		$cell_params["x"]=115;
		$cell_params["w"]=33;
		$cell_params["txt"]=$data["確認者会社名"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=148;
		$cell_params["w"]=32;
		$cell_params["txt"]=$data["確認者名前"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=180;
		$cell_params["w"]=$this->paper_size_w - $this->def_x - 180;
		$cell_params["txt"]=$data["確認日"];
		$cell_params["align"]="R";
		$this->SetCell($cell_params);
		
		
		$cell_params["x"]=100;
		$cell_params["y"]=24;
		$cell_params["txt"]="承認者";
		$cell_params["align"]="L";
		$this->SetCell($cell_params);
		
		$cell_params["x"]=115;
		$cell_params["w"]=33;
		$cell_params["txt"]=$data["承認者会社名"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=148;
		$cell_params["w"]=32;
		$cell_params["txt"]=$data["承認者名前"];
		$this->SetCell($cell_params);
		
		$cell_params["x"]=180;
		$cell_params["w"]=$this->paper_size_w - $this->def_x - 180;
		$cell_params["txt"]=$data["承認日"];
		$cell_params["align"]="R";
		$this->SetCell($cell_params);
		
		
		$this->pdf->Line(
					100
				,   12
				,   $this->paper_size_w - $this->def_x
				,   12
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				100
				,   18
				,   $this->paper_size_w - $this->def_x
				,   18
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				100
				,   24
				,   $this->paper_size_w - $this->def_x
				,   24
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				100
				,   30
				,   $this->paper_size_w - $this->def_x
				,   30
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				100
				,   12
				,   100
				,   30
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				115
				,   12
				,   115
				,   30
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				148
				,   12
				,   148
				,   30
				,   $this->line_style_detail
		);
		
		
		$this->pdf->Line(
				180
				,   12
				,   180
				,   30
				,   $this->line_style_detail
		);
		
		$this->pdf->Line(
				$this->paper_size_w - $this->def_x
				,   12
				,   $this->paper_size_w - $this->def_x
				,   30
				,   $this->line_style_detail
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
		
		$cell_params = array(
			"x" => $this->def_x
		,   "y" => $this->def_y + ($this->height * ($this->y_cnt))
		,   "w" => $this->paper_size_w - ($this->def_x * 2)
		,   "h" => $this->height
		,   "txt" => ""
		,   "fill" => true
		);
		$this->SetCell($cell_params);
		
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
			"x" => $this->paper_size_w / 2
		,   "y" => 30
		,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
		,   "h" => 6
		,	"maxh" => 6
		,   "txt" => "上 : 梱数　/　下 : 端数"
		,   "align" => "R"
		);
		
		$this->SetCell($cell_params);
		
		
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