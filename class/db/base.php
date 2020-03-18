<?php

abstract class db_base {

    protected $connInfo;
    protected $db;

    public function __construct()
    {
        $this->initDb();
    }

    private function initDb()
    {
        try{
            $this->db = new PDO(DSN, DB_USER, DB_PASSWORD,array(PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC));
            $this->db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            $this->db->setAttribute(PDO::ATTR_TIMEOUT, 180);
        }
        catch(PDOException $e){
            common_log::OutputLog($e->getMessage());
            throw $e;
        }
    }

    // クエリ結果を取得
    public function query($sql, array $params = array())
    {
        try {
			$this->db->setAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY,false);
            $stmt = $this->db->prepare($sql);
            if ($params != null) {
                foreach ($params as $key => $val) {
                    $stmt->bindValue(':' . $key, $val);
                }
            }
			
			
			$stmt->execute();
			
			$rows = array();
			while($row = $stmt->fetch(PDO::FETCH_ASSOC))
			{
				$rows[] =  $row;
			}
			

        } catch (PDOException $e) {
            $this->OutputErrorLog($sql,$params,$e->getMessage());
            throw $e;
        } catch (Exception $e){
            $this->OutputErrorLog($sql,$params,$e->getMessage());
            throw $e;
        }
        return $rows;
    }

    //クエリを実行するだけ
    public function queryExec($sql, array $params = array())
    {
        try {
			
            $stmt = $this->db->prepare($sql);
            if ($params != null) {
                foreach ($params as $key => $val) {
                    $stmt->bindValue(':' . $key, $val);
                }
            }
            $stmt->execute();

        } catch (PDOException $e) {
            $this->OutputErrorLog($sql,$params,$e->getMessage());
            throw $e;
        } catch (Exception $e){
            $this->OutputErrorLog($sql,$params,$e->getMessage());
            throw $e;
        }
    }

    // SP実行
    public function spExec($sp_name, $params = array(),$is_return = true){


        $ret = null;
        $param_string = "";
        if($params != null){
            foreach ($params as $key => $val) {
                $param_string .= ",:". $key;
            }
            $param_string = ltrim($param_string,",");
        }
        $sql = "CALL " . $sp_name . "(" . $param_string . ")";

        if($is_return){
            $ret = $this->query($sql,$params);
        }
        else{
            $this->queryExec($sql,$params);
        }

        return $ret;
    }



    public function OutputErrorLog($sql,$params,$message){

        try{
            $param_string = "";
            if($params != null){
                foreach ($params as $key => $val) {
                    $param_string .= ",".$key."=". (is_null($val) ? "null" : $val);
                }
                $param_string = ltrim($param_string,",");
            }

            session_start();
            $user_info = unserialize($_SESSION[SESSION_USER_INFO]);
            session_write_close();

            $pr = array(   "queries" => $sql
                        ,   "params" => $param_string
                        ,   "detail" => $message
                        ,   "user_id" => $user_info->user_id
                        );



            $sql_error = "CALL pyt_p_set_error_log(:queries,:params,:detail,:user_id)";

            $stmt = $this->db->prepare($sql_error);
            if ($pr != null) {
                foreach ($pr as $key => $val) {
                    $stmt->bindValue(':' . $key, $val);
                }
            }
            $stmt->execute();


        } catch (PDOException $e) {
            common_log::OutputLog("sql:".$sql."\n"."params:".$param_string."\n"."message:".$message);
			common_log::OutputLog($e->getMessage());
        } catch (Exception $e){
			common_log::OutputLog("sql:".$sql."\n"."params:".$param_string."\n"."message:".$message);
			common_log::OutputLog($e->getMessage());
        }






    }



}