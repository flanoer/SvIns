<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>온슈어 정기보험 계산기</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script type="text/javascript">

$(document).ready(function(){
	
	$("#insType_choice_title_li").hide();
	$('#insJoinM_choice_title_li').hide();		
	$('#bogi_choice_title_li').hide();
	$('#payment_choice_title_li').hide();
	
	$('#birthday').keyup(function(){
		if(parseInt($(this).val().length) < 3){
			$('#insType_choice_detail').hide();
			$('input:radio[name="insType"]:checked').prop('checked',false);
			$('#insJoinM_choice_detail').hide();
			$('input:radio[name="insJoinM"]:checked').prop('checked',false);
			$('#insJoinM_custom').hide();
			$('input:radio[name="insJoinM_custom"]').val('');
			$('#bogi_choice_title_li').hide();
			$('input:radio[name="bogi"]:checked').prop('checked',false);
			$('#payment_choice_title_li').hide();
			$('input:radio[name="payment"]:checked').prop('checked',false);
			return false;
		}
		
	});

	//생년월일, 성별 선택했을 때
	$('input:radio[name="gender02"]').on('click',function(){
		if(parseInt($('#birthday').val().length) > 5){
			$("#insType_choice_title_li").show();
			
		}
	});
	
	//숫자만 입력
	$('#birthday, #insJoinMTxt').keydown(function(e) {
		var evt = e || window.event;
		if((evt.keyCode >= 65 && evt.keyCode <= 90) || (evt.keyCode >= 186 && evt.keyCode <= 222) || (evt.keyCode >= 106 && evt.keyCode <= 111)) {
			event.returnValue = false;
		} else {
			return;
		}
	});	
	
	//보험조건 선택시
	$('input:radio[name="insType"]').click(function(){
		
		//추천조건 설계하기 선택 초기화
		$('#pro_check01').prop('checked', false);
		
		var insType = $('input:radio[name="insType"]:checked').val();
		
		$('#insJoinM_choice_title_li').show();

		setInsType(insType);
		//보험가입금액 초기화
		setInsJoinM(null);
		//보험기간 초기화
		//setBogi(null);
		//납입기간 초기화
		//setPayment(null);
		
		confirmMenu("insType");
	});
	
	// 보험가입금액 선택시
	$('input:radio[name="insJoinM"]').click(function () {
		//추천조건 설계하기 선택 초기화
		$('#pro_check01').prop('checked', false);
		
		var insJoinM=$('input:radio[name="insJoinM"]:checked').val();
		var insJoinMTxt=$('#insJoinMTxt').val();
		
		if(insJoinM=="-1") {  //직접입력인경우			
			if( insJoinMTxt === 'undefined' || insJoinMTxt == '') {	//직접입력인데 값을 안넣은 경우
				setInsJoinM("-1");
			} else {
				setInsJoinM( Number(insJoinMTxt)/10 );
			}			
		} else {			
			setInsJoinM(insJoinM );
		}
		
		//보험기간 초기화
		//setBogi(null);
		//납입기간 초기화
		//setPayment(null);
		
		//확인버튼 삭제로 인한 추가 hwo
		if(insJoinM!="-1"){
			confirmMenu('insJoinM');
		}
	});
	
	
	$('#mainForm>[name="healthYn"]').val("N");	
	$('#mainForm>[name="sskey"]').val(''); //조건이 바뀌면 sskey 초기화		
});

//계산항목 클릭 시
function computeDetailOp(id){
	if(tabValChk(id)==false){
		return;
	}else{
		if($('#'+id+"_choice_title").hasClass("on")){					
			console.log('1');
			confirmMenu(id);
		}else{
			console.log('2');
			focusMenu(id);
		}		
	}
}

//계산항목 단계별 조건 확인
function tabValChk(id){
	if($('#birthday').val() == ''){
		alert("생년월일을 입력하여 주세요.");
		$('#birthday').focus();
		return false;
	}
	if(/^\d{6}$/.test($('#birthday').val()) == false) {
		alert('생년월일은 YYMMDD의 6자리로 입력하여 주십시오.');
		$('#birthday').focus();				
		return false;
	}
	if($('input:radio[name="gender02"]:checked').val() == undefined) {				
		alert('성별을 입력해 주세요.');
		$('input:radio[name="gender02"]').eq(0).focus();
		return false;
	}
	if(id == "insJoinM"){
		if($('#insType_txt').text() == '') {
			alert('보험종류를 선택해 주세요.');
			focusMenu('insType'); //확인
			return false;
		}
	}else if(id == "bogi"){
		if($('#insType_txt').text() == '') {
			alert('보험종류를 선택해 주세요.');
			focusMenu('insType');
			return false;
		}
		if($('#insJoinM_txt').text() == '') {
			alert('보험가입금액을 선택해 주세요.');
			focusMenu('insJoinM');
			return false;
		}				
	}else if(id == "payment"){
		if($('#insType_txt').text() == '') {
			alert('보험종류를 선택해 주세요.');
			focusMenu('insType');
			return false;
		}
		if($('#insJoinM_txt').text() == '') {
			alert('보험가입금액을 선택해 주세요.');
			focusMenu('insJoinM');
			return false;
		}
		if($('#bogi_txt').text() == '') {
			alert('보험기간을 선택해 주세요.');
			focusMenu('bogi');
			return false;
		}
	}else{
		return true;
	}
}


