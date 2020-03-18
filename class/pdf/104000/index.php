<?php

class pdf_104000_index extends pdf_common{


	private $width1;
    private $width2;
    private $width3;
	
	public function DoInit()
	{

		parent::DoInit();


		$this->number_format = array(
		    "KKTSR1"
        ,   "KKTSR2"
        ,   "KKTSR3"
        ,   "PL_DIV"
        ,   "PL_MOD"
        ,   "WGT"
        );
        $this->right_align = array(
            "KKTSR1"
        ,   "KKTSR2"
        ,   "KKTSR3"
        ,   "PL_DIV"
        ,   "PL_MOD"
        ,   "WGT"
        ,   "TOTALS_COUNT"
        );
		
		$this->def_y = 36;
		$this->height = 4;


		
	}

	private function SetInitialState(){

        $this->width1 = array(
            "NHNSKCD"=>20
        ,	"NHNSKNM"=>100
        ,	"JYUSYO"=>130
        ,	"TEL"=>31
        );

        $this->width2 = array(
            "DENNO"=>70
        ,	"BIKO"=>211
        );

        $this->width3 = array(
            "BLANK1"=>10
        ,   "SHCD"=>17
        ,	"DNRK"=>25
        ,	"RTNO"=>25
        ,	"KKTSR1"=>12
        ,	"KKTSR2"=>12
        ,	"KKTSR3"=>12
        ,	"PL_DIV"=>7
        ,	"PL_MOD"=>7
        ,	"LOTK"=>5
        ,	"LOTS"=>5
        ,	"WGT"=>17
        ,	"SNTCD"=>7.5
        ,	"SNTNM"=>29.5
        ,	"SHNM"=>60
        ,	"SHNKKKMEI"=>30
        );

        $this->width4 = array(
            "BLANK1"=>20
        ,   "SHNM"=>57
        ,	"KKTSR1"=>12
        ,	"KKTSR2"=>12
        ,	"KKTSR3"=>12
        ,	"PL_DIV"=>7
        ,	"PL_MOD"=>7
        ,   "BLANK2"=>10
        ,	"TOTALS_COMMENT"=>15
        ,	"TOTALS_COUNT"=>20
        ,	"WGT"=>20
        ,	"TOTALS_WEIGHT_COMMENT"=>89
        );





	}
	
	public function lender(){

	    $this->SetInitialState();
		
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
		else {
			$this->doLendar();
		}

	}

