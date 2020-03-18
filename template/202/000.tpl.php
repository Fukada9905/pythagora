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
				<div class="input_area_title clearfix">
					<p class="fl_left">集計条件</p>
					<p class="fl_right"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
				</div>
				<form id="status_input_area">
					<div class="input_area_wrapper">
						<?php if(!$is_partner) :?>
							<?php if(!$is_partner_select) : ?>
								<dl class="input_area_inner">
									<dt>入荷事業所</dt>
									<dd>
										<div id="selection_JGSCD_text" class="selection_text">指定なし</div>
									</dd>
								</dl>
							<?php else: ?>
								<dl class="input_area_inner">
									<dt>業者</dt>
									<dd>
										<div id="selection_PTNCD_text" class="selection_text">指定なし</div>
									</dd>
								</dl>
							<?php endif; ?>
						<?php endif;?>
                        <!--
						<dl class="input_area_inner">
							<dt>データ更新日</dt>
							<dd>
								<div class="selection_text"><?=$recent_date?></div>
							</dd>
						</dl>
						-->
						<dl class="input_area_inner">
							<dt>入荷予定日</dt>
							<dd>
								<input type="text" name="date_from" data-to-target="date_to" maxlength="10" data-default-value="<?=$def_data['date_from'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
								<span class="fromto">～</span>
								<input type="text" name="date_to" data-from-target="date_from" maxlength="10" data-default-value="<?=$def_data['date_to'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
							</dd>
						</dl>
						
						<dl class="input_area_inner">
							<dt>入荷センター</dt>
							<dd>
								<button type="button" class="btn btn_function" data-open-target="center" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>センター指定</button>
								<div id="selection_SNTCD_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
					</div>
					<div class="input_area_btn_area">
						<button type="button" class="btn btn_calc input_controls">集計</button>
					</div>
				</form>
			</section>
		</div>
	
		<section id="over_btn" class="submit_btns">
			<div>
				<button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
			</div>
		</section>
		
	
		<section class="box_container data_area">
			<div class="table_wrap">
				<table id="data_table" class="list_table">
					<thead>
						<tr>
							<th>入荷予定日<div class="sort_btn on_sort" data-target-trigger="NOHINYMD" data-sort-order="DESC"><i class="fa fa-caret-down" aria-hidden="true"></i></div></th>
							<th>センター名<div class="sort_btn" data-target-trigger="SNTCD_NK" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
							<th>荷主<div class="sort_btn" data-target-trigger="NNSICD" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
							<th>印刷</th>
							<th>選択<div class="check_wrap"><input type="checkbox" name="all_checks" checked></div></th>
						</tr>
					</thead>
					<tbody>
						<td colspan="5" class="no_data">対象データがありません</td>
					</tbody>
				</table>
			</div>
		</section>
	
		<section class="hidden_data">
			<form name="output_form_csv">
				<input type="hidden" id="param_ids" name="ids" value="">
			</form>
			<form name="output_form_pdf">
				<input type="hidden" id="work_id" name="work_id" value="">
			</form>
		</section>
		
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
    <script src="<?=JS_DIR?>/200/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
    <script src="<?=JS_DIR?>/202/jquery.000.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
