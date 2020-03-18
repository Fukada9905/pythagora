<?php


class common_user
{
    private $var = [];

    public function __construct()
    {}

    public function __get($key){
        return $this->get($key);
    }

    public function __set($key,$value){
        $this->set($key,$value);
    }

    public function get($key,$default=null)
    {
        if(array_key_exists($key,$this->var)){
            return $this->var[$key];
        }
        return $default;
    }

    public function set($key,$value){
        $this->var[$key] = $value;
    }

    public function LoginCheck($data)
    {
        if(!$data){
            return STATUS_NG_USER;
        }

        if($data[0]["user_password"] != $this->var["user_password"]){
            return STATUS_NG_PASS;
        }

        foreach($data[0] as $key => $value){
            $this->var[$key] = $value;
        }
        return STATUS_OK;
    }



}