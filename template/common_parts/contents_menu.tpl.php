		<section id="top_navigation" class="box_container">
			<ul>
			<?php foreach($menu as $val):?>
			<?php if(($is_partner_select && $val["function_divide"] != "2") || (!$is_partner_select && $val["function_divide"] != "3")) : ?>
				<li><a data-href="<?=URL?><?=$val["function_id"];?>/<?php echo ($val["params"]) ? "?".$val["params"]:"";?>" class="hover_txt function_menu"><div class="img_wrap"><img src="<?=IMG_DIR?>/icon/<?=$val["icon_name"];?>" alt="<?=$val["menu_name"];?>"></div><?=$val["menu_name"];?></a></li>
			<?php endif;?>
			<?php endforeach;?>
			</ul>
		</section>
