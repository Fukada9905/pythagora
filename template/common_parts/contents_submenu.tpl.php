    <div id="progress_wrapper">
        <div aria-busy="true" aria-label="Loading" role="progressbar"></div>
    </div>

    <!-- Sub Menu Start-->
    <div class="sp_nav">
        <div class="sp_nav_btn">
            <div class="sp_nav_btn_bar sp_nav_btn_bar_top"></div>
            <div class="sp_nav_btn_bar sp_nav_btn_bar_middle"></div>
            <div class="sp_nav_btn_bar sp_nav_btn_bar_bottom"></div>
        </div>
    </div>
    <div class="responsive_menu_wrap"></div>
    <div class="responsive_menu">
        <div class="inner_menu">
            <div id="sub_menus">
            <?php if($sub_menu) : ?>
            <p class="menu_title">管理メニュー</p>
            <ul class="clearfix">
                <?php foreach($sub_menu as $key => $val):?>
                <li><a data-href="<?=URL?><?=$val["function_id"];?>/<?php echo ($val["params"]) ? "?".$val["params"]:"";?>"><i class="fa fa-angle-right" aria-hidden="true"></i><?=$val["menu_name"];?></a></li>
                <?php endforeach;?>
            </ul>
            <?php endif;?>
            </div>
            <p><a data-href="<?=URL?>"><i class="fa fa-bars" aria-hidden="true"></i>メインメニュー</a></p>
            <p><a data-href="<?=URL?>logout.php"><i class="fa fa-sign-out" aria-hidden="true"></i>ログアウト</a></p>

        </div>
    </div>
    <!-- Sub Menu End-->
