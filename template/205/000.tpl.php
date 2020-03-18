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
						<dl class="input_area_inner">
							<dt>処理日</dt>
							<dd>
								<input type="text" name="date_from" data-to-target="date_to" maxlength="10" data-default-value="<?=$def_data['date_from'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
								<span class="fromto">～</span>
								<input type="text" name="date_to" data-from-target="date_from" maxlength="10" data-default-value="<?=$def_data['date_to'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>荷主</dt>
							<dd>
								<button type="button" class="btn btn_function" data-open-target="ninushi" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>荷主指定</button>
								<div id="selection_NNSICD_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>伝票番号</dt>
							<dd>
								<button type="button" class="btn btn_function_other btn_denno_select"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>伝票番号指定</button>
								<div id="selection_DENNO_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>入荷センター</dt>
							<dd>
								<button type="button" class="btn btn_function" data-open-target="center" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>センター指定</button>
								<div id="selection_SNTCD_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>商品コード</dt>
							<dd>
								<button type="button" class="btn btn_function_other btn_shcd_select"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>商品コード指定</button>
								<div id="selection_SHCD_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>コメント</dt>
							<dd>
								<label><input type="checkbox" name="comment_checks" class="comment_checks">コメント有のみ表示</label>
							</dd>
						</dl>
					
					</div>
					<div class="input_area_btn_area">
						<button type="button" class="btn btn_calc input_controls">集計</button>
					</div>
				</form>
			</section>
		</div>
		
		
		
		<section class="box_container data_area">
			<div class="table_wrap">
				<table id="data_table" class="list_table">
					<thead>
					<tr>
						<th>処理日<div class="sort_btn" data-target-trigger="SYORIYMD" data-sort-order="DESC"><i class="fa fa-caret-down" aria-hidden="true"></i></div></th>
						<th>入荷予定日<div class="sort_btn" data-target-trigger="NOHINYMD" data-sort-order="ASC"><i class="fa fa-caret-down" aria-hidden="true"></i></div></th>
						<th>伝票番号<div class="sort_btn" data-target-trigger="DENNO" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>荷主<div class="sort_btn" data-target-trigger="NNSICD" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>出荷元<div class="sort_btn" data-target-trigger="JGSCD_SK" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>入荷先<div class="sort_btn" data-target-trigger="SNTCD_NK" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>コメント<div class="sort_btn" data-target-trigger="HasComment" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>&nbsp;</th>
					</tr>
					</thead>
					<tbody>
					<td colspan="6" class="no_data">対象データがありません</td>
					</tbody>
				</table>
			</div>
		</section>
		
		<section class="hidden_data">
			<form name="output_form">
				<input type="hidden" id="param_ids" name="ids" value="">
				
			</form>
		</section>
	
	</article>
	<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<div id="over_ray_tables">
	
	<div class="over_ray_inner">
		
		<h3>詳細</h3>
		
		<section class="input_area">
			
			<div class="input_area_wrapper">
				<div class="input_area_tripple">
					<dl class="input_area_inner">
						<dt>伝票番号</dt>
						<dd><div id="DENNO" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>出荷元</dt>
						<dd><div id="JGSCD_SK" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>入荷先</dt>
						<dd><div id="SNTCD_NK" class="selection_text"></div></dd>
					</dl>
				</div>
				<div class="input_area_tripple">
					<dl class="input_area_inner">
						<dt>伝票日付</dt>
						<dd><div id="DENPYOYMD" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>入荷予定日</dt>
						<dd><div id="NOHINYMD" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>運送会社名</dt>
						<dd><div id="UNSKSNM" class="selection_text"></div></dd>
					</dl>
				</div>
				<div class="input_area_tripple">
					<dl class="input_area_inner">
						<dt>出荷日</dt>
						<dd><div id="SYUKAYMD" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>処理日</dt>
						<dd><div id="SYORIYMD" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>荷主</dt>
						<dd><div id="NNSINM" class="selection_text"></div></dd>
					</dl>
				</div>
				
			</div>
		
		</section>
		<div class="close_btn_wrap">
			<div class="close_btn">
				<div class="close_btn_bar close_btn_bar_top"></div>
				<div class="close_btn_bar close_btn_bar_bottom"></div>
			</div>
		</div>
		<div class="table_wrap">
			<table id="data_table_det" class="list_table">
				<thead>
				<tr>
					<th>伝票番号</th>
					<th>商品CD</th>
					<th>電略</th>
					<th>商品名称</th>
					<th>ロット</th>
					<th>CS</th>
					<th>バラ</th>
					<th>コメント</th>
				</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<div class="over_ray_footers_multi clearfix">
			<div>
				<dl class="reporter_table">
					<dt>報告者</dt>
					<dd id="Reporter"></dd>
				</dl>
				<dl class="reporter_table">
					<dt>入荷入力者</dt>
					<dd id="Registrant"></dd>
				</dl>
			</div>
		</div>
	</div>
</div>
<script src="<?=JS_DIR?>/200/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/205/jquery.000.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
