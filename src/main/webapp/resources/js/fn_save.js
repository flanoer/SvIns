//사용자 나이를 반영 디폴트 조건 선정
function setSave_FaveData() {
	var birthday=$('[name="birthday"]').val();
		
	if(birthday){
		var age = getInsAge(birthday);	
					
		if(age >= 20 && age < 30) {
			setSavingsData(birthday, g_faveData['2030']);
		}else if(age >= 30 && age < 81) {
			setSavingsData(birthday, g_faveData['3080']);
		}else {
			setSavingsData(birthday, g_faveData['default']);
		} 
	}
}

//저축 관련 항목 set
function setSavingsData(birthday, obj){
	
	var payment = obj.payment;
	var monthbill = obj.monthbill;
	var bogi = obj.bogi;
	
	setPaymentSave(payment);
	setMonthBill(monthbill);
	setBogiSave(bogi);
	
}

function setPaymentSave(payment){
	//납입기간 선택된 라디오버튼 해제
	$('.calc_this input:radio[name="payment"]').each(function(){
		$(this).prop("checked",false);
	});
	
	//추천된 데이터와 동일값 선택
	$('.calc_this input:radio[name="payment"]').each(function(){
		if(payment == $(this).val()){
			$(this).prop("checked",true);
			
			$("#payment").text(payment+"년");
			confirmChoice($(this).attr("name"));
			
			return;
		}
		else if(payment == null){
			$("#payment").text('');
		}
	});
};

function setMonthBill(monthbill){
	$('.calc_this input:radio[name="monthbill"]').each(function(){
		$(this).prop("checked",false);
	});
	
	$('.calc_this #monthbillTxt').val('');
	$('.calc_this #monthbill_custom').hide();
	
	$('.calc_this input:radio[name="monthbill"]').each(function(){
		if(monthbill == $(this).val() && monthbill != '-1'){
			$(this).prop("checked",true);
			
			$('#monthbill').text(monthbill+"만원");
			confirmChoice($(this).attr("name"));
			
			return;
		}
		else if(monthbill == '-1'){//직접입력 선택 시
			$(this).prop("checked",true);
			$('.calc_this #monthbill_custom').show();
		}
		else if(monthbill == null){
			$('#monthbill').text('');
		}
	});
	
};

function setBogiSave(bogi){
	$('.calc_this input:radio[name="bogi"]').each(function(){
		$(this).prop("checked",false);
	});
	
	$('.calc_this input:radio[name="bogi"]').each(function(){
		if($(this).val() == bogi){
			$(this).prop("checked",true);
			
			
		}
	});
};

//월보험료
function getMonthBill() {
	var monthbill = $('.calc_this input:radio[name="monthbill"]:checked').val();
	if (monthbill == '-1') {
		if($('#monthbillReTxt').val() != ''){
			monthbill = $('#monthbillReTxt').val();
			return monthbill;
		}
		return $('.calc_this #monthbillTxt').val();
	} else {
		if($('#monthbillReTxt').val() != ''){
			monthbill = $('#monthbillReTxt').val();
			return monthbill;
		}
		return monthbill;
	}
}

//납입기간
function getNapgi() {
	var napgiCode = $('.calc_this input:radio[name="payment"]:checked').val();
	var napgi;
	if (napgiCode == '0') {
		napgi = getBogi();
	} else {
		napgi = napgiCode;
	}
	return napgi;
}

//보험기간
function getBogi() {
	var bogiCode = $('.calc_this input:radio[name="bogi"]:checked').val();
	var bogi;
	if (bogiCode.indexOf('X') >= 0) {
		bogi = Number(bogiCode.replace('X', ''))
				- getInsAge($('[name="birthday"]').val());
	} else {
		bogi = Number(bogiCode.replace('N', ''))
	}
	return bogi;
}

function valiSave(){
	if($('input:radio[name="payment"]:checked').val() == undefined){
		$('input:radio[name="payment"]').eq(0).focus();
		alert('납입기간을 선택하세요.');
		return false;
	}
	if($('input:radio[name="monthbill"]:checked').val() == undefined){
		$('input:radio[name="monthbill"]').eq(0).focus();
		alert('월보험료를 선택하세요.');
		return false;
	}
	if($('input:radio[name="monthbill"]:checked').val() == '-1'){
		if($('input:radio[name="monthbillTxt"]').val() == ''){
			$('input:radio[name="monthbillTxt"]').focus();
			alert('월보험료의 직접입력란을 채워주세요.');
			return false;
		}
		else if(parseInt($('input:radio[name="monthbillTxt"]').val()) < 5){
			$('input:radio[name="monthbillTxt"]').focus();
			alert('월보험료의 직접입력란을 5만원 이상으로 입력해주세요.');
			return false;
		}
	}
	if($('input:radio[name="bogi"]:visible').is(":not(:checked)")){
		$('input:radio[name="bogi"]').focus();
		alert('보험기간을 선택해주세요.');
		return false;
	}
	if($('#monthbillReTxt').is(':visible')){
		if($('#monthbillReTxt').val() == ''){
			$('#monthbillReTxt').focus();
			alert('월 납입금 입력란을 채워주세요.');
			return false;
		}
		else if(parseInt($('#monthbillReTxt').val()) < 5){
			$('#monthbillReTxt').focus();
			alert('월 납입금을 5만원 이상으로 입력해주세요.');
			$('#monthbillReTxt').val('');
			return false;
		}
		else{
			return true;
		}
	}
	else{
		return true;
	}
}