<?php
require '../config.php';

class pg_999020_index extends page_master
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
		
        $this->template->render(TEMPLATE_DIR. DS . '999/020.tpl.php');
    }
}

$page = new pg_999020_index();
$page->run();