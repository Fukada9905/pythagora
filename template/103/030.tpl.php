<!DOCTYPE html>
<html lang="ja">
<head>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_meta.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_css.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_js.tpl.php"); ?>
</head>
<body>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_submenu.tpl.php"); ?>

<!-- Responsive Menu End-->
<div class="wrapper">
    <header>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_header.tpl.php"); ?>
    </header>
    <article>
		<section class="title_area">
			<div class="box_container">
				<h2><?=$page_title;?></h2>
			</div>
		</section>
		<div class="box_container">
			<section class="input_area">
			
			</section>
		</div>
	
		<section id="over_btn" class="submit_btns no_input_conditions">
			<div>
				<button type="button" class="btn btn_output btn_output_pdf"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>印刷</button>
				<button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
			</div>
		</section>
		
		<section class="tab_area">
			<div class="box_container">
				<div class="tab_controller active" data-target-view="target-view-shukkasouko">出荷倉庫別補給物量</div>
				<div class="tab_controller" data-target-view="target-view-houmen">機材別補給物量</div>
				
			</div>
		</section>
	
		<div class="tab_container_wrap">
			
			<div id="target-view-shukkasouko" class="tab_container">
				<div id="view_shukkasouko_wrap" class="tab_container_inner">
					<?php foreach ($def_data['target_date'] as $key=>$val) : ?>
						
						<section class="box_container data_area" data-target-date="<?=$val?>">
							<h3><i class="fa fa-clock-o"></i> 伝票日付 : <?=$val?></h3>
							<div class="table_wrap">
								<table id="shukkasouko_data_table_<?=str_replace("/","_",$val)?>" class="list_table">
									<thead>
									<tr>
										<th>センター名</th>
										<th>荷主名</th>
										<th>納品先名</th>
										<th>運送業者名</th>
										<th>ケース</th>
										<th>重量</th>
									</tr>
									</thead>
									<tbody>
									<td colspan="6" class="no_data">対象データがありません</td>
									</tbody>
								</table>
							</div>
						</section>
					<?php endforeach;?>
				</div>
			</div>
			
			<div id="target-view-houmen" class="tab_container">
				<div id="view_houmen_wrap" class="tab_container_inner">
					<?php foreach ($def_data['target_date'] as $key=>$val) : ?>
					<section class="box_container data_area" data-target-date="<?=$val?>">
						<h3><i class="fa fa-clock-o"></i> 伝票日付 : <?=$val?></h3>
						<div class="table_wrap">
							<table id="houmen_data_table_<?=str_replace("/","_",$val)?>" class="list_table">
								<thead>
								<tr>
									<th>運送業者名</th>
									<th>納品先名称</th>
									<th>センター名</th>
									<th>荷主名</th>
									<th>ケース</th>
									<th>重量</th>
								</tr>
								</thead>
								<tbody>
								<td colspan="6" class="no_data">対象データがありません</td>
								</tbody>
							</table>
						</div>
					</section>
					<?php endforeach;?>
				</div>
			</div>
		
			
		</div>
		
		<section class="hidden_data">
			<div id="date_length"><?=count($def_data['target_date'])-1?></div>
			<form name="output_form">
                <input type="hidden" id="params_target_date_csv" name="target_date" value="">
                <input type="hidden" name="selections" value="<?=$selections?>">
                <input type="hidden" name="process_divide" value="2">
            </form>
            <form name="output_form_pdf">
                <input type="hidden" id="params_target_date" name="target_date" value="">
                <input type="hidden" id="params_target_divide" name="target_divide" value="">
                <input type="hidden" name="selections" value="<?=$selections?>">
                <input type="hidden" name="process_divide" value="2">
            </form>
		</section>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
    <script src="<?=JS_DIR?>/100/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
    <script src="<?=JS_DIR?>/103/jquery.030.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
