        <div class="head_wrap">
            <div id="head_top" class="box_container">
                <h1>
                    <a data-href="<?=URL?>"><img src="<?=IMG_DIR?>/common/logo2.png" alt="<?=SITE_TITLE?>"></a>
                </h1>
            </div>
        </div>
		
		<div class="head_pankuzu_wrap box_container">
			<div class="pankuzu">
				
				<?php foreach ($page_parent as $val):?>
				<?php if($val === reset($page_parent)) : ?>
				<a data-href="<?=URL?>"><i class="fa fa-home" aria-hidden="true"></i>メインメニュー</a>
				<?php else : ?>
				<i class="fa fa-angle-right" aria-hidden="true"></i>
				<a data-href="<?=$val["url"]?>"><?=$val["name"]?></a>
				<?php endif; ?>
				
				<?php endforeach;?>
			</div>
	
			<div class="logins">
				<p class="login_name">
					<i class="fa fa-user-circle" aria-hidden="true"></i>
					<span>
					<?php echo ($user_name) ? $user_name . " でログイン中" : "ログインしてください";?>
					</span>
				</p>
	
				<p><a data-href="<?=URL?>logout.php"><i class="fa fa-sign-out" aria-hidden="true"></i>ログアウト</a></p>
			</div>
		</div>