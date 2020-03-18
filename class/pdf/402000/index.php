<?php

class pdf_402000_index extends pdf_common{

    const MAX_ROW_NUM = 46;
    private $header_width = array();

	public function DoInit()
	{
		parent::DoInit();
		
		$this->def_y = 20;
		$this->height = 4;
		$this->number_format = array("CS","バラ");
        $this->center_align = array("no");


		
	}
	
	public function lender(){



        $this->width = array(
            "no"=>8
        ,   "transporter_name"=>47
        ,	"shaban"=>38
        ,	"kizai"=>28
        ,	"jomuin"=>38
        ,	"tel"=>30
        ,	"remarks"=>92
        );

        $this->header_width = array(
            "no"=>8
        ,   "shipper_name"=>47
        ,	"transporter"=>38
        ,	"slip_number"=>28
        ,	"warehouse"=>38
        ,	"delivery"=>122
        );
		
		$this->DrawPageHeader($this->data[0],true);

		/*
		for($i=0;$i<self::MAX_ROW_NUM;$i++){
            $cell_params = array(
                "x" => $this->def_x
            ,   "y" => $this->def_y + ($i * $this->height)
            ,   "w" => ($this->paper_size_w - ($this->def_x * 2))
            ,   "h" => $this->height
            ,	"maxh" => $this->height
            ,   "txt" => $i
            ,   "align" => "L"
            ,   "border"=>true
            );
            $this->SetCell($cell_params);
        }
		*/

        $denpyo_ymd = "";
		foreach ($this->data as $index => $row){
		    if($this->y_cnt + ($row["details_count"] * 2) + 2 > self::MAX_ROW_NUM ||
                ($denpyo_ymd && $denpyo_ymd != $row["warehouse_accounting_date"])
            )
		    {
                $this->y_cnt = 0;
                $this->DrawPageHeader($row,false);

            }

            $left = 0;
            foreach ($this->header_width as $key => $width){
                $this->DrawDetails($row[$key],$key,$width,$left,false, false,false,false, false,true, true);
                $left+=$width;
            }
            $this->y_cnt++;
            $this->y_cnt++;

            foreach($row["details"] as $detail_row){
                $left = 0;
                foreach ($this->width as $key => $width){
                    $this->DrawDetails($detail_row[$key],$key,$width,$left,false, false,false,false, false,false, true);
                    $left+=$width;
                }
                $this->y_cnt++;
                $this->y_cnt++;

                $this->pdf->Line(
                    $this->def_x
                    , $this->def_y + ($this->height * ($this->y_cnt))
                    , $this->def_x + ($this->paper_size_w - ($this->def_x * 2))
                    , $this->def_y + ($this->height * ($this->y_cnt))
                    , $this->line_style_detail
                );

            }
            $denpyo_ymd = $row["warehouse_accounting_date"];
		}

		
	}
	
	
	private function DrawPageHeader($data,$is_first = false){
		
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
        ,   "y" => 4
        ,   "w" => ($this->paper_size_w - ($this->def_x * 2)) / 2
        ,   "h" => 8
        ,	"maxh" => 8
        ,   "txt" => $this->title
        ,   "align" => "L"
        ,   "border"=>false
        );

        $this->pdf->setFont($this->font_family,"B",$this->font_size+3);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

		$cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["txt"] = date("Y.m.d H:i");
        $cell_params["align"] = "R";
        $this->SetCell($cell_params);

        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = 12;
        $cell_params["h"] = 4;
        $cell_params["maxh"] = 4;
        $cell_params["align"] = "L";
        $cell_params["txt"] = "伝票日付　:　".$data["warehouse_accounting_date"];
        $this->pdf->setFont($this->font_family,"B",$this->font_size+2);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $this->DrawTableHeader();


	}




    private function DrawTableHeader(){




        $this->pdf->Line(
            $this->def_x
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->def_x + ($this->paper_size_w - ($this->def_x * 2))
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->line_style_sub_header
        );

        $cell_params = array(
            "x" => $this->def_x
        ,   "y" => $this->def_y + ($this->y_cnt * $this->height)
        ,   "w" => $this->header_width["no"]
        ,   "h" => $this->height
        ,	"maxh" => $this->height
        ,   "txt" => "No."
        ,   "align" => "L"
        ,   "fill" => true

        );
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->header_width["shipper_name"];
        $cell_params["txt"] = "荷主";
        $this->SetCell($cell_params);


        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->header_width["transporter"];
        $cell_params["txt"] = "パートナー";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->header_width["slip_number"];
        $cell_params["txt"] = "伝票番号";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->header_width["warehouse"];
        $cell_params["txt"] = "積地センター";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->header_width["delivery"];
        $cell_params["txt"] = "納品先";
        $this->SetCell($cell_params);

        $this->y_cnt++;

        $this->pdf->Line(
            $this->def_x
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->def_x + ($this->paper_size_w - ($this->def_x * 2))
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->line_style_detail
        );

        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y + ($this->y_cnt * $this->height);
        $cell_params["w"] = $this->width["no"];
        $cell_params["txt"] = "";
        $cell_params["align"] = "C";
        $cell_params["fill"] = false;
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["transporter_name"];
        $cell_params["txt"] = "運送会社名";
        $cell_params["align"] = "L";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["shaban"];
        $cell_params["txt"] = "車番";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["kizai"];
        $cell_params["txt"] = "機材";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["jomuin"];
        $cell_params["txt"] = "乗務員";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["tel"];
        $cell_params["txt"] = "携帯番号";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = $this->width["remarks"];
        $cell_params["txt"] = "備考";
        $this->SetCell($cell_params);


        $this->y_cnt++;

        $this->pdf->Line(
            $this->def_x
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->def_x + ($this->paper_size_w - ($this->def_x * 2))
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->line_style_sub_header
        );


    }
 



}