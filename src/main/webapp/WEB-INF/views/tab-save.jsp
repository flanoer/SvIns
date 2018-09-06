<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${pageContext.request.contextPath}/resources/js/fn_save.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	
	$('.calculator ul').hide();
	
	//저축보험 추천조건
	$('#rcm_cond_save').on("click",function(){
		if($(this).is(":checked")) {
			if(valCommonInfo()){
				setSave_FaveData();
			}
			else $(this).prop("checked",false);
		}
		else{
			$('#tabs .calc_this input').each(function(){
				if($(this).attr("type") == 'number' && $(this).val() != undefined){
					$(this).parent().hide();
					$(this).val('');
				}
			});
		}
	});
	
	$('input:radio[name="payment"]').on("click",function(){
		$('#rcm_cond_save').prop("checked",false);
		setPaymentSave($(this).val());
		setMonthBill(null);
	});
	
	$('input:radio[name="monthbill"]').on("click",function(){
		$('#rcm_cond_save').prop("checked",false);
		
		if($(this).val() == '-1'){
			$('#monthbill_custom').show();
			setMonthBill($(this).val());
		}
		else{
			$('#monthbill_custom').hide();
			setMonthBill($(this).val());
		}
	});
	
	$('#btn_monthbillTxt').on("click",function(){
		$('#monthbill').text($('#monthbillTxt').val()+"만원");
		confirmChoice($(this).attr("name"));
		
	});
	
	$('[name="birthday"]').keyup(function(){
		
		$('#rcm_cond_save').prop('checked', false);
		
		if(/^\d{6}/.test($('[name="birthday"]').val()) == true){
			var birthday = $('[name="birthday"]').val();
			var insSex = $('input:radio[name="gender02"]:checked').val();
			
			if(!birthChecking(birthday)){
				alert("생년월일을 정확히 입력해주세요 (예 : 880704)");
				$('[name="birthday"]').val('');
				return false;
			}
			
			insValidate(birthday, $('.calc_this').attr("id"));
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
	<label><input type="checkbox" id="rcm_cond_save" name="pro_save"/>추천조건 설계하기</label><br/>
</div>
<div class="calculator">
	<a class="payment" href="javascript:computeDetailOp('payment')">납입기간 | <span id="payment"></span></a>
	<ul id="payment_li">
		<li><label><input type="radio" id="pay_2" name="payment" value="2" />2년</label></li>
		<li><label><input type="radio" id="pay_3" name="payment" value="3" />3년</label></li>
		<li><label><input type="radio" id="pay_5" name="payment" value="5" />5년</label></li>
		<li><label><input type="radio" id="pay_7" name="payment" value="7" />7년</label></li>
		<li><label><input type="radio" id="pay_10" name="payment" value="10" />10년</label></li>
	</ul>
</div>
<div class="calculator">
	<a href="javascript:computeDetailOp('monthbill')" ><span class="monthbill">월보험료</span> | <span id="monthbill"></span></a>
	<ul id="monthbill_li">
		<li><label><input type="radio" id="monthbill_10" name="monthbill" value="10" />10만원</label></li>
		<li><label><input type="radio" id="monthbill_20" name="monthbill" value="20" />20만원</label></li>
		<li><label><input type="radio" id="monthbill_30" name="monthbill" value="30" />30만원</label></li>
		<li><label><input type="radio" id="monthbill_-1" name="monthbill" value="-1" />직접입력</label></li>
		<li id="monthbill_custom" style="display: none">
			<input type="number" maxlength="4" id="monthbillTxt" name="monthbillTxt" oninput="maxLengthCheck(this)" placeholder="5~"/>만원
			<input style="display:block" type="button" value="확인" id="btn_monthbillTxt" name="monthbill"/>
		</li>
	</ul>
</div>
<div class="calculator">
	<span class="bogi">보험기간</span> | <label><input type="radio" name="bogi" id="bogi_N10" 
													value="N10" />10년</label>
</div>