	protected function SetPageNO(){

        $this->page_no_x = $this->paper_size_w - ($this->def_x) - 41;
        $this->page_no_y = $this->def_y -17;
        $this->page_no_width = 41;
        $this->page_no_height = 5;
        $this->page_align = "L";
        $this->page_prefix = "ページ　:　";

        for($i=1;$i<=$this->pdf->getNumPages();$i++){
            $this->pdf->setPage($i);
            $params = array(
                "x"=>$this->page_no_x
            ,   "y"=>$this->page_no_y
            ,   "w"=>$this->page_no_width
            ,   "h"=>$this->page_no_height
            ,   "maxh"=>$this->page_no_height
            ,   "txt"=>$this->page_prefix.$i . " / " . $this->pdf->getNumPages().$this->page_postfix
            ,   "align"=>$this->page_align
            );
            $this->pdf->setFont($this->font_family,"B",9);
            $this->SetCell($params);
        }


    }
	
	
	private function doLendar(){

		$this->DrawHeader($this->data[0],true);

		$buf_NHNSK = "";
        $buf_DENNO = "";
        $is_draw_header = false;
		
		foreach ($this->data as $row){

            $NHNSK = $row["NHNSKCD"] . "_" . $row["NHNSKNM"];
            $DENNO = $row["DENNO"];

			if($this->y_cnt > 41 || $is_draw_header){
                $this->DrawHeader($row);
                $is_draw_header = false;
			}


            if($row["DATA_DIVIDE"] === "1" ){
                if($NHNSK != $buf_NHNSK){
                    $left = 0;
                    $length = count($this->width1);
                    $no = 0;

                    foreach ($this->width1 as $key => $width){
                        $no++;
                        $this->DrawDetails($row[$key],$key,$width,$left,false, false,false,false);
                        $left+=$width;
                        if ($no == $length) {
                            $this->pdf->Line(
                                $this->def_x
                                , $this->def_y + ($this->height * ($this->y_cnt + 1))
                                , $this->def_x + $left
                                , $this->def_y + ($this->height * ($this->y_cnt + 1))
                                , $this->line_style_detail_v
                            );
                        }
                    }
                    $this->y_cnt++;

                }

                if($this->y_cnt > 41){
                    $this->DrawHeader($row);
                }

                if($DENNO != $buf_DENNO){
                    $left = 0;
                    $length = count($this->width2);
                    $no = 0;

                    foreach ($this->width2 as $key => $width){
                        $no++;
                        $this->DrawDetails($row[$key],$key,$width,$left,false, false,false,false);
                        $left+=$width;
                        if ($no == $length) {
                            $this->pdf->Line(
                                $this->def_x
                                , $this->def_y + ($this->height * ($this->y_cnt + 1))
                                , $this->def_x + $left
                                , $this->def_y + ($this->height * ($this->y_cnt + 1))
                                , $this->line_style_detail_v
                            );
                        }
                    }
                    $this->y_cnt++;

                }

                if($this->y_cnt > 41){
                    $this->DrawHeader($row);
                }


                $left = 0;
                $length = count($this->width3);
                $no = 0;

                foreach ($this->width3 as $key => $width){
                    $no++;
                    $this->DrawDetails($row[$key],$key,$width,$left,false, false,false,false);
                    $left+=$width;
                    if ($no == $length) {
                        $this->pdf->Line(
                            $this->def_x
                            , $this->def_y + ($this->height * ($this->y_cnt + 1))
                            , $this->def_x + $left
                            , $this->def_y + ($this->height * ($this->y_cnt + 1))
                            , $this->line_style_detail_v
                        );
                    }
                }
                $this->y_cnt++;
            }
            else{

                $this->pdf->SetFillColor(245,245,245);

                $left = 0;
                $length = count($this->width4);
                $no = 0;


                foreach ($this->width4 as $key => $width){
                    $no++;

                    switch ($key){
                        case "TOTALS_COMMENT":
                            $value = "(総個口数";
                            break;
                        case "TOTALS_COUNT":
                            $value = common_functions::NumberFormat($row["KKTSR1"]).")";
                            break;
                        case "TOTALS_WEIGHT_COMMENT":
                            $value = "kg";
                            break;
                        default:
                            $value = $row[$key];
                            break;

                    }
                    $this->DrawDetails($value,$key,$width,$left,false, false,true,false, false,true);
                    
                    $left+=$width;
                    if ($no == $length) {
                        $this->pdf->Line(
                            $this->def_x
                            , $this->def_y + ($this->height * ($this->y_cnt))
                            , $this->def_x + $left
                            , $this->def_y + ($this->height * ($this->y_cnt))
                            , $this->line_style_sub_header
                        );
                        $this->pdf->Line(
                            $this->def_x
                            , $this->def_y + ($this->height * ($this->y_cnt + 1))
                            , $this->def_x + $left
                            , $this->def_y + ($this->height * ($this->y_cnt + 1))
                            , $this->line_style_sub_header
                        );
                    }
                }
                $this->y_cnt++;

                $this->pdf->SetFillColor($this->fill_color_r,$this->fill_color_g,$this->fill_color_g);
            }

			
			if($row["DATA_DIVIDE"] === "3"){
				$is_draw_header = true;
			}

            $buf_NHNSK = $NHNSK;
            $buf_DENNO = $DENNO;
			
			
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
        ,   "border" => false

		);
		
		$this->pdf->setFont($this->font_family,$this->font_style,16);
		$this->SetCell($cell_params);
		$this->pdf->setFont($this->font_family,"B",$this->font_size+2);



        $this->pdf->Line(
                188
            ,   3
            ,   245
            ,   3
            ,   $this->line_style_header2
        );

        $this->pdf->Line(
                188
            ,   9
            ,   245
            ,   9
            ,   $this->line_style_header2
        );


        $this->pdf->Line(
                188
            ,   22
            ,   245
            ,   22
            ,   $this->line_style_header2
        );

        $this->pdf->Line(
                188
            ,   3
            ,   188
            ,   22
            ,   $this->line_style_header2
        );

        $this->pdf->Line(
                207
            ,   3
            ,   207
            ,   22
            ,   $this->line_style_header2
        );


        $this->pdf->Line(
                226
            ,   3
            ,   226
            ,   22
            ,   $this->line_style_header2
        );

        $this->pdf->Line(
                245
            ,   3
            ,   245
            ,   22
            ,   $this->line_style_header2
        );




        $cell_params["y"] = $this->def_y - 22;
        $cell_params["w"] = 80;
        $cell_params["h"] = 5;
		$cell_params["maxh"] = 5;
        $cell_params["txt"] = "荷主　　 : " . $data["NNSICD"] . "　" . $data["NNSINM"] . "　　" . $data["JGSNM"];
        $cell_params["align"] = "L";

        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["x"] = $this->def_x + 80;
        $cell_params["txt"] = "出荷場所 : " . $data["SYUKAP"];
		$this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y - 17;
        $cell_params["txt"] = "運送業者 : " . $data["UNSKSCD"] . "　" . $data["UNSKSNM"];

        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["x"] = $this->def_x + 80;
        $cell_params["txt"] = "納品日　 : " . $data["NOHINYMD"];

        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["y"] = $this->def_y - 27;
        $cell_params["x"] = $this->paper_size_w - ($this->def_x) - 41;
        $cell_params["txt"] = "出力日　:　" . date("Y/m/d");
        $this->SetCell(array_merge($this->params,$cell_params));

        $cell_params["y"] = $this->def_y - 22;
        $cell_params["x"] = $this->paper_size_w - ($this->def_x) - 41;
        $cell_params["txt"] = "出力者　:　" . $data["UserName"];
        $this->SetCell(array_merge($this->params,$cell_params));





        $this->pdf->Line(
                $this->def_x
            ,   $this->def_y - 12
            ,   $this->paper_size_w - ($this->def_x)
            ,   $this->def_y - 12
            ,   $this->line_style_header
        );

        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        //明細ヘッダー1行目
        $left = 0;

        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y - 12;
        $cell_params["h"] = 4;
        $cell_params["maxh"] = 4;
        $cell_params["txt"] = "配送先";
        $cell_params["w"] = $this->width1["NHNSKCD"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width1["NHNSKCD"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "名称";
        $cell_params["w"] = $this->width1["NHNSKNM"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width1["NHNSKNM"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "住所";
        $cell_params["w"] = $this->width1["JYUSYO"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width1["JYUSYO"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "電話番号";
        $cell_params["w"] = $this->width1["TEL"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width1["TEL"];

        //明細ヘッダー2行目
        $left = 0;

        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y - 8;
        $cell_params["txt"] = "伝票番号";
        $cell_params["w"] = $this->width2["DENNO"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width2["DENNO"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "備考";
        $cell_params["w"] = $this->width2["BIKO"];
        $this->SetCell(array_merge($this->params,$cell_params));

        //明細ヘッダー3行目
        $left = $this->width3["BLANK1"];

        $cell_params["y"] = $this->def_y - 4;
        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "外装商品CD";
        $cell_params["w"] = $this->width3["SHCD"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["SHCD"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "伝略";
        $cell_params["w"] = $this->width3["DNRK"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["DNRK"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "ロット";
        $cell_params["w"] = $this->width3["RTNO"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["RTNO"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "梱数";
        $cell_params["w"] = $this->width3["KKTSR1"];
        $cell_params["align"] = "C";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["KKTSR1"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "中間";
        $cell_params["w"] = $this->width3["KKTSR2"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["KKTSR2"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "端数";
        $cell_params["w"] = $this->width3["KKTSR3"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["KKTSR3"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "PL";
        $cell_params["w"] = $this->width3["PL_DIV"] + $this->width3["PL_MOD"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["PL_DIV"] + $this->width3["PL_MOD"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "K";
        $cell_params["w"] = $this->width3["LOTK"];
        $cell_params["align"] = "L";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["LOTK"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "S";
        $cell_params["w"] = $this->width3["LOTS"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["LOTS"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "重量";
        $cell_params["w"] = $this->width3["WGT"];
        $cell_params["align"] = "C";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["WGT"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "倉庫";
        $cell_params["align"] = "L";
        $cell_params["w"] = $this->width3["SNTCD"]+$this->width3["SNTNM"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["SNTCD"]+$this->width3["SNTNM"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "商品名称";
        $cell_params["w"] = $this->width3["SHNM"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["SHNM"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "規格";
        $cell_params["w"] = $this->width3["SHNKKKMEI"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width3["SHNKKKMEI"];

        $this->pdf->Line(
            $this->def_x
            ,   $this->def_y
            ,   $this->paper_size_w - ($this->def_x)
            ,   $this->def_y
            ,   $this->line_style_header
        );

	}


}