<?php

abstract class csv_base {

	protected $file_name;
	protected $file;
	
	protected $pdo;
	protected $output_method;
	
	protected $params;
	protected $is_output_header;
	protected $is_output_number;

	protected $exclude = array();
	
	protected $headers;
	protected $data = array();

	public function __construct($output_method,$params){

		
		$this->pdo = new db_csv();
		$this->output_method = $output_method;
		$this->params = $params;
	}

	public abstract function init();

	public abstract function lender();

	public function output(){

		try{
			//CHANGE CHMOD TO TEMP DIRECTORY
			chmod(TEMP_FILE_DIR,0777);
			
			//MAKE TMP FILE
			$tmp_files = TEMP_FILE_DIR . DS . $this->makeRandStr(10) . ".csv";
			$this->file = new SplFileObject( $tmp_files, "w" );
			
			// 出力内容を加工する場合
			$this->lender();

			//header行を出力
			if($this->is_output_header){
				$export_header = array();
				if($this->is_output_number){
					$export_header[] = mb_convert_encoding("NO", 'SJIS-win', 'UTF-8');
				}
				
				foreach( $this->headers as $key => $val ){
					if(!in_array($val,$this->exclude)){
						$export_header[] = mb_convert_encoding($val, 'SJIS-win', 'UTF-8');
					}
					
				}
				
				// エンコードしたタイトル行を配列ごとCSVデータ化
				$this->file->fputcsv($export_header);
			}
			

			$i = 1;
			foreach($this->data as $row){
				$export_arr = array();
				if($this->is_output_number){
					$export_arr[] = mb_convert_encoding($i, 'SJIS-win', 'UTF-8');
				}
				// 内容行のエンコードをSJIS-winに変換（一部環境依存文字に対応用）
				foreach( $row as $key => $val ){
					if(!in_array($key,$this->exclude)){
						$export_arr[] = mb_convert_encoding($val, 'SJIS-win', 'UTF-8');
					}
				}
				// エンコードした内容行を配列ごとCSVデータ化
				$this->file->fputcsv($export_arr);
				$i++;
			}



			// PDF出力
			header("Pragma: public"); // required
			header("Expires: 0");
			header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
			header("Cache-Control: private",false); // required for certain browsers
			header("Content-Type: application/force-download");
			header("Content-Disposition: attachment; filename=\"".$this->file_name."\";" );
			header("Content-Transfer-Encoding: binary");
			readfile($tmp_files);

			chmod($tmp_files,0777);
			unlink($tmp_files);
			
		}catch(Exception $e){
			$this->pdo->OutputErrorLog($this->file_name."CSV出力",null,$e->getMessage());
			$_SESSION[SESSION_ERROR_MSG1] = "CSV出力でエラーが発生しました。<br>管理者にお問い合わせください。";
			$_SESSION[SESSION_ERROR_MSG2] = "CSV File Output Error.";
			exit();
		}
	}


	private function makeRandStr($length) {
		$str = array_merge(range('a', 'z'), range('0', '9'), range('A', 'Z'));
		$r_str = null;
		for ($i = 0; $i < $length; $i++) {
			$r_str .= $str[rand(0, count($str) - 1)];
		}
		return $r_str;
	}


} 