//main form value set
function setMainFormData(id, healthYn) {
	$('#mainForm>input[name="insSsn"]').val($('[name="birthday"]').val());
	$('#mainForm>input[name="insSex"]').val(
			$('input:radio[name="gender02"]:checked').val());
	$('#mainForm>input[name="insAge"]').val(
			getInsAge($('[name="birthday"]').val()));
	$('#mainForm>input[name="insManAge"]').val(
			getManAge($('[name="birthday"]').val()));
	$('#mainForm>input[name="napgiCode"]').val(
			$('input:radio[name="payment"]:checked').val());
	$('#mainForm>input[name="bogiCode"]').val(
			$('input:radio[name="bogi"]:checked').val());
	if(id == 'tab-save'){//저축보험
		$('#mainForm>input[name="bjCode"]').val('ck1');
		$('#mainForm>input[name="u0"]').val(getMonthBill());
		$('#mainForm>input[name="napgi"]').val(getNapgi());
		$('#mainForm>input[name="bogi"]').val(getBogi());
		$('#mainForm>input[name="healthYn"]').val(healthYn);
	}
	else{//정기보험
		//공통으로 뽑을 수 있음. : insSsn, insSex, insAge, insManAge, napgiCode, bogiCode
		$('#mainForm>input[name="bjCode"]').val($('input:radio[name="insType"]:checked').val());
		$('#mainForm>input[name="u0"]').val(getInsJoinM());
		$('#mainForm>input[name="healthYn"]').val(healthYn);
	}
};

// -- validation function start
function valCommonInfo() {
	if ($('[name="birthday"]').val() == '') {
		alert('생년월일을 입력해 주세요.');
		$('[name="birthday"]').focus();
		return false;
	}
	if (/^\d{6}$/.test($('[name="birthday"]').val()) == false) {
		alert('생년월일은 YYMMDD의 6자리로 입력하여 주십시오.');
		$('[name="birthday"]').focus();
		return false;
	}
	if(birthChecking($('[name="birthday"]').val()) == false){
		alert('생년월일을 올바르게 입력하여 주십시오.');
		$('[name="birthday"]').focus();
		return false;
	}
	if($('input:radio[name="gender02"]:checked').val() == undefined){
		alert('성별을 선택해 주세요.');
		$('input:radio[name="gender02"]').eq(0).focus();
		return false
	}
	else {
		return true;
	}
};

function insValidate(jumin, flag){
	if(flag == 'tab-save'){//저축보험
		if(getManAge(jumin) < 19 || getInsAge(jumin) > 69) {
			alert('만 19세 ~ 69세까지 가입할 수 있습니다');
			$('[name="birthday"]').val('');
			$('[name="birthday"]').focus();
			return false;
		}
		else return true;
	}
	else{//정기보험
		if(getManAge(jumin) < 19 || getInsAge(jumin) > 70) {
			alert('만 19세 ~ 70세까지 가입할 수 있습니다');
			$('[name="birthday"]').val('');		
			$('[name="birthday"]').focus();
			return false;
		}
		else return true;
	}
};

function validate(id){
	if(id == 'tab-save'){
		if(valCommonInfo() == true && valiSave() == true){
			return true;
		}
		else return false;
	}
	else{
		if(valCommonInfo() == true && valiTerm() == true){
			return true;
		}
		else return false;
	}
}
// -- validation function end

// -- mode function start
function getCancelData(mode){
	if(mode == 'exmtbl2'){
		select_health('normal');
	}
	layer_popup('#refund_'+mode);
};

function select_health(mode){
	//일반, 건강고객 예시표 모두 숨기기
	$('#refund_exmtbl2 a').removeClass("selected").addClass("deselect");
	$('#refund_exmtbl2 table').hide();
	
	//일반, 건강 mode에 따라 테이블 표시
	$('#'+mode+'_table').show();
	$('.'+mode).removeClass("deselect").addClass("selected");
};
// -- mode function end