//mainform value set
function setMainFormData() {
	//데이터를 정제하여 폼에 넣는다.
	$('#mainForm>input[name="bjCode"]').val($('input:radio[name="insType"]:checked').val());
	$('#mainForm>input[name="insSsn"]').val($('[name="birthday"]').val());
	$('#mainForm>input[name="insSex"]').val($('input:radio[name="gender02"]:checked').val());
	$('#mainForm>input[name="insAge"]').val(getInsAge($('[name="birthday"]').val()));
	$('#mainForm>input[name="insManAge"]').val(getManAge($('[name="birthday"]').val()));
	$('#mainForm>input[name="u0"]').val(getInsJoinM());
	$('#mainForm>input[name="bogiCode"]').val($('input:radio[name="bogi"]:checked').val());
	$('#mainForm>input[name="napgiCode"]').val($('input:radio[name="payment"]:checked').val());
}	

//계산서버 호출하여 가입설계서 정보를 조회한다. (확인필요)
function readData() {
	setMainFormData();
	
	//데이터 조회
	$.ajax({
		type: 'POST',
		accepts: {
			text: 'application/json'
		},
		url: '/m/contract/getTermInfo.do',
		data: $('#mainForm').serialize(),
		async: true,
		dataType: 'json',
		success: function(response) {
			if(response.serverSideSuccessYn == 'Y') {
				if (response.result.jsonData.errorCode == 'TERM3000LT') {
					
					no_result_none();
					$("#mainPrem").val('');
					
				} else {
					
					no_result_block();
					
					//결과페이지 display				
					display(response.result.jsonData);
					//연금예시액 및 해지환급금 display
					//displayPopup(response.result.jsonData, response.result.surDataMatrix);
									
					$("#mainPrem").val(response.result.jsonData.mainPrem);
					$('#mainForm>[name="sskey"]').val(response.result.jsonData.new_sskey);
					
				}
				
			} 									
		}
	});
}

//보험종류 값설정
function setInsType(val) {
	$('input:radio[name="insType"]').each(function() {
		$(this).prop('checked', false);			
	});						
	$('#insType_txt').text('');
	if(val) {
		switch(val) {
			case 'ck1':
				$('#it1').prop('checked', true);					
				$('#insType_txt').text('순수보장형');
				return "ok";
				break;
			case 'ck2':
				$('#it2').prop('checked', true);					
				$('#insType_txt').text('50%환급형');
				return "ok";
				break;				
			case 'ck3':
				$('#it3').prop('checked', true);					
				$('#insType_txt').text('100%환급형');
				return "ok";
				break;
		}
	} 		
}

//보험가입금액 설정
function setInsJoinM(val) {
	$('input:radio[name="insJoinM"]').each(function() {
		$(this).prop('checked', false);				
	})			
	
	$('#insJoinM_txt').text('');
	$('#insJoinM_custom').hide();

	if(val) {			
		switch(val) {
			case '0.5':								
				$('#insJoinM_05').prop('checked', true);				
				$('#insJoinM_txt').text('5천만원');			
				return "ok";
				break;
			case '1':
				$('#insJoinM_1').prop('checked', true);
				$('#insJoinM_txt').text('1억원');			
				return "ok";
				break;
			case '2':
				$('#insJoinM_2').prop('checked', true);
				$('#insJoinM_txt').text('2억원');			
				return "ok";
				break;
			default:
				$('#insJoinM_M1').prop('checked', true);				
				
				$('#insJoinM_custom').show();		
				
				if(val=='-1') {	//직접입력인데 값을 넣지 않은경우
					$('#insJoinM_txt').text("직접입력");
				} else {
					$('#insJoinMTxt').val( Number(val)*10 );
					var numval = String(Number(	val )).split('.');
					var ukval =''+( numval[0] == '0' ? '' : (numval[0] + '억') );
					var chunval = typeof(numval[1]) == 'undefined' ? '' : (numval[1] + '천만원');									
					$('#insJoinM_txt').text(ukval + chunval);		
					return "ok";
				}					
				break;
		}
	} else {
		$('#insJoinMTxt').val('');
	}
}

