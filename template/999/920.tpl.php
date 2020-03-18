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

        <div class="box_container">
        <section class="input_area">
            <div class="input_area_title clearfix">
                <p class="fl_left">集計条件</p>
                <p class="fl_right"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
            </div>
            <div class="input_area_wrapper">
                <dl class="input_area_inner">
                    <dt>日付</dt>
                    <dd>
                        <input type="text" name="date_from" data-to-target="date_to" maxlength="10" data-default-value="<?=$def_data['date_from'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
                        <span class="fromto">～</span>
                        <input type="text" name="date_to" data-from-target="date_from" maxlength="10" data-default-value="<?=$def_data['date_to'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
                    </dd>
                </dl>
            </div>
            <div class="input_area_btn_area">
                <button type="button" class="btn btn_calc input_controls">集計</button>
            </div>
        </section>
        </div>

        <section id="over_btn" class="submit_btns">
            <div>
                <button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
            </div>
        </section>

        <section class="hidden_data">
            <form name="output_form">
                <input type="hidden" id="target_date_from" name="target_date_from" value="">
                <input type="hidden" id="target_date_to" name="target_date_to" value="">
            </form>

        </section>
		
        <section class="box_container data_area">
			<form id="update_table">
            <div class="table_wrap">
                <table id="data_table" class="list_table">
                    <thead>
                        <tr>
                            <th>ログイン日</th>
                            <th>ユーザーID</th>
                            <th>ユーザー名</th>
                            <th>デバイス</th>
							<th>ブラウザ</th>
                        </tr>
                    </thead>
                    <tbody>
                    
                    </tbody>
                </table>
            </div>
            
			</form>
        </section>





    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<script src="<?=JS_DIR?>/999/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/999/jquery.920.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
