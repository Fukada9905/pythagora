<?php

class pdf_105000_index extends pdf_common{


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
        );
		
		$this->def_y = 28;
		$this->height = 4;


		
	}

	private function SetInitialState(){

        $this->width = array(
            "BLANK1"=>18
        ,   "SHCD"=>17
        ,	"DNRK"=>25
        ,	"RTNO"=>25
        ,	"KKTSR1"=>12
        ,	"KKTSR2"=>12
        ,	"KKTSR3"=>12
        ,	"PL_DIV"=>10
        ,	"PL_MOD"=>10
        ,	"LOTK"=>5
        ,	"LOTS"=>5
        ,	"WGT"=>17
        ,	"SHNM"=>83
        ,	"SHNKKKMEI"=>30
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
        $this->page_no_y = $this->def_y -9;
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

		$buf_SHCD = "";
        $is_draw_header = false;
		
		foreach ($this->data as $row){

            $SHCD = $row["SHCD"];

			if($this->y_cnt > 43 || $is_draw_header){
                $this->DrawHeader($row);
                $is_draw_header = false;
			}


            if($row["DATA_DIVIDE"] === "1" ){

                $left = 0;
                $length = count($this->width);
                $no = 0;

                foreach ($this->width as $key => $width){
                    $no++;
                    if(($key === "SHCD" || $key === "DNRK" || $key === "SHNM" || $key === "SHNKKKMEI")
                        && $buf_SHCD == $SHCD
                    ){
                        $value = null;
                    }
                    else{
                        $value = $row[$key];
                    }
                    $this->DrawDetails($value,$key,$width,$left,false, false,false,false);
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
            elseif($row["DATA_DIVIDE"] === "3"){



                $left = 0;
                $length = count($this->width);
                $no = 0;

                foreach ($this->width as $key => $width){
                    $no++;
                    if($key === "SHCD"){
                        $value = "(合計)";
                    }
                    else{
                        $value = $row[$key];
                    }
                    $this->pdf->SetFillColor(245,245,245);
                    $this->DrawDetails($value,$key,$width,$left,false, false,true,false, false,true);
                    $this->pdf->SetFillColor($this->fill_color_r,$this->fill_color_g,$this->fill_color_g);
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


            }

			
			if($row["DATA_DIVIDE"] === "3"){
				$is_draw_header = true;
			}

            $buf_SHCD = $SHCD ;
			
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




        $cell_params["y"] = $this->def_y - 19;
        $cell_params["w"] = 75;
        $cell_params["h"] = 5;
		$cell_params["maxh"] = 5;
        $cell_params["valign"] = "T";
        $cell_params["txt"] = "荷主　　 : " . $data["NNSICD"] . "　" . $data["NNSINM"] . "　　" . $data["JGSNM"];
        $cell_params["align"] = "L";

        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["y"] = $this->def_y - 14;
        $cell_params["txt"] = "倉庫　　 : " . $data["SNTCD"] . "　" . $data["SNTNM"];

        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y - 9;
        $cell_params["txt"] = "運送業者 : " . $data["UNSKSCD"] . "　" . $data["UNSKSNM"];
        $this->SetCell(array_merge($this->params,$cell_params));

        $cell_params["x"] = $this->def_x + 75;
        $cell_params["w"] = 35;

        $cell_params["txt"] = "(納品日 : " . $data["NOHINYMD"] . ")";
        $this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["x"] = $this->def_x + 110;
        $cell_params["w"] = 60;
        $cell_params["txt"] = "出荷場所 : " . $data["SYUKAP"];
		$this->SetCell(array_merge($this->params,$cell_params));


        $cell_params["w"] = 41;
        $cell_params["y"] = $this->def_y - 19;
        $cell_params["x"] = $this->paper_size_w - ($this->def_x) - 41;
        $cell_params["txt"] = "出力日　:　" . date("Y/m/d");
        $this->SetCell(array_merge($this->params,$cell_params));

        $cell_params["y"] = $this->def_y - 14;
        $cell_params["x"] = $this->paper_size_w - ($this->def_x) - 41;
        $cell_params["txt"] = "出力者　:　" . $data["UserName"];
        $this->SetCell(array_merge($this->params,$cell_params));





        $this->pdf->Line(
                $this->def_x
            ,   $this->def_y - 4
            ,   $this->paper_size_w - ($this->def_x)
            ,   $this->def_y - 4
            ,   $this->line_style_header
        );

        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);


        //明細ヘッダー
        $left = 0;
        $cell_params["y"] = $this->def_y - 4;
        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "ロケーション";
        $cell_params["w"] = $this->width["BLANK1"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["BLANK1"];

        $cell_params["y"] = $this->def_y - 4;
        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "外装商品CD";
        $cell_params["w"] = $this->width["SHCD"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["SHCD"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "伝略";
        $cell_params["w"] = $this->width["DNRK"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["DNRK"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "ロット";
        $cell_params["w"] = $this->width["RTNO"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["RTNO"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "梱数";
        $cell_params["w"] = $this->width["KKTSR1"];
        $cell_params["align"] = "C";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["KKTSR1"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "中間";
        $cell_params["w"] = $this->width["KKTSR2"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["KKTSR2"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "端数";
        $cell_params["w"] = $this->width["KKTSR3"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["KKTSR3"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "PL";
        $cell_params["w"] = $this->width["PL_DIV"] + $this->width3["PL_MOD"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["PL_DIV"] + $this->width["PL_MOD"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "K";
        $cell_params["w"] = $this->width["LOTK"];
        $cell_params["align"] = "L";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["LOTK"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "S";
        $cell_params["w"] = $this->width["LOTS"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["LOTS"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "重量";
        $cell_params["w"] = $this->width["WGT"];
        $cell_params["align"] = "C";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["WGT"];


        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "商品名称";
        $cell_params["w"] = $this->width["SHNM"];
        $cell_params["align"] = "L";
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["SHNM"];

        $cell_params["x"] = $this->def_x + $left;
        $cell_params["txt"] = "規格";
        $cell_params["w"] = $this->width["SHNKKKMEI"];
        $this->SetCell(array_merge($this->params,$cell_params));
        $left += $this->width["SHNKKKMEI"];

        $this->pdf->Line(
            $this->def_x
            ,   $this->def_y
            ,   $this->paper_size_w - ($this->def_x)
            ,   $this->def_y
            ,   $this->line_style_header
        );

	}


}