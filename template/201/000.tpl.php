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
							<div class="selection_text"><?=$def_data['recent_date']?></div>
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
			</section>
		</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_menu.tpl.php"); ?>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
    <script src="<?=JS_DIR?>/200/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
    <script src="<?=JS_DIR?>/201/jquery.000.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
