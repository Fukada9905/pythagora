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
                <section class="input_area">
                    <div class="input_area_title clearfix">
                        <p class="fl_left">絞り込み</p>
                        <p class="fl_right"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
                    </div>
                    <form id="status_input_area">
                        <div class="input_area_wrapper">
                            <dl class="input_area_inner">
                                <dt>事業所</dt>
                                <dd>
                                    <select class="refine" name="jgscd">
                                        <option value="" selected>指定なし</option>
                                        <?php foreach ($divide_data1 as $row) : ?>
                                            <option value="<?=$row["JGSCD"]?>"><?=$row["JGSNM"]?></option>
                                        <?php endforeach;?>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="input_area_inner">
                                <dt>積地PTコード</dt>
                                <dd>
                                    <select class="refine" name="tmcptncd">
                                        <option value="" selected>指定なし</option>
                                        <?php foreach ($divide_data2 as $row) : ?>
                                            <option value="<?=$row["PTNCD"]?>"><?=$row["PTNNM"]?></option>
                                        <?php endforeach;?>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="input_area_inner">
                                <dt>着地PTコード</dt>
                                <dd>
                                    <select class="refine" name="ckcptncd">
                                        <option value="" selected>指定なし</option>
                                        <?php foreach ($divide_data3 as $row) : ?>
                                            <option value="<?=$row["PTNCD"]?>"><?=$row["PTNNM"]?></option>
                                        <?php endforeach;?>
                                    </select>
                                </dd>
                            </dl>
                            <dl class="input_area_inner">
                                <dt>運送会社PTコード</dt>
                                <dd>
                                    <select class="refine" name="unsksptncd">
                                        <option value="" selected>指定なし</option>
                                        <?php foreach ($divide_data4 as $row) : ?>
                                            <option value="<?=$row["PTNCD"]?>"><?=$row["PTNNM"]?></option>
                                        <?php endforeach;?>
                                    </select>
                                </dd>
                            </dl>
                        </div>
                    </form>
                </section>
			</div>
        </section>

        <section id="over_btn" class="submit_btns">
            <div>
                <button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
                <button type="button" class="btn btn_execute"><i class="fa fa-check" aria-hidden="true"></i>保存</button>
                <button type="button" class="btn btn_clear"><i class="fa fa-eraser" aria-hidden="true"></i>クリア</button>
            </div>
        </section>
		
        <section class="box_container data_area">
			<form id="update_table">
            <div class="table_wrap">
                <table id="data_table" class="list_table">
                    <thead>
                        <tr>
                            <th>事業所</th>
                            <th>積地PTコード</th>
                            <th>積地名称<br>住所</th>
                            <th>着地PTコード</th>
                            <th>着地名称<br>住所</th>
                            <th>運送会社PTコード</th>
                            <th>運送会社名称</th>
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
	
		<section class="hidden_data">
			<form name="output_form">
				<input type="hidden" id="params_jgscd" name="params_jgscd" value="">
                <input type="hidden" id="params_tmcptncd" name="params_tmcptncd" value="">
                <input type="hidden" id="params_ckcptncd" name="params_ckcptncd" value="">
                <input type="hidden" id="params_unsksptncd" name="params_unsksptncd" value="">
			</form>
		</section>


    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<script src="<?=JS_DIR?>/999/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/999/jquery.040.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
