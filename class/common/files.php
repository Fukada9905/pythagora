<?php
require_once CLASS_DIR.'/PHPExcel.php';
require_once CLASS_DIR.'/PHPExcel/IOFactory.php';

class common_files{

    const FIELD_KEY_INSERT_USER_ID = "insert_user_id";
    const FIELD_KEY_FILE_NAME = "file_name";
    const FIELD_KEY_ROW_NO = "row_no";

    const COLUMN_NAME_WK_NAME = "import_wk_name";
    const COLUMN_NAME_SP_NAME = "import_sp_name";
    const COLUMN_NAME_HEADER_COUNT = "header_count";
    const COLUMN_NAME_FIELD_HEADER_COUNT = "field_header_count";
    const COLUMN_NAME_LEFT_SPACE = "left_space";
    const COLUMN_NAME_RIGHT_SPACE = "right_space";

    public static function GetInsertData($header_info, $field_info, $data, $user_id, $file_name, $header_count, $field_header_count){
        $cnt = 0;
        $ret = array();
        $add_data = array();
        foreach($header_info as $row){
            $tmp_data = array(
                "field_id"=>$row["key_id"]
            ,   "value" =>$data[$row["pos_y"]-1][$row["pos_x"]-1]
            );
            array_push($add_data,$tmp_data);
        }




        foreach($data as $key => $val){
            //指定された行は見出し行としてスキップ
                if($cnt >= $field_header_count + $header_count){
                    $ret_data = array(
                        common_files::FIELD_KEY_INSERT_USER_ID=>$user_id
                    ,   common_files::FIELD_KEY_FILE_NAME=>$file_name
                    ,   common_files::FIELD_KEY_ROW_NO=>$cnt
                    );
                    foreach($add_data as $row){
                        $ret_data = array_merge($ret_data,array($row["field_id"]=>$row["value"]));
                    }
                    $null_flg = true;
                    foreach($field_info as $field_key => $field_val){
                        if($null_flg){
                            $null_flg = ($val[(int)$field_val["column_no"]]) ? false : true;
                        }
                        $ret_data = array_merge($ret_data,array($field_val["field_id"]=>$val[(int)$field_val["column_no"]]));
                    }
                    if(!$null_flg){
                        array_push($ret,$ret_data);
                    }
                }

            $cnt ++;
        }

        return $ret;

    }

    public static Function GetFieldArray($header_info, $field_info){
        $ret = array(
            common_files::FIELD_KEY_INSERT_USER_ID=>PDO::PARAM_STR
        ,   common_files::FIELD_KEY_FILE_NAME=>PDO::PARAM_STR
        ,   common_files::FIELD_KEY_ROW_NO=>PDO::PARAM_INT
        );

        foreach($header_info as $key => $val){
            $ret = array_merge($ret,array($val["key_id"]=>PDO::PARAM_STR));
        }

        foreach($field_info as $key => $val){
            $con = constant("PDO::PARAM_".$val["field_type"]);
            $ret = array_merge($ret,array($val["field_id"]=>$con));
        }

        return $ret;
    }

    public static function GetTableNameFromFieldInfo($file_info){
        if(!$file_info){
           return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_WK_NAME];
    }

    public static function GetSpNameFromFieldInfo($file_info){
        if(!$file_info){
            return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_SP_NAME];
    }

    public static function GetHeaderCountFromFieldInfo($file_info){
        if(!$file_info){
            return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_HEADER_COUNT];
    }

    public static function GetFieldHeaderCountFromFieldInfo($file_info){
        if(!$file_info){
            return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_FIELD_HEADER_COUNT];
    }

    public static function GetLeftSpaceCountFromFieldInfo($file_info){
        if(!$file_info){
            return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_LEFT_SPACE];
    }

    public static function GetRightSpaceCountFromFieldInfo($file_info){
        if(!$file_info){
            return "";
        }
        return $file_info[0][common_files::COLUMN_NAME_RIGHT_SPACE];
    }

    public static Function GetArrayDataFromDir($dir){
        $count = 0;
        $ret = null;
        $res_dir = opendir( $dir );
        while( $file_name = readdir( $res_dir ) ){
            if( filetype( $path = $dir . $file_name ) == "file" ) {
                // ファイル名の指定
                $readFile = $dir . $file_name;
                $ret[$count] = common_files::GetArrayFromFile($readFile);
                $count++;
            }
        }
        closedir( $res_dir );
        return $ret;
    }

    public static function GetArrayFromFile($file,$left_space,$right_space){
        try{
            $ret = common_files::readXlsx($file,$left_space,$right_space);
            return $ret;
        }catch (Exception $e){
            throw $e;
        }
    }

    public static function readXlsx($readFile,$left_space,$right_space)
    {
        // ファイルの存在チェック
        if (!file_exists($readFile)) {
            exit($readFile. "が見つかりません。" . EOL);
        }

        // xlsxをPHPExcelに食わせる
        $objPExcel = PHPExcel_IOFactory::load($readFile);

        // 配列形式で返す
        return $objPExcel->getActiveSheet()->toArray(null,true,true,false,$left_space,$right_space);
    }
}