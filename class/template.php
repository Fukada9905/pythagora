<?php

class template
{
    private $_var = array();

    public function __set($name, $value)
    {
        $this->_var[$name] = $value;
    }

    public function render($file)
    {
        if (!is_file($file)) {
            return;
        }

        extract($this->_var);
        ob_start();
        include $file;
        $contents = ob_get_contents();
        ob_end_clean();
        echo $contents;
    }
}