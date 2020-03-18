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
		<section id="menu_sub_input_area">
			<dl class="input_area_inner">
				<dd>
					<button type="button" class="btn btn_function btn_jigyosho" data-open-target="jigyosho" data-is-single-selection="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>事業所指定</button>
					<div id="selection_JGSCD_text" class="selection_text">指定なし</div>
				</dd>
			</dl>
			<dl class="input_area_inner">
				<dd>
					<button type="button" class="btn btn_function btn_partner" data-open-target="partner" data-is-single-selection="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>業者指定</button>
					<div id="selection_PTNCD_text" class="selection_text">指定なし</div>
				</dd>
			</dl>
		</section>
		<?php endif;?>
		</div>
        <section id="top_navigation" class="box_container">
            <ul>
                <?php foreach($menu as $val):?>
                <li><a data-href="<?=URL?><?=$val["function_id"];?>/<?php echo ($val["params"]) ? "?".$val["params"]:"";?>" class="hover_txt must_conditions"><div class="img_wrap"><img src="<?=IMG_DIR?>/icon/<?=$val["icon_name"];?>" alt="<?=$val["menu_name"];?>"></div><?=$val["menu_name"];?></a></li>
                <?php endforeach;?>
            </ul>
        </section>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<script src="<?=JS_DIR?>/300/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
