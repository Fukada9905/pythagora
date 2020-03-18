<?php
require '../config.php';

class pg_999920_index extends page_master
{

	
    public function __construct()
    {
        parent::__construct();
    }

    protected function load()
    {
        if ($this->isProcess()) {

            $this->process();
        }
        $this->view();
    }

    private function process(){}
    private function view(){
    
    }

    protected function render()
    {
        parent::render();
        $this->_def_data["date_from"] = date('Y/m/d');
        $this->_def_data["date_to"] = date('Y/m/d');
        $this->template->def_data = $this->_def_data;
        $this->template->render(TEMPLATE_DIR. DS . '999/920.tpl.php');
    }
}

$page = new pg_999920_index();
$page->run();