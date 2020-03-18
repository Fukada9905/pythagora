<?php
require 'config.php';
session_start();

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
		<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_header.tpl.php"); ?>
	</header>
    <article>
        <section class="box_container error_area">
            <div class="error_msg">
                <?php if(isset($_SESSION[SESSION_ERROR_MSG2])):?>
                <span class="error_cd"><?=$_SESSION[SESSION_ERROR_MSG2]?></span><br>
                <?php endif;?>
                <?=$_SESSION[SESSION_ERROR_MSG1]?>
            </div>
        <?php

			if($_SESSION[SESSION_ERROR_UNSET_FLG]){
				setcookie(CACHE_NAME_USER, '', time() - 1800,'/'); // 1分前
				setcookie(CACHE_NAME_PASS, '', time() - 1800,'/'); // 1分前
				setcookie(CACHE_NAME_TICKET, '', time() - 1800,'/'); // 1分前
				unset($_SESSION[SESSION_USER_INFO]);
				$_SESSION["LOGOUT_STATUS"] = true;
		
			}
			unset($_SESSION[SESSION_ERROR_MSG1]);
            unset($_SESSION[SESSION_ERROR_MSG2]);
            unset($_SESSION[SESSION_ERROR_UNSET_FLG]);

        ?>
            <div class="btn_wrap">
                <button type="button" class="btn btn_top" onclick="location.href='<?=URL?>'"><i class="fa fa-home" aria-hidden="true"></i>トップページ</button>
            </div>
		</section>
    </article>
    <?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
</body>
</html>

