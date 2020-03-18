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
		<section class="box_container error_area">
			<div class="error_msg">
				<span class="error_cd">UNDER CONSTRUCTION</span><br>
				現在開発中ページ
			</div>
		</section>
	
	</article>
	<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
</body>
</html>
