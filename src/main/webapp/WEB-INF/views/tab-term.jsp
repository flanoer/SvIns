<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/resources/js/fn_term.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$('.calculator ul').hide();
	
	//정기보험 추천조건
	$('#rcm_cond_term').on("click",function(){
		if($(this).is(":checked")) {
			if(valCommonInfo()){
				setTerm_FaveData();
			}
			else $(this).prop("checked",false);
		}
		else{
			$('#tabs .calc_this input').each(function(){
				$(this).prop("checked",false);
				if($(this).attr("type") == 'number' && $(this).val() != undefined){
					$(this).parent().hide();
					$(this).val('');
				}
			});
		}
	});
	
	$('input:radio[name="insType"]').on("click",function(){
		
		$('#rcm_cond_term').prop("checked",false);
		
		var insType = $('input:radio[name="insType"]:checked').val();
		
		setInsType(insType);
		setBogiTerm(null);
		setInsJoinM(null);
		setPaymentTerm(null);
		
	});
	
	$('input:radio[name="insJoinM"]').on("click",function(){
		
		$('#rcm_cond_term').prop('checked', false);
		
		var insJoinM = $('input:radio[name="insJoinM"]:checked').val();
		var insJoinMTxt = $('#insJoinMTxt').val();
		
		if(insJoinM == '-1'){
			if(insJoinMTxt == 'undefined' || insJoinMTxt == ''){
				setInsJoinM("-1");
			}else{
				setInsJoinM(Number(insJoinMTxt)/10);
			}
		}
		else{
			setInsJoinM(insJoinM);
		}
		
		setBogiTerm(null);
		
		setPaymentTerm(null);
		
	});
	
	$('input:radio[name="bogi"]').on("click",function(){
		$('#rcm_cond_term').prop('checked', false);
		
		var bogi = $('input:radio[name="bogi"]:checked').val();
		
		setBogiTerm(bogi);
		
		setPaymentTerm(null);
	});
	
	$('input:radio[name="payment"]').on("click",function(){
		$('#rcm_cond_term').prop('checked', false);
		
		var payment = $('input:radio[name="payment"]:checked').val();
		
		setPaymentTerm(payment);
	});
	
	$('input:radio[name="gender02"],input:radio[name="insJoinM"],input:radio[name="insType"],input:radio[name="bogi"]').on('click',function() {
		
		var birthday=$('#birthday').val();
		var insSex=$('input:radio[name="gender02"]:checked').val();
		if($('.calc_this').attr("id") == 'tab-term'){
			
			var insType=$('input:radio[name="insType"]:checked').val();
			var bogi=$('input:radio[name="bogi"]:checked').val();
			
			//보험기간 가능한 조건으로 목록 변경
			fnBogiCng(birthday,insSex,insType);
			
			//납입기간 가능한 조건으로 목록 변경
			fnNapgiCng(birthday,insSex,insType,bogi);
		}
	});
	
	$('#btn_insJoinMTxt').on("click",function(){
		$('#insJoinM').text($('#insJoinMTxt').val()+"만원");
		confirmChoice($(this).attr("name"));
	});
	
	$('[name="birthday"]').keyup(function(){
		//추천조건 설계하기 선택 초기화
		$('#rcm_cond_term').prop('checked', false);			
		
		if(/^\d{6}/.test($('[name="birthday"]').val()) == true) {
			var birthday=$('[name="birthday"]').val();
			var insSex=$('input:radio[name="gender02"]:checked').val();	
			var insType=$('input:radio[name="insType"]:checked').val();	
			var bogi=$('input:radio[name="bogi"]:checked').val();			
			
			//생년월일 형식 체크
			if(!birthChecking(birthday)) {
				alert('생년월일을 정확히 입력해주세요 (예: 800101)');
				$('#birthday').val('');
				return false;
			}
			
			insValidate(birthday, $('.calc_this').attr("id"));
			
			//보험기간 가능한 조건으로 목록 변경
			fnBogiCng(birthday, insSex, insType);
			
			//납입기간 가능한 조건으로 목록 변경
			fnNapgiCng(birthday, insSex, insType, bogi);
		}
		else{
			$('#tabs .calc_this input').each(function(){
				$(this).prop("checked",false);
				if($(this).attr("type") == 'number'){
					$(this).val('');
					$(this).parent().hide();
				}
			});
		}
	});
});
</script>
<div class="calculator">
	<label><input type="checkbox" id="rcm_cond_term" name="pro_term" />추천조건 설계하기</label>
