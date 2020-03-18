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
        <section id="top_navigation" class="box_container">
            <ul>
                <?php foreach($menu as $val):?>
					<?php if(($is_partner_select && $val["function_divide"] != "2") || (!$is_partner_select && $val["function_divide"] != "3")) : ?>
						<li><a data-href="<?=URL?><?=$val["function_id"];?>/<?php echo ($val["params"]) ? "?".$val["params"]:"";?>" class="hover_txt"><div class="img_wrap"><img src="<?=IMG_DIR?>/icon/<?=$val["icon_name"];?>" alt="<?=$val["menu_name"];?>"></div><?=$val["menu_name"];?></a></li>
					<?php endif;?>
                <?php endforeach;?>
            </ul>
        </section>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
</body>
</html>
