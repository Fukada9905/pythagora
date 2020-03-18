<?php

require_once('../tcpdf/tcpdf.php');
require_once('../fpdi/fpdi.php');

abstract class pdf_base {

    protected $pdf;
    
    protected $template;
    protected $file_name;
    protected $land_scape;
	protected $format;
	protected $is_print_pager;
	protected $title;
	
	protected $print_datetime;
    protected $pdo;
    protected $data;
    
    protected $process_divide;
	protected $output_method;
	protected $params;

    

    //出力変数
    protected $def_x = 8;
    protected $def_y = 8;
    protected $y_cnt = 0;
    protected $height = 8;
    protected $width = array();

    
    protected $arrHeaders = array();

    //罫線スタイル
    protected $line_style_header;
    protected $line_style_header2;
    protected $line_style_sub_header;
    protected $line_style_detail;
    protected $line_style_detail_v;
    
    //fill color
	protected $fill_color_r = 235;
	protected $fill_color_g = 235;
	protected $fill_color_b = 235;

    //page no 位置
    protected $page_no_x;
    protected $page_no_y;
    protected $page_no_width;
    protected $page_no_height;

    //paper_size
    protected $paper_size_w;
    protected $paper_size_h;


    //font_style
    protected $font_family = "kozgopromedium";
    protected $font_style = "";
    protected $font_size = 7;

    //pager
    protected $page_prefix = "Page. ";
    protected $page_postfix = "";
    protected $page_align = "R";
    
    



    public function __construct($output_method,$process_divide,$params){
        $this->pdo = new db_pdf();
        $this->pdf = new fpdi;
        
        $this->output_method = $output_method;
        $this->process_divide = $process_divide;
        $this->params = $params;
	
		$this->print_datetime = date('Y/m/d  H:i:s');
    }

    public function init(){

        try{

        	$this->DoInit();

            $this->pdf->setPageUnit('mm');
            // 余白設定
            $this->pdf->SetMargins(0, 0, 0);
            // セルパディング設定
            $this->pdf->setCellPaddings(1.5,0.5,1.5,0.5);

            //罫線設定
            $this->line_style_header = array("width"=>0.5,"dash"=>"","color"=>array(0,0,0));
            $this->line_style_header2 = array("width"=>0.1,"dash"=>"","color"=>array(0,0,0));
			$this->line_style_sub_header = array("width"=>0.1,"dash"=>"","color"=>array(50,50,50));
            $this->line_style_detail = array("width"=>0.1,"dash"=>"","color"=>array(200,200,200));
            $this->line_style_detail_v = array("width"=>0.1,"dash"=>"1,3","color"=>array(200,200,200));

            // 自動改ページ
            $this->pdf->SetAutoPageBreak(false);

            // ヘッダ、フッダを使用しない
            $this->pdf->setPrintHeader(false);
            $this->pdf->setPrintFooter(false);

            //塗りつぶし色設定
            $this->pdf->SetFillColor($this->fill_color_r,$this->fill_color_g,$this->fill_color_g);

            // フォント初期設定
            $this->pdf->SetFont($this->font_family, $this->font_style, $this->font_size);
            
            //pager位置
			
			
        }catch(Exception $e){
            $this->pdo->OutputErrorLog($this->file_name."PDF出力",null,$e->getMessage());
            $_SESSION[SESSION_ERROR_MSG1] = "PDF出力でエラーが発生しました。<br>管理者にお問い合わせください。";
            $_SESSION[SESSION_ERROR_MSG2] = "PDF Report Output Error.";
            header("Location:".URL."error.php");
            exit();
        }



    }
    
    public abstract function DoInit();

    public abstract function lender();

    public function output(){

        try{

            $this->pdf->setTitle($this->title);

            //テンプレートがある場合
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

            //ページ番号位置設定
            $this->SetPageFormat();

            // 出力内容を設定
            $this->lender();

            //ページ印字
			if($this->is_print_pager){
				$this->SetPageNO();
			}

            // PDF出力
            $string = $this->pdf->Output($this->file_name, 'I');
			
        }catch(Exception $e){
            $this->pdo->OutputErrorLog($this->file_name."PDF出力",null,$e->getMessage());
            $_SESSION[SESSION_ERROR_MSG1] = "PDF出力でエラーが発生しました。<br>管理者にお問い合わせください。";
            $_SESSION[SESSION_ERROR_MSG2] = "REPORT OUTPUT ERROR";
            exit();
        }


    }