function clearTermData(){

	//보험종류 초기화
	setInsType(null);
	//보험가입금액 초기화
	setInsJoinM(null);
	//보험기간 초기화
	setBogi(null);
	//납입기간 초기화
	setPayment(null);
	
	$("#sskey").val("");
	$("#jumpStep").val("");
		
}

//계산항목 관련 포커스 이동
function focusMenu(id){
	computeTermChgLi('hide');	
	$("#"+id+"_choice_title_li").show();				
		
	computeTermChgClass('remove');					
	$("#"+id+"_choice_title").addClass("on");
	
	computeTermChgDetail('hide');		
	$("#"+id+"_choice_detail").show();
}

//자녀연금 관련 li 세팅
function computeTermChgLi(type){
	if(type=='show'){
		$('#insType_choice_title_li').show();
		$('#insJoinM_choice_title_li').show();		
		$('#bogi_choice_title_li').show();
		$('#payment_choice_title_li').show();
	}else{
		$('#insType_choice_title_li').hide();
		$('#insJoinM_choice_title_li').hide();		
		$('#bogi_choice_title_li').hide();
		$('#payment_choice_title_li').hide();
	}
}

//자녀연금 관련 class 세팅
function computeTermChgClass(type){
	if(type=="add"){
		$("#insType_choice_title").addClass("on");
		$("#insJoinM_choice_title").addClass("on");		
		$("#bogi_choice_title").addClass("on");
		$("#payment_choice_title").addClass("on");
	}else{
		$("#insType_choice_title").removeClass("on");
		$("#insJoinM_choice_title").removeClass("on");		
		$("#bogi_choice_title").removeClass("on");
		$("#payment_choice_title").removeClass("on");
	}
}

//자녀연금 과련 항목리스트 세팅
function computeTermChgDetail(type){
	if(type=="show"){
		$('#insType_choice_detail').show();
		$('#insJoinM_choice_detail').show();		
		$('#bogi_choice_detail').show();
		$('#payment_choice_detail').show();
	}else{
		$('#insType_choice_detail').hide();
		$('#insJoinM_choice_detail').hide();		
		$('#bogi_choice_detail').hide();
		$('#payment_choice_detail').hide();
	}
}

//확인 버튼 클릭 시
function confirmMenu(id){
	
	computeTermChgLi('show');
	$("#"+id+"_choice_title").removeClass("on");
	$("#"+id+"_choice_detail").hide();
	
	$('#btn_calculator').show();
}
</script>
</head>
<body>
<form id="mainForm" method="post">
	<input type="hidden" name="bj"/><!-- 보종코드 -->
	<input type="hidden" name="bjCode"/><!-- 보종코드 -->
	<input type="hidden" name="insSsn"/><!-- 주민번호 -->
	<input type="hidden" name="insSex"/><!-- 성별 -->
	<input type="hidden" name="insAge"/><!-- 나이 -->
	<input type="hidden" name="insManAge"/><!-- 만나이 -->
	<input type="hidden" name="u0"/><!-- 가입금액(가입한도) -->
	<input type="hidden" name="bogiCode"/><!-- 보험기간 -->
	<input type="hidden" name="napgiCode"/><!--납입기간  -->
	<input type="hidden" name="healthYn"/><!-- 건강고객 -->
	<input type="hidden" name="insuCode" value="CM090101"/><!-- 상품코드 -->
	<input type="hidden" name="step"/><!-- 팝업ID -->
	<input type="hidden" name="napgi"/><!-- 납입기간 -->
	<input type="hidden" name="yonAge"/><!-- 연금개시나이 -->
	<input type="hidden" name="sendUrlChk" value="C"/>
	<input type="hidden" name="sskey" id="sskey" value=""/>
	<input type="hidden" id="jumpStep" name="jumpStep" value="" />
	<input type="hidden" id="applyType" name="applyType" value="M" />
