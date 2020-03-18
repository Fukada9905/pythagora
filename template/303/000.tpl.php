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
								<dt>事業所</dt>
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
						<?php endif; ?>
						<dl class="input_area_inner">
							<dt>棚卸日</dt>
							<dd>
								<input type="text" name="date_from" data-to-target="date_to" maxlength="10" data-default-value="<?=$def_data['date_from'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
								<span class="fromto">～</span>
								<input type="text" name="date_to" data-from-target="date_from" maxlength="10" data-default-value="<?=$def_data['date_to'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
							</dd>
						</dl>
						<dl class="input_area_inner">
							<dt>センター</dt>
							<dd>
								<button type="button" class="btn btn_function" data-open-target="center" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>センター指定</button>
								<div id="selection_SNTCD_text" class="selection_text">指定なし</div>
							</dd>
						</dl>
						<?php if(!$is_partner && !$is_partner_select) :?>
							<dl class="input_area_inner">
								<dt>パートナー</dt>
								<dd>
									<label><input type="checkbox" name="IsPartnerOnly" value="1" checked>パートナーコードが存在するレコードのみ抽出する</label>
								</dd>
							</dl>
						<?php endif; ?>
					
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
						<th>棚卸日<div class="sort_btn on_sort" data-target-trigger="PYTStocktakingDate" data-sort-order="DESC"><i class="fa fa-caret-down" aria-hidden="true"></i></div></th>
						<th>センター名<div class="sort_btn" data-target-trigger="SNTCD" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>荷主<div class="sort_btn" data-target-trigger="NNSICD" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>コメント<div class="sort_btn" data-target-trigger="HasComment" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
						<th>承認<div class="sort_btn" data-target-trigger="Status" data-sort-order="DESC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
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
				<div class="input_area_double">
					<dl class="input_area_inner">
						<dt>棚卸日</dt>
						<dd><div id="PYTStocktakingDate" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>センター名称</dt>
						<dd><div id="SNTNM" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>荷主名</dt>
						<dd><div id="NNSINM" class="selection_text"></div></dd>
					</dl>
				</div>
				<div class="input_area_double">
					<dl class="input_area_inner">
						<dt>報告者</dt>
						<dd><div id="Reporter" class="selection_text"></div></dd>
					</dl>
					<dl class="input_area_inner">
						<dt>確認者</dt>
						<dd><div id="Reviewer" class="selection_text"></div></dd>
					</dl>
				</div>
				<div class="input_area_texts">
					<p class="error_comment" id="AuthorizerComment"></p>
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
					<th>商品CD</th>
					<th>電略</th>
					<th>商品名称</th>
					<th>ロット</th>
					<th>K</th>
					<th>S</th>
					<th>CS<br>バラ</th>
					<th>実CS<br>実バラ</th>
					<th>コメント</th>
				</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<div class="over_ray_footers">
			<div class="footer_inner" style="margin-bottom: 5px;">
				<input type="text" name="Comment" id="Comment" style="min-width: 80%; padding: 8px 5px; height: auto;" placeholder="差し戻しを行う場合はコメント記入してください">
				<button type="button" class="btn btn_return input_controls" data-target-id="" disabled>差戻</button>
			</div>
			<div class="footer_inner">
				<dl>
					<dt>承認者 : </dt>
					<dd>大塚倉庫　<span id="JGSNM" class="jgsnm_text"></span> ｜ <?=$user_name?></dd>
				</dl>
				<button type="button" class="btn btn_send input_controls" data-target-id="">承認</button>
			</div>
		</div>
	</div>
</div>
<script src="<?=JS_DIR?>/300/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/303/jquery.000.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
