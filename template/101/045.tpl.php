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
			<section class="input_area">
				<div class="input_area_title clearfix">
					<p class="fl_left">集計条件</p>
					<p class="fl_right"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
				</div>
				<form id="status_input_area">
					<div class="input_area_wrapper">
						<?php if(!$is_partner) :?>
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
						<?php endif;?>
						<dl class="input_area_inner">
							<dt>日付</dt>
							<dd>
								<div class="selection_text"><?=$date_conditions?></div>
							</dd>
						</dl>
                        <dl class="input_area_inner">
                            <dt>荷主</dt>
                            <dd>
                                <div id="selection_NNSICD_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
					</div>
				
				</form>
			</section>
		</div>
	
		<section id="over_btn" class="submit_btns">
			<div>
				<button type="button" class="btn btn_output btn_output_pdf"><i class="fa fa-file-pdf-o" aria-hidden="true"></i>印刷</button>
				<button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
			</div>
		</section>
	
		<section class="hidden_data">
            <form name="output_form">
                <input type="hidden" name="selections" value="<?=$selections?>">
            </form>
			<form name="output_form_pdf"></form>
		</section>
	
		<section class="box_container data_area">
			<div class="table_wrap">
				<table id="data_table" class="list_table">
					<thead>
						<tr>
							<th><?=$date_conditions_divide?></th>
							<th>納品先</th>
							<th>納品先住所</th>
							<th>備考</th>
							<th>荷主名</th>
							<th>ケース</th>
							<th>バラ</th>
							<th>重量</th>
						</tr>
					</thead>
					<tbody>
						<td colspan="8" class="no_data">対象データがありません</td>
					</tbody>
				</table>
			</div>
		</section>
		
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
    <script src="<?=JS_DIR?>/100/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
    <script src="<?=JS_DIR?>/101/jquery.045.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