</form>
<fieldset>
	<legend style="font-size:2em"><strong>정기보험</strong></legend>
	<ul style="list-style-type: none;">
		<li>
			생&nbsp;&nbsp;년&nbsp;&nbsp;월&nbsp;&nbsp;일 : 
			<input type="tel" id="birthday" name="birthday"
				maxlength="6" placeholder="생년월일(예:880704)"/>
		</li>
		<li>
			성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;별 : 
			<label><input type="radio" id="gen_m" name="gender02" value="1"/>남성</label>
			<label><input type="radio" id="gen_f" name="gender02" value="2"/>여성</label>
		</li>
		<li>
			<label><input type="checkbox" id="pro_check01" />추천조건 설계하기</label>
		</li>
		<li id="insType_choice_title_li">보험종류 : <a href="javascript:computeDetailOp('insType')" id="insType_choice_title"><strong id="insType_txt"></strong></a>
			<div id="insType_choice_detail">
				<h3>보험료 환급유무를 선택해주세요.</h3>
				<ul id="insType_choice_detail_ul" style="list-style-type: none;list-style: none;">
					<li id="it1_li" style="float: left;margin-right:10px;"><label><input type="radio" id="it1" name="insType" value="ck1" />순수보장형(환급없음)</label></li>
					<li id="it2_li" style="float: left;margin-right:10px;"><label><input type="radio" id="it2" name="insType" value="ck2" />(만기시)50% 환급형</label></li>
					<li id="it3_li"><label><input type="radio" id="it3" name="insType" value="ck3" />(만기시)100% 환급형</label></li>
				</ul>
			</div>
		</li>
		<li id="insJoinM_choice_title_li"><a href="javascript:computeDetailOp('insJoinM')" id="insJoinM_choice_title">보험가입금액<strong id="insJoinM_txt"></strong></a>
			<div id="insJoinM_choice_detail">
				<h3>사망시 남길 보험금은 얼마인가요?</h3>
				<ul id="insJoinM_choice_detail_ul" style="list-style-type: none;list-style: none;">
					<li style="float: left"><label><input type="radio" id="insJoinM_05"  name="insJoinM" value="0.5" />5천만원</label></li>
					<li style="float: left"><label><input type="radio" id="insJoinM_1" name="insJoinM" value="1" />1억원</label></li>
					<li style="float: left"><label><input type="radio" id="insJoinM_2" name="insJoinM" value="2" />2억원</label></li>
					<li><label><input type="radio" id="insJoinM_M1" name="insJoinM" value="-1" />직접입력</label></li>
				</ul>
				<fieldset class="user_edit" id="insJoinM_custom">
					<legend>직접입력폼</legend>
					<p>
						<input type="number" value="" id="insJoinMTxt" name="insJoinMTxt" placeholder="1~20" maxlength="2" oninput="maxLengthCheck(this)" title="금액 입력 폼(숫자만 입력)" /><span>천만원</span>
					</p>
				</fieldset>
			</div>
		</li>
		<li id="bogi_choice_title_li">보험기간 : <strong id="bogi_txt"></strong>
			<div id="bogi_choice_detail">
				<h3>보험 보장기간을 선택해주세요.</h3>
				<ul id="bogi_choice_detail_ul" class="calculator_option">
					<li id="bogi_N10_li"><label><input type="radio" id="bogi_N10" name="bogi" value="N10" /> <span id="bogi_N10_txt" >50세(10년)</span></label></li>
					<li id="bogi_X55_li"><label><input type="radio" id="bogi_X55" name="bogi" value="X55" /> <span id="bogi_X55_txt" >55세</span></label></li>
					<li id="bogi_X60_li"><label><input type="radio" id="bogi_X60" name="bogi" value="X60" /> <span id="bogi_X60_txt" >60세</span></label></li>
					<li id="bogi_X65_li"><label><input type="radio" id="bogi_X65" name="bogi" value="X65" /> <span id="bogi_X65_txt" >65세</span></label></li>
					<li id="bogi_X70_li"><label><input type="radio" id="bogi_X70" name="bogi" value="X70" /> <span id="bogi_X70_txt" >70세</span></label></li>
					<li id="bogi_X75_li"><label><input type="radio" id="bogi_X75" name="bogi" value="X75" /> <span id="bogi_X75_txt" >75세</span></label></li>
					<li id="bogi_X80_li"><label><input type="radio" id="bogi_X80" name="bogi" value="X80" /> <span id="bogi_X80_txt" >80세</span></label></li>
				</ul>				
			</div>
		</li>
		<li id="payment_choice_title_li">납입기간 : <strong id="payment_txt"></strong>
			<div id="payment_choice_detail">
				<h3>얼마동안 납입하고 싶으세요?</h3>
				<ul id="payment_choice_detail_ul" class="calculator_option">
					<li id="pay_10_li"><label><input type="radio" id="pay_10" name="payment" value="10" /> 10년</label></li>
					<li id="pay_20_li"><label><input type="radio" id="pay_20" name="payment" value="20"/> 20년</label></li>
					<li id="pay_0_li"><label><input type="radio" id="pay_0"name="payment" value="0" /> 전기납</label></li>
				</ul>
			</div>
		</li>
	</ul>
</fieldset>

</body>
</html>