// -- button function start
//계산하기 버튼 눌렀을 때(저축보험, 정기보험 분기하여 데이터 가져옴.)
function fn_calc(){
	//선택된 보험으로 계산하고자 하는 데이터를 form에 삽입
	var id = $('.calc_this').attr("id");
	//세션에 탭id값으로 .cal로 접근가능한 객체를 json stringify하여 저장함.
	//var storageData = $('.cal').serializeFormJSON();
	//sessionStorage.setItem(id, storageData);
	
	if(validate(id)){
		if(id == 'tab-save'){
			setMainFormData(id,'Y');
			fn_submit(id);
		}
		else{
			setMainFormData(id,'N');
			fn_submit(id);
		}
	}
};

//다시계산 버튼 클릭시 작동, 생년월일까지 초기화 시키고 싶었으나 작동 안됨.
function fn_reset(){
	$('#minResult').hide();
	$('.calc_this :input').each(function(){
		$(this).find('[type="text"]').empty();
		if($(this).attr("type") == 'number'){
			$(this).val('');
			$(this).parent().hide();
		}
		$(this).prop("checked",false);
		clearSpanData($(this).attr("name"));
	});
	$('#reCalTxt :input').each(function(){
		$(this).val('');
	});
};
// -- button function end

function ajaxCalSetup(id, goUrl, params){
	$.ajax({
		url : goUrl,
		accepts : {
			text : 'application/json'
		},
		type : 'post',
		data : params,
		dataType : 'json',
		success : function callbackFn(response){
			if (response.serverSideSuccessYn == 'Y') {
				if(goUrl.indexOf("Result") != -1){
					//결과페이지 display				
					display(response.result.jsonData, id);
					$('#mainForm>[name="sskey"]').val(
							response.result.jsonData.new_sskey);
				}
				else{
					//해지환급금
					if(id == 'tab-save'){
						displayTerminateData(response.result.jsonData, id);
					}
					else displayTerminateData(response.result, id);
				}
			}
		},
		error : function(xhr, status, error) {
			console.log("에러 : " + error + "상태 : " + status);
		}
	});	
};

// -- layer function start
//레이어팝업 가운데정렬(가로-세로)
jQuery.fn.center = function () {
	this.css("position","absolute");
	this.css("top", Math.max(0, (($(window).height() - $(this).outerHeight()) / 2) +
	$(window).scrollTop()) + "px");
	this.css("left", Math.max(0, (($(window).width() - $(this).outerWidth()) / 2) +
	$(window).scrollLeft()) + "px");
	return this;
};

//레이어팝업 on/off 용 함수
function layer_popup(el){
	var $el = $(el);        //레이어의 id를 $el 변수에 저장
	$el.center();
	
	$('#mask').css({
			"width":$(window).width(),
			"height":$(document).height()
	});
	$('#mask').addClass("cnntSel").fadeTo("slow",0.8);
	
    $el.find('a.btn-layerClose').click(function(){
		$el.fadeOut('fast'); // 닫기 버튼을 클릭하면 레이어가 닫힌다.
		$('#mask').hide();		
		$el.scrollTop(0);
		return false;
    });
	$el.show();
};
// -- layer function end

//sessionStorage에 json스트링 타입으로 저장하기 위한 함수
$.fn.serializeFormJSON = function () {
  var o = {};
  var a = this.serializeArray();
  $.each(a, function () {
      if (o[this.name]) {
          if (!o[this.name].push) {
              o[this.name] = [o[this.name]];
          }
          o[this.name].push(this.value || '');
      } else {
          o[this.name] = this.value || '';
      }
  });
  return JSON.stringify(o);
};

var toggle = true;

function computeDetailOp(mode){
	if($('.'+mode).hasClass(mode) && toggle){
		menuChoice(mode);
	}
	else{
		confirmChoice(mode);
	}
};

function menuChoice(mode){
	$('#'+mode+'_li').show();
	toggle = false;
}

function confirmChoice(mode){
	$('#'+mode+'_li').hide();
	toggle = true;
};

function clearSpanData(mode){
	$('#'+mode).text('');
};