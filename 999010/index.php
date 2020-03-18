<?php
require '../config.php';

class pg_999010_index extends page_master
{

	private $_master_data = array();
	private $_divide_data = array();

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
        $this->_divide_data = $this->pdo->getMasterDivide();
    }

    protected function render()
    {
        parent::render();
		$this->template->divide_data = $this->_divide_data;
        $this->template->render(TEMPLATE_DIR. DS . '999/010.tpl.php');
    }
}

$page = new pg_999010_index();
$page->run();