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
		<?php if(!$is_partner) :?>
		<section class="input_area">
			<div class="input_area_title clearfix">
				<p class="fl_left">集計条件</p>
				<p class="fl_right"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
			</div>
			<div class="input_area_wrapper">
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
			</div>
		</section>
		<?php endif;?>
		</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_menu.tpl.php"); ?>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
    <script src="<?=JS_DIR?>/100/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
    <script src="<?=JS_DIR?>/100/jquery.submenu.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
