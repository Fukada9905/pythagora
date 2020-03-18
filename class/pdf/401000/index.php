<?php

class pdf_401000_index extends pdf_common{

    const MAX_ROW_NUM = 68;

	public function DoInit()
	{
		parent::DoInit();
		
		$this->def_y = 14;
		$this->height = 4;
		$this->number_format = array("CS","バラ");
        $this->center_align = array("no");


		
	}
	
	public function lender(){



        $this->width = array(
            "no"=>8
        ,   "transporter_name"=>37
        ,	"shaban"=>18
        ,	"kizai"=>18
        ,	"jomuin"=>18
        ,	"tel"=>20
        ,	"remarks"=>75
        );
		
		$this->DrawPageHeader($this->data[0],true);

		/* MAX_ROWS_CHECKER
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
		foreach ($this->data as $index => $row){
		    if($this->y_cnt + 5 + ($row["details_count"] * 2) + 2 > self::MAX_ROW_NUM){
                $this->DrawPageHeader($this->data[0],false);
		        $this->y_cnt = 0;
            }
            $this->DrawSectionHeader($index+1,$row);
            if($row["details"]){
                $this->DrawTableHeader();
            }
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
            $this->y_cnt++;

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
        ,   "h" => 10
        ,	"maxh" => 10
        ,   "txt" => $this->title
        ,   "align" => "L"

        );

        $this->pdf->setFont($this->font_family,"B",$this->font_size+3);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

		$cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["txt"] = date("Y.m.d H:i");
        $cell_params["align"] = "R";
        $this->SetCell($cell_params);

	}


	private function DrawSectionHeader($index,$data){
        $cell_params = array(
            "x" => $this->def_x
        ,   "y" => $this->def_y + ($this->y_cnt * $this->height)
        ,   "w" => (($this->paper_size_w - ($this->def_x * 2)) / 4) * 3
        ,   "h" => $this->height * 2
        ,	"maxh" => $this->height * 2
        ,   "txt" => $index . "件目　伝票番号／" . $data["slip_number"] . "　" . $data["shipper_name"]
        ,   "align" => "L"
        ,   "border" => false
        );

        $this->pdf->setFont($this->font_family,"B",$this->font_size+2);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = (($this->paper_size_w - ($this->def_x * 2)) / 4);
        $cell_params["h"] = $this->height;
        $cell_params["maxh"] = $this->height;
        $cell_params["txt"] = "配車手配会社　：　" . $data["user_name"];
        $this->SetCell($cell_params);

        $cell_params["y"] = $cell_params["y"] + $this->height;
        $cell_params["txt"] = "配車担当者　　：　" . $data["dispatch_user_name"];
        $this->SetCell($cell_params);

        $this->y_cnt++;
        $this->y_cnt++;


        $this->pdf->Line(
                $this->def_x
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->def_x + ($this->paper_size_w - ($this->def_x * 2))
            , $this->def_y + ($this->height * ($this->y_cnt))
            , $this->line_style_header
        );


        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y + ($this->y_cnt * $this->height);
        $cell_params["w"] = 15;
        $cell_params["txt"] = "出荷日";
        $this->pdf->setFont($this->font_family,"B",$this->font_size);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 5;
        $cell_params["txt"] = ":";
        $cell_params["align"] = "C";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 20;
        $cell_params["txt"] = $data["retrieval_date"];
        $cell_params["align"] = "L";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 15;
        $cell_params["txt"] = "納品日";
        $this->pdf->setFont($this->font_family,"B",$this->font_size);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 5;
        $cell_params["txt"] = ":";
        $cell_params["align"] = "C";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 20;
        $cell_params["txt"] = $data["delivery_date"];
        $cell_params["align"] = "L";
        $this->SetCell($cell_params);

        $this->y_cnt++;


        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y + ($this->y_cnt * $this->height);
        $cell_params["w"] = 15;
        $cell_params["txt"] = "積地";
        $this->pdf->setFont($this->font_family,"B",$this->font_size);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 5;
        $cell_params["txt"] = ":";
        $cell_params["align"] = "C";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = ($this->paper_size_w - ($this->def_x * 2)) - 20;
        $cell_params["txt"] = $data["warehouse"];
        $cell_params["align"] = "L";
        $this->SetCell($cell_params);

        $this->y_cnt++;

        $cell_params["x"] = $this->def_x;
        $cell_params["y"] = $this->def_y + ($this->y_cnt * $this->height);
        $cell_params["w"] = 15;
        $cell_params["txt"] = "着地";
        $this->pdf->setFont($this->font_family,"B",$this->font_size);
        $this->SetCell($cell_params);
        $this->pdf->setFont($this->font_family,$this->font_style,$this->font_size);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = 5;
        $cell_params["txt"] = ":";
        $cell_params["align"] = "C";
        $this->SetCell($cell_params);

        $cell_params["x"] = $cell_params["x"] + $cell_params["w"];
        $cell_params["w"] = ($this->paper_size_w - ($this->def_x * 2)) - 20;
        $cell_params["txt"] = $data["delivery"];
        $cell_params["align"] = "L";
        $this->SetCell($cell_params);

        $this->y_cnt++;



        $this->y_cnt++;

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
        ,   "w" => $this->width["no"]
        ,   "h" => $this->height
        ,	"maxh" => $this->height
        ,   "txt" => "No."
        ,   "align" => "C"
        ,   "border" => false
        ,   "fill"=>true
        );
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