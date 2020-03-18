<?php
abstract class page_menus extends page_front
{
    protected $_sub_menu = array();
	protected $_menu = array();
	
	
	protected function load()
	{
		if ($this->isProcess()) {
			
			$this->process();
		}
		$this->view();
	}
	
	abstract protected function process();
	protected function view(){
		$this->_menu = $this->pdo->GetMainMenu($this->user_info->user_id, $this->class_name);
	}
	
	protected function render()
	{
		parent::render();
		$this->template->menu = $this->_menu;
		
	}
}