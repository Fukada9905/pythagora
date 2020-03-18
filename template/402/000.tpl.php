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
						<?php if(!$is_partner && !$is_partner_select) :?>
                        <dl class="input_area_inner">
                            <dt>事業所</dt>
                            <dd>
                                <div id="selection_JGSCD_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
						<?php endif; ?>
						<dl class="input_area_inner">
							<dt>日付</dt>
							<dd>
                                <label class="not_master"><input type="radio" name="date_divide" value="1" class="input_controls focus_controls" data-default-value="<?=$def_data['SYUKAYMD'];?>" <?=$def_data['SYUKAYMD'];?> data-focus-group="header_input">出荷日</label>
                                <label class="not_master"><input type="radio" name="date_divide" value="2" class="input_controls focus_controls" data-default-value="<?=$def_data['NOHINYMD'];?>" <?=$def_data['NOHINYMD'];?> data-focus-group="header_input">納品日</label>
                                <label class="not_master"><input type="radio" name="date_divide" value="3" class="input_controls focus_controls" data-default-value="<?=$def_data['DENPYOYMD'];?>" <?=$def_data['DENPYOYMD'];?> data-focus-group="header_input">伝票日付</label>
                                <label class="not_master"><input type="radio" name="date_divide" value="4" class="input_controls focus_controls" data-default-value="<?=$def_data['TORIKOMIYMD'];?>" <?=$def_data['TORIKOMIYMD'];?> data-focus-group="header_input">取込日</label>
								<input type="text" name="date_from" data-to-target="date_to" maxlength="10" data-default-value="<?=$def_data['date_from'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
								<span class="fromto">～</span>
								<input type="text" name="date_to" data-from-target="date_from" maxlength="10" data-default-value="<?=$def_data['date_to'];?>" class="input_from_to calendar_ui input_controls focus_controls" data-focus-group="header_input">
							</dd>
						</dl>
                        <dl class="input_area_inner">
                            <dt>運送形態</dt>
                            <dd>
                                <label><input type="checkbox" name="get_divide" value="1" class="input_controls focus_controls" data-default-value="<?=$def_data['HOKYU'];?>" <?=$def_data['HOKYU'];?> data-focus-group="header_input">補給</label>
                                <label><input type="checkbox" name="get_divide" value="2" class="input_controls focus_controls" data-default-value="<?=$def_data['KOUJO'];?>" <?=$def_data['KOUJO'];?> data-focus-group="header_input">工場直送</label>
                                <label><input type="checkbox" name="get_divide" value="3" class="input_controls focus_controls" data-default-value="<?=$def_data['TC'];?>" <?=$def_data['TC'];?> data-focus-group="header_input">TC幹線</label>
                                <label><input type="checkbox" name="get_divide" value="4" class="input_controls focus_controls" data-default-value="<?=$def_data['OROSHI'];?>" <?=$def_data['OROSHI'];?> data-focus-group="header_input">卸配送</label>
                            </dd>
                        </dl>
                        <dl class="input_area_inner not_master">
                            <dt>荷主</dt>
                            <dd>
                                <button type="button" class="btn btn_function" data-open-target="ninushi" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>荷主指定</button>
                                <div id="selection_NNSICD_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
                        <?php if(!$is_partner && $is_partner_select) :?>
                        <dl class="input_area_inner not_master">
                            <dt>運送業者</dt>
                            <dd>
                                <div id="selection_PTNCD_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
                        <?php elseif($is_partner):?>
                        <dl class="input_area_inner not_master">
                            <dt>運送業者</dt>
                            <dd>
                                <div class="selection_text"><?=$def_data['PTNINFO'];?></div>
                            </dd>
                        </dl>
                        <?php else:?>
                        <dl class="input_area_inner not_master">
                            <dt>運送業者</dt>
                            <dd>
                                <button type="button" class="btn btn_function" data-open-target="sub_partner" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>業者指定</button>
                                <div id="selection_SUBPTNCD_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
                        <?php endif;?>
                        <dl class="input_area_inner only_master">
                            <dt>運送業者(TC幹線)</dt>
                            <dd>
                                <button type="button" class="btn btn_function" data-open-target="root_partner3" data-is-noset="true"><i class="fa fa-arrow-circle-right" aria-hidden="true"></i>業者指定</button>
                                <div id="selection_ROOTPT3_text" class="selection_text">指定なし</div>
                            </dd>
                        </dl>
					</div>
					<div class="input_area_btn_area">
						<button type="button" class="btn btn_calc input_controls">集計</button>
					</div>
				</form>
			</section>
		</div>

        <section id="over_btn" class="submit_btns">
            <div>
                <button type="button" class="btn btn_output btn_output_csv"><i class="fa fa-file-code-o" aria-hidden="true"></i>DL</button>
                <button type="button" class="btn btn_output btn_output_pdf"><i class="fa fa-file-code-o" aria-hidden="true"></i>印刷</button>
                <button type="button" class="btn btn_output btn_entry">車番確認</button>
            </div>
        </section>

		
		<section class="progress_area">
			<div class="box_container ta_right">
				<span class="already_progress">0</span>件選択中 / 計<span class="total_progress">0</span>件
			</div>
		</section>
		
		<section class="box_container data_area">
			<div class="table_wrap">
				<table id="data_table" class="list_table">
					<thead>
						<tr>
							<th>荷主<div class="sort_btn on_sort" data-target-trigger="shipper_code" data-sort-order="DESC"><i class="fa fa-caret-down" aria-hidden="true"></i></div></th>
							<th>運送業者<div class="sort_btn" data-target-trigger="transporter_code" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
							<th>伝票番号<div class="sort_btn" data-target-trigger="slip_number" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
							<th>積地センター<div class="sort_btn" data-target-trigger="warehouse_code" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
                            <th>納品先<div class="sort_btn" data-target-trigger="delivery_code" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
                            <th>
                                <div class="th_wrap">ケース<div class="sort_btn" data-target-trigger="package_count" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></div>
                                <div class="th_wrap">バラ<div class="sort_btn" data-target-trigger="fraction" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></div>
                            </th>
                            <th>重量<div class="sort_btn" data-target-trigger="shipping_weight" data-sort-order="ASC"><i class="fa fa-caret-up" aria-hidden="true"></i></div></th>
							<th>選択<div class="check_wrap"><input type="checkbox" name="all_checks" checked></div></th>
						</tr>
					</thead>
					<tbody>
						<td colspan="9" class="no_data">対象データがありません</td>
					</tbody>
				</table>
			</div>
		</section>
	
		<section class="hidden_data">
            <div id="hidden_get_divide"></div>
			<form name="output_form_pdf">
				<input type="hidden" id="pdf_work_id" name="work_id" value="">
                <input type="hidden" id="pdf_get_divide" name="get_divide" value="">
			</form>
            <form name="output_form_csv">
                <input type="hidden" id="csv_work_id" name="work_id" value="">
                <input type="hidden" id="csv_get_divide" name="get_divide" value="">
            </form>
		</section>
		
    </article>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_footer.tpl.php"); ?>
