<?php
require '../config.php';

class pg_999040_index extends page_master
{


	private $_divide_data1 = array();
    private $_divide_data2 = array();
    private $_divide_data3 = array();
    private $_divide_data4 = array();

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
        $this->_divide_data1 = $this->pdo->getMasterDivide(1);
        $this->_divide_data2 = $this->pdo->getMasterDivide(2);
        $this->_divide_data3 = $this->pdo->getMasterDivide(3);
        $this->_divide_data4 = $this->pdo->getMasterDivide(4);
    }

    protected function render()
    {
        parent::render();
		$this->template->divide_data1 = $this->_divide_data1;
        $this->template->divide_data2 = $this->_divide_data2;
        $this->template->divide_data3 = $this->_divide_data3;
        $this->template->divide_data4 = $this->_divide_data4;
        $this->template->render(TEMPLATE_DIR. DS . '999/040.tpl.php');
    }
}

$page = new pg_999040_index();
$page->run();