</div>
<li><a class="insType" href="javascript:computeDetailOp('insType')">보험종류 | <span id="insType"></span></a></li>
<div class="calculator">
	<ul id="insType_li">
		<li><label><input type="radio" id="it1" name="insType" value="ck1" />순수보장형(환급없음)</label></li>
		<li><label><input type="radio" id="it2" name="insType" value="ck2" />(만기시)50% 환급형</label></li>
		<li><label><input type="radio" id="it3" name="insType" value="ck3" />(만기시)100% 환급형</label></li>
	</ul>
</div>
<li><a class="insJoinM" href="javascript:computeDetailOp('insJoinM')">보험가입금액 | <span id="insJoinM"></span></a></li>
<div class="calculator">
	<ul id="insJoinM_li">
		<li><label><input type="radio" id="insJoinM_05"  name="insJoinM" value="0.5" />5천만원</label></li>
		<li><label><input type="radio" id="insJoinM_1" name="insJoinM" value="1" />1억원</label></li>
		<li><label><input type="radio" id="insJoinM_2" name="insJoinM" value="2" />2억원</label></li>
		<li><label><input type="radio" id="insJoinM_M1" name="insJoinM" value="-1" />직접입력</label></li>
		<li id="insJoinM_custom" style="display: none">
		<input type="number" id="insJoinMTxt" name="insJoinMTxt" placeholder="1~20" maxlength="2" oninput="maxLengthCheck(this)" title="금액 입력 폼(숫자만 입력)" />천만원
		<input style="display:block" type="button" value="확인" id="btn_insJoinMTxt" name="insJoinM"/>
		</li>
	</ul>
</div>
<li><a class="bogi" href="javascript:computeDetailOp('bogi')">보험기간 | <span id="bogi"></span></a></li>
<div class="calculator">
	<ul id="bogi_li">
		<li><label><input type="radio" id="bogi_N10" name="bogi" value="N10" /> <span id="bogi_N10_txt" >50세(10년)</span></label></li>
		<li><label><input type="radio" id="bogi_X55" name="bogi" value="X55" /> <span id="bogi_X55_txt" >55세</span></label></li>
		<li><label><input type="radio" id="bogi_X60" name="bogi" value="X60" /> <span id="bogi_X60_txt" >60세</span></label></li>
		<li><label><input type="radio" id="bogi_X65" name="bogi" value="X65" /> <span id="bogi_X65_txt" >65세</span></label></li>
		<li><label><input type="radio" id="bogi_X70" name="bogi" value="X70" /> <span id="bogi_X70_txt" >70세</span></label></li>
		<li><label><input type="radio" id="bogi_X75" name="bogi" value="X75" /> <span id="bogi_X75_txt" >75세</span></label></li>
		<li><label><input type="radio" id="bogi_X80" name="bogi" value="X80" /> <span id="bogi_X80_txt" >80세</span></label></li>
	</ul>
</div>
<li><a class="payment" href="javascript:computeDetailOp('payment')">납입기간 | <span id="payment"></span></a></li>
<div class="calculator">
	<ul id="payment_li">
		<li><label><input type="radio" id="pay_10" name="payment" value="10" /> 10년</label></li>
		<li><label><input type="radio" id="pay_20" name="payment" value="20"/> 20년</label></li>
		<li><label><input type="radio" id="pay_0"name="payment" value="0" /> 전기납</label></li>
	</ul>
</div>

