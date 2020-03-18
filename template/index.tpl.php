<!DOCTYPE html>
<html lang="ja">
<head>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_meta.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_css.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_js.tpl.php"); ?>
    <script src="<?=JS_DIR?>/index/jquery.index.js?ver=<?=date('ymdHis')?>"></script>
</head>
<body>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_submenu.tpl.php"); ?>
<div id="login_area"<?php if($login_status == 1) : ?> style="display: none;"<?php endif ?>>
    <div class="login_main_box">
        <h2>ログイン</h2>
        <form name="login_form" id="login_form" method="">
            <div class="input_area mb_10">
                <i class="fa fa-address-card" aria-hidden="true"></i><input type="text" name="user_id" id="user_id" maxlength="10" class="focus_controls validate[required,custom[onlyLetterNumber]]" placeholder="ユーザーID" data-focus-group="login_group" value="<?=($auto_logout)? $keep_user_id: ""?>">
            </div>
            <div class="input_area">
                <i class="fa fa-key" aria-hidden="true"></i><input type="password" name="password" id="password" maxlength="10" class="focus_controls validate[required]" placeholder="パスワード" data-focus-group="login_group" value="<?=($auto_logout)? $keep_user_password: ""?>">
            </div>

            <div class="btn_area clearfix">
                <label class="fl_left"><input type="checkbox" name="auto_login" id="auto_login" checked>次回から自動でログインする</label>
                <button type="button" class="focus_controls btn btn_login fl_right" data-focus-group="login_group"><i class="fa fa-sign-in" aria-hidden="true"></i>ログイン</button>
            </div>
        </form>

        <p class="forget ta_center mt_30"><!--<a href="#">ユーザーID・パスワードをお忘れの方</a>-->&nbsp;</p>

        <div class="caution_area"<?php if($status == "logout") : ?> style="display: block;"<?php endif;?>>
            <p class="logout_status"><?php if($auto_logout) : ?>一定時間操作が行われなかった為<br /><?php endif;?>ログアウトしました</p>
        </div>

        <p class="copyright fsm5 ta_center">Otsuka Warehouse Co., Ltd.</p>
    </div>
</div>


<!-- Responsive Menu End-->
<div class="wrapper">
    <header>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_header.tpl.php"); ?>
    </header>
    <article>
        <section id="top_navigation" class="box_container">
            <ul>
                <?php foreach($menu as $val):?>
                <li><a data-href="<?=URL?><?=$val["function_id"];?>/<?php echo ($val["params"]) ? "?".$val["params"]:"";?>" class="hover_txt"><div class="img_wrap hover_txt"><img src="<?=IMG_DIR?>/icon/<?=$val["icon_name"];?>" alt="<?=$val["menu_name"];?>"></div><?=$val["menu_name"];?></a></li>
                <?php endforeach;?>
            </ul>
        </section>
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
</body>
</html>
