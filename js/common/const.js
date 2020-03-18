//Jquery Object Names
var OBJ_PROGRESS = "#progress_wrapper";

var BTN_EXECUTE = "button.btn_execute";
var BTN_CLEAR = "button.btn_clear";
var BTN_CALC = "button.btn_calc";
var BTN_SEND = "button.btn_send";
var BTN_OUTPUT = "button.btn_output";
var BTN_OUTPUT_PDF = "button.btn_output_pdf";
var BTN_OUTPUT_CSV = "button.btn_output_csv";

var OBJ_INPUT_AREA = "#status_input_area";
var OBJ_INPUT_CONTROLS = ".input_controls";
var OBJ_INPUT_FROMTO = ".input_from_to";

var OBJ_LIST_TABLE = ".list_table tbody";
var OBJ_UPDATE_TABLE = "#update_table";

var OBJ_FOCUS_CONTROLS = ".focus_controls";


//Message
var MSG_NO_DATA_TITLE = "集計結果";
var MSG_NO_DATA = "対象データが存在しません";
var MSG_CANCEL_TITLE = "クリア確認";
var MSG_CANCEL = "入力中の内容はクリアされます。よろしいですか？";
var MSG_NO_CHANGE_TITLE = "入力確認";
var MSG_NO_CHANGE = "登録情報または、変更情報はありません";
var MSG_EXECUTE_TITLE = "登録確認";
var MSG_EXECUTE = "を実行します。よろしいですか？";
var MSG_COMPLETE_TITLE = "登録完了";
var MSG_COMPLETE = "を実行します。よろしいですか？";
var MSG_ERROR_TITLE = "処理中断";
var MSG_ERROR = "エラーが発生しました。<br>管理者にお問い合わせください。";
var MSG_ERROR_NETWORK = "ネットワークエラーが発生しました。<br>ネットワーク状況を確認し、<br>しばらくたってから再度操作を行ってください";


//ajax_status&params !!!!must equals PHP const values!!!!
var AJAX_HOST = window.location.protocol + '//' + window.location.hostname + '/class/ajax/controller.php';
var URL = window.location.protocol + '//' + window.location.hostname + '/';
var IMG_DIR = URL + 'img/';

var STATUS_OK = 'OK';
var STATUS_ERROR = 'ERROR';
var STATUS_NO_DATA = 'NO_DATA';
var STATUS_NG_USER = 'NG_USER';
var STATUS_NG_PASS = 'NG_PASS';
var STATUS_NO_PROCESS = 'NO_PROCESS';
var STATUS_OTHER_LOGIN = 'OTHER_LOGIN';


//LOCAL STORAGE KEY
var LS_JIGYOSHO = 'JIGYOSHO_SELECT';
var LS_NINUSHI = 'NINUSHI_SELECT';
var LS_CENTER = 'CENTER_SELECT';
var LS_PARTNER = 'PARTNER_SELECT';
var LS_SUB_PARTNER = 'SUB_PARTNER_SELECT';
var LS_ROOTPT1 = 'ROOT_PARTNER_SELECT1';
var LS_ROOTPT2 = 'ROOT_PARTNER_SELECT2';
var LS_ROOTPT3 = 'ROOT_PARTNER_SELECT3';


var LS_PROCESS_DIVIDE = 'PROCESS_DIVIDE';