<?php
session_start();
require 'config.php';

?>
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
        <div id="head_top" class="box_container">
            <h1>
                <a href="<?=URL?>"><img src="<?=IMG_DIR?>/common/logo.png" alt="Logi Pull"></a>
            </h1>
        </div>
    </header>
    <article>
        <section class="box_container error_area">
            <div class="error_msg">
                <span class="error_cd">STATUS 404 : Page Not Found</span><br>
                ページが見つかりません。URLをご確認ください
            </div>
            <div class="btn_wrap">
                <button type="button" class="btn btn_top" onclick="location.href='<?=URL?>'"><i class="fa fa-home" aria-hidden="true"></i>トップページ</button>
            </div>
		</section>
    </article>
    <?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
</body>
</html>