    protected function SetCell($params = array()){

        $defValue  =    array(
            "w"=>0          // @param $w (float) Width of cells. If 0, they extend up to the right margin of the page.
        ,   "h"=>0          // @param $h (float) Cell minimum height. The cell extends automatically if needed.
        ,   "txt"=>""       // @param $txt (string) String to print
        ,   "border"=>0     // @param $border (mixed) Indicates if borders must be drawn around the cell. The value can be a number:<ul><li>0: no border (default)</li><li>1: frame</li></ul> or a string containing some or all of the following characters (in any order):<ul><li>L: left</li><li>T: top</li><li>R: right</li><li>B: bottom</li></ul> or an array of line styles for each border group - for example: array('LTRB' => array('width' => 2, 'cap' => 'butt', 'join' => 'miter', 'dash' => 0, 'color' => array(0, 0, 0)))
        ,   "align"=>"L"    // @param $align (string) Allows to center or align the text. Possible values are:<ul><li>L or empty string: left align</li><li>C: center</li><li>R: right align</li><li>J: justification (default value when $ishtml=false)</li></ul>
        ,   "fill"=>false   // @param $fill (boolean) Indicates if the cell background must be painted (true) or transparent (false).
        ,   "In"=>1          // @param $ln (int) Indicates where the current position should go after the call. Possible values are:<ul><li>0: to the right</li><li>1: to the beginning of the next line [DEFAULT]</li><li>2: below</li></ul>
        ,   "x"=>""          // @param $x (float) x position in user units
        ,   "y"=>""          // @param $y (float) y position in user units
        ,   "reseth"=>true  // @param $reseth (boolean) if true reset the last cell height (default true).
        ,   "stretch"=>0    // @param $stretch (int) font stretch mode: <ul><li>0 = disabled</li><li>1 = horizontal scaling only if text is larger than cell width</li><li>2 = forced horizontal scaling to fit cell width</li><li>3 = character spacing only if text is larger than cell width</li><li>4 = forced character spacing to fit cell width</li></ul> General font stretching and scaling values will be preserved when possible.
        ,   "ishtml"=>false// @param $ishtml (boolean) INTERNAL USE ONLY -- set to true if $txt is HTML content (default = false). Never set this parameter to true, use instead writeHTMLCell() or writeHTML() methods.
        ,   "autopadding"=>true// @param $autopadding (boolean) if true, uses internal padding and automatically adjust it to account for line width.
        ,   "maxh"=>$this->height// @param $maxh (float) maximum height. It should be >= $h and less then remaining space to the bottom of the page, or 0 for disable this feature. This feature works only when $ishtml=false.
        ,   "valign"=>"M"// @param $valign (string) Vertical alignment of text (requires $maxh = $h > 0). Possible values are:<ul><li>T: TOP</li><li>M: middle</li><li>B: bottom</li></ul>. This feature works only when $ishtml=false and the cell must fit in a single page.
        ,   "fitcell"=>false// @param $fitcell (boolean) if true attempt to fit all the text within the cell by reducing the font size (do not work in HTML mode). $maxh must be greater than 0 and equal to $h.//
        );
        

        $ret = array_merge($defValue,$params);

        $this->pdf->MultiCell($ret["w"],$ret["h"],$ret["txt"],$ret["border"],$ret["align"],$ret["fill"],$ret["In"],$ret["x"],$ret["y"],$ret["reseth"],$ret["stretch"],$ret["ishtml"],$ret["autopadding"],$ret["maxh"],$ret["valign"],$ret["fitcell"]);
    }
	
	public function SetPageFormat(){
		
		//pageNO出力場所設定
		$this->page_no_x = $this->def_x;
		
		
		if($this->land_scape == "P"){
			$this->paper_size_w = PAPER_SIZE[$this->format]["W"];
			$this->paper_size_h = PAPER_SIZE[$this->format]["H"];
		}
		else{
			$this->paper_size_w = PAPER_SIZE[$this->format]["H"];
			$this->paper_size_h = PAPER_SIZE[$this->format]["W"];
		}
		$this->page_no_y = $this->paper_size_h - 8;
		$this->page_no_width = $this->paper_size_w - ($this->def_x * 2);
		$this->page_no_height = 4;
		
	}
	
	protected function DrawBoxBorder($x1,$x2,$y1,$y2,$border_style){
	
	}

    protected function SetPageNO(){

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

            $this->SetCell($params);
        }
    }

} 