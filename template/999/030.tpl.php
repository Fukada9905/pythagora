<!DOCTYPE html>
<html lang="ja">
<head>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_meta.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_css.tpl.php"); ?>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/head_js.tpl.php"); ?>
</head>

<body>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_submenu.tpl.php"); ?>

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

		
				
        <section class="master_headers">
			<div class="box_container clearfix">
				<div class="refine">
					<dl>
						<dt>絞り込み</dt>
						<dd>
							パートナーコード :
							<select class="refine" name="divide_conditions">
								<option value="" selected>指定なし</option>
								<?php foreach ($divide_data as $row) : ?>
									<option value="<?=$row["PTNCD"]?>"><?=$row["PTNNM"]?></option>
								<?php endforeach;?>
							</select>
						</dd>
					</dl>
				</div>
				<div class="submit_btns">
					<div>
						<button type="button" class="btn btn_execute"><i class="fa fa-check" aria-hidden="true"></i>保存</button>
						<button type="button" class="btn btn_clear"><i class="fa fa-eraser" aria-hidden="true"></i>クリア</button>
					</div>
				</div>
			</div>
        </section>
		
        <section class="box_container data_area">
			<form id="update_table">
            <div class="table_wrap">
                <table id="data_table" class="list_table">
                    <thead>
                        <tr>
                            <th>パートナーコード</th>
                            <th>荷主コード</th>
							<th>事業所コード</th>
							<th>センターコード</th>
							<th>運送会社コード</th>
							<th>出荷場所コード</th>
							<th>請求区分</th>
							<th>納品先コード</th>
							<th>入荷対象フラグ</th>
							<th>出荷対象フラグ</th>
							<th>在庫対象フラグ</th>
                            <th>削除</th>
                        </tr>
                    </thead>
                    <tbody>
                    
                    </tbody>
                </table>
            </div>
            
            <div class="master_add_btn">
                <p class="btn_add"><i class="fa fa-plus-circle hover_txt" aria-hidden="true"></i></p>
            </div>
			</form>
        </section>





    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<script src="<?=JS_DIR?>/999/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/999/jquery.030.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