</div>
<?php require_once(TEMPLATE_DIR . DS . "common_parts/contents_overray.tpl.php"); ?>
<div id="over_ray_tables">
	
	<div class="over_ray_inner">
		
		<h3>車番確認</h3>

		<div class="close_btn_wrap">
			<div class="close_btn">
				<div class="close_btn_bar close_btn_bar_top"></div>
				<div class="close_btn_bar close_btn_bar_bottom"></div>
			</div>
		</div>
		<div class="table_wrap other_table">
            <div class="shaban_input_wrap">
                <div class="shaban_midashi_wrap">
                    <div class="shaban_midashi_title">
                        <h4>1件目 伝票番号／692420　KK(飲料)</h4>
                        <p class="mark"><i class="fa fa-arrow-circle-up" aria-hidden="true"></i></p>
                    </div>
                    <div class="shaban_midashi_conditions">
                        <dl class="input_area_inner">
                            <dt>出荷日</dt>
                            <dd><div class="selection_text">2019/03/22</div></dd>
                            <dt class="second_title">納品日</dt>
                            <dd><div class="selection_text">2019/03/22</div></dd>
                        </dl>
                        <dl class="input_area_inner">
                            <dt>積地</dt>
                            <dd><div class="selection_text">213　高崎第３</div></dd>
                        </dl>
                        <dl class="input_area_inner">
                            <dt>着地</dt>
                            <dd><div class="selection_text">010400　大塚倉庫（株）　東京支店首都圏中央センター 　千葉県浦安市千鳥１１番地1</div></dd>
                        </dl>
                    </div>
                </div>
                <div class="table_area">
                    <table class="list_table">
                        <thead>
                            <tr>
                                <th width="10">No</th>
                                <th width="250">運送会社</th>
                                <th width="100">車番</th>
                                <th width="90">機材</th>
                                <th width="90">乗務員</th>
                                <th width="130">携帯番号</th>
                                <th>備考</th>
                                <th>削除</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="ta_center">1</td>
                                <td>
                                    <input name="transporter_name" type="text" maxlength="30" value="ハイエスサービス" class="max_input">
                                </td>
                                <td>
                                    <input name="shaban" type="text" maxlength="30" value="12-12" size="8">
                                </td>
                                <td>
                                    <input name="kizai" type="text" maxlength="30" value="13tW" size="6">
                                </td>
                                <td>
                                    <input name="jomuin" type="text" maxlength="30" value="鈴木" size="6">
                                </td>
                                <td>
                                    <input name="tel" type="text" maxlength="30" value="080-0000-0000" size="11">
                                </td>
                                <td>
                                    <textarea name="remarks" class="max_input">
                                        積込9時～11時に入場予定
                                        ※10PLのみ積載/他荷物と混載します
                                    </textarea>
                                </td>
                                <td class="delete_btn_col">
                                    <button type="button" class="btn btn_delete" data-target-id="'+val.work_id+'"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i>削除</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="add_btn_wrap">
                    <p class="btn_add"><i class="fa fa-plus-circle hover_txt" aria-hidden="true"></i></p>
                </div>

            </div>


		</div>
	</div>
</div>
<script src="<?=JS_DIR?>/400/jquery.common.js?ver=<?=date('ymdHis')?>"></script>
<script src="<?=JS_DIR?>/402/jquery.000.js?ver=<?=date('ymdHis')?>"></script>
</body>
</html>
