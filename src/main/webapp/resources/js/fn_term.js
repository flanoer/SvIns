//사용자 나이를 반영 디폴트 조건 선정
function setTerm_FaveData() {
	var birthday=$('[name="birthday"]').val();
	var insSex=$('input:radio[name="gender02"]:checked').val();
		
	if(birthday){
		var age = getInsAge(birthday);	
					
		if(getManAge(birthday) >= 19 && age < 56) {
			setTermData(birthday, insSex, g_faveData['2055']);
		}
		else {
			setTermData(birthday, insSex, g_faveData['default_t']);
		}
	}
}

function setTermData(birthday, insSex, obj){
	
	var insType=obj.insType;
	var insJoinM=obj.insJoinM;
	var bogi=obj.bogi;
	var payment=obj.payment;
	
	setInsType(insType);
	setInsJoinM(insJoinM);
	setBogiTerm(bogi);
	setPaymentTerm(payment);
		
	//보험기간 가능한 조건으로 목록 변경
	fnBogiCng(birthday,insSex,insType);
	
	//납입기간 가능한 조건으로 목록 변경
	fnNapgiCng(birthday,insSex,insType,bogi);
	
}

function setPaymentTerm(payment){
	//납입기간 선택된 라디오버튼 해제
	$('.calc_this input:radio[name="payment"]').each(function(){
		$(this).prop("checked",false);
	});
	
	//추천된 데이터와 동일값 선택
	$('.calc_this input:radio[name="payment"]').each(function(){
		if(payment == $(this).val()){
			$(this).prop("checked",true);
			if(payment == '0'){
				$("#payment").text("전기납");
			}
			else{
				$("#payment").text(payment+"년");
			}
			
			confirmChoice($(this).attr("name"));
			return;
		}
		else if(payment == null){
			$("#payment").text('');
		}
	});
};

//보험종류 값설정
function setInsType(insType) {
	$('.calc_this input:radio[name="insType"]').each(function() {
		$(this).prop('checked', false);			
	});						
	
	$('.calc_this input:radio[name="insType"]').each(function(){
		if(insType == $(this).val()){
			$(this).prop("checked",true);
			
			switch(insType){
				case "ck1": 
					$('#insType').text('순수보장형');
					break;
				case "ck2": 
					$('#insType').text('50%환급형');
					break;
				case "ck3":
					$('#insType').text('100%환급형');
					break;
			}
			confirmChoice($(this).attr("name"));
			return;
		}
		else if(insType == null){
			$('#insType').text('');
		}
	});	
}

//보험가입금액 설정
function setInsJoinM(insJoinM) {
	$('.calc_this input:radio[name="insJoinM"]').each(function() {
		$(this).prop('checked', false);				
	})			
	
	$('.calc_this #insJoinM_custom').hide();
	$('.calc_this input[type="number"][name="insJoinMTxt"]').val('');
	
	$('.calc_this input:radio[name="insJoinM"]').each(function(){
		if(insJoinM == $(this).val() && insJoinM != '-1'){
			$(this).prop("checked",true);
			switch($(this).val()){
				case '0.5':
					$('#insJoinM').text(Number(insJoinM*10)+"천만원");
					break;
				case '1':
					$('#insJoinM').text(insJoinM+"억원");
					break;
				case '2':
					$('#insJoinM').text(insJoinM+"억원");
					break;
			}
			
			confirmChoice($(this).attr("name"));
			
			return;
		}
		else if(insJoinM == '-1'){
			$(this).prop("checked",true);
			$('.calc_this #insJoinM_custom').show();
		}
		else if(insJoinM == null){
			$('#insJoinM').text('');
		}
	});
}


function setBogiTerm(bogi){
	$('.calc_this input:radio[name="bogi"]').each(function(){
		$(this).prop("checked",false);
	});
	
	$('.calc_this input:radio[name="bogi"]').each(function(){
		if($(this).val() == bogi){
			$(this).prop("checked",true);
			
			switch($(this).val()){
				case 'N10':
					$('#bogi').text($('#bogi_N10_txt').text());
					break;
				case 'X55':
					$('#bogi').text('55세');
					break;
				case 'X60':
					$('#bogi').text('60세');
					break;
				case 'X65':
					$('#bogi').text('65세');
					break;
				case 'X70':
					$('#bogi').text('70세');
					break;
				case 'X75':
					$('#bogi').text('75세');
					break;
				case 'X80':
					$('#bogi').text('80세');
					break;
			}
			confirmChoice($(this).attr("name"));
			return;
		}
		else if(bogi == null){
			$('#bogi').text('');
		}
	});
};

//보험가입금액
function getInsJoinM() {
	var insJoinM = $('.calc_this input:radio[name="insJoinM"]:checked').val();
	if(insJoinM == '-1') {
		if($('#insJoinMReTxt').val() != ''){
			insJoinM = Number($('#insJoinMReTxt').val())/10;
			return insJoinM;
		}
		insJoinM = Number($('.calc_this #insJoinMTxt').val())/10;
		return insJoinM;
	}
	else{
		if($('#insJoinMReTxt').val() != ''){
			insJoinM = Number($('#insJoinMReTxt').val())/10;
			return insJoinM;
		}
		return insJoinM;
	}
};

//보험기간 가능한 목록으로 변경 -- 수정해야함
function fnBogiCng(birthday, insSex, insType) {
	var insAge = Number(getInsAge(birthday));
	var insManAge = Number(getManAge(birthday));
	
	$('#tab-term #bogi_N10').parentsUntil('li').show();
	$('#bogi_X55').parentsUntil('li').show();
	$('#bogi_X60').parentsUntil('li').show();
	$('#bogi_X65').parentsUntil('li').show();
	$('#bogi_X70').parentsUntil('li').show();
	$('#bogi_X75').parentsUntil('li').show();
	$('#bogi_X80').parentsUntil('li').show();
	
	//100%환급형
	//1: 남성 2: 여성
	if( insSex == 1 && insAge > 68 ) {	
		$('#it3').parentsUntil('li').hide();
	} else {
		$('#it3').parentsUntil('li').show();
	}		
	
	//10년납 19~20
	if(insManAge > 18 && insAge < 60) {
		$('#bogi_N10_txt').text(String(insAge + 10) + '세(10년)');		
	} else {
		$('#tab-term #bogi_N10').parentsUntil('li').hide();
	}
	//55세 19~45
	if(!(insManAge > 18 && insAge < 46)) {			
		$('#bogi_X55').parentsUntil('li').hide();
	}
	if(insAge == 45) {			
		$('#bogi_X55').parentsUntil('li').hide();
	}
	//60세 19~50
	if(!(insManAge > 18 && insAge < 51)) {			
		$('#bogi_X60').parentsUntil('li').hide();
	}
	if(insAge == 50) {			
		$('#bogi_X60').parentsUntil('li').hide();	
	}
	//65세 19~55
	if(!(insManAge > 18 && insAge < 56)) {	
		$('#bogi_X65').parentsUntil('li').hide();
	}	
	if(insAge == 56) {		
		$('#bogi_X65').parentsUntil('li').hide();
	}	
	//70세 19~60
	if(insType == 'ck1') {
		if(!(insManAge > 18 && insAge < 61)) {
			$('#bogi_X70').parentsUntil('li').hide();
		}
	} else if(insType == 'ck2') {
		if(!(insManAge > 18 && insAge < 61)) {
			$('#bogi_X70').parentsUntil('li').hide();
		}
	} else {
		if(insSex == 1) {
			if(!(insManAge > 18 && insAge < 61)) {
				$('#bogi_X70').parentsUntil('li').hide();
			}
		} else {
			if(!(insManAge > 18 && insAge < 61)) {
				$('#bogi_X70').parentsUntil('li').hide();
			}
		}
	}				
	//75세 19~65
	if(insType == 'ck1') {
		if(!(insManAge > 18 && insAge < 66)) {			
			$('#bogi_X75').parentsUntil('li').hide();		
		}
	} else if(insType == 'ck2') {
		if(!(insManAge > 18 && insAge < 66)) {				
			$('#bogi_X75').parentsUntil('li').hide();			
		}
	} else {
		if(insSex == 1) {
			if(!(insManAge > 18 && insAge < 66)) {				
				$('#bogi_X75').parentsUntil('li').hide();				
			}
		} else {
			if(!(insManAge > 18 && insAge < 66)) {				
				$('#bogi_X75').parentsUntil('li').hide();			
			}
		}
	}
	//80세 19~75
	if(insType == 'ck1') {
		if(!(insManAge > 18 && insAge < 76)) {			
			$('#bogi_X80').parentsUntil('li').hide();		
		}
	
	} else if(insType == 'ck2') {
		if(!(insManAge > 18 && insAge < 71)) {				
			$('#bogi_X80').parentsUntil('li').hide();				
		}
	} else {
		if(insSex == 1) {
			if(!(insManAge > 18 && insAge < 69)) {				
				$('#bogi_X80').parentsUntil('li').hide();					
			}
		} else {
			if(!(insManAge > 18 && insAge < 71)) {				
				$('#bogi_X80').parentsUntil('li').hide();				
			}
		}
	}		
}
	
// 납입기간 가능한 목록으로 변경 -- 수정해야함
function fnNapgiCng(birthday,insSex,insType,bogi) {
	var insAge = Number(getInsAge(birthday));
	var insManAge = Number(getManAge(birthday));

	// 납입기간 목록 초기화				
	$('#pay_10').parentsUntil('li').show();
	$('#pay_20').parentsUntil('li').show();
	$('#pay_0').parentsUntil('li').show();
	
	if(insType == 'ck1') {
		//10년 만기
		if(bogi == 'N10') {			
			$('#pay_10').parentsUntil('li').hide();								
			$('#pay_20').parentsUntil('li').hide();				
		}
		if(bogi == 'N10' && insAge > 60) {							
			$('#pay_0').parentsUntil('li').hide();				
		}
		//55세 만기
		if(bogi == 'X55' && insAge > 34) {			
			$('#pay_20').parentsUntil('li').hide();				
		}
		if(bogi == 'X55' && insAge > 44) {			
			$('#pay_10').parentsUntil('li').hide();								
		}
		if(bogi == 'X55' && insAge > 45) {			
			$('#pay_0').parentsUntil('li').hide();				
		}
		//60세 만기
		if(bogi == 'X60' && insAge > 39) {			
			$('#pay_20').parentsUntil('li').hide();				
		}
		if(bogi == 'X60' && insAge > 49) {			
			$('#pay_10').parentsUntil('li').hide();								
		}
		if(bogi == 'X60' && insAge > 50) {			
			$('#pay_0').parentsUntil('li').hide();				
		}
		//65세 만기
		if(bogi == 'X65' && insAge > 44) {			
			$('#pay_20').parentsUntil('li').hide();				
		}
		if(bogi == 'X65' && insAge > 54) {			
			$('#pay_10').parentsUntil('li').hide();								
		}
		if(bogi == 'X65' && insAge > 55) {			
			$('#pay_0').parentsUntil('li').hide();				
		}
		//70세 만기
		if(bogi == 'X70' && insAge > 49) {			
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X70' && insAge > 59) {			
			$('#pay_10').parentsUntil('li').hide();				
		}
		if(bogi == 'X70' && insAge > 60) {			
			$('#pay_0').parentsUntil('li').hide();
		}
		//75세 만기
		if(bogi == 'X75' && insAge > 54) {			
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X75' && insAge > 64) {			
			$('#pay_10').parentsUntil('li').hide();				
		}
		if(bogi == 'X75' && insAge > 65) {			
			$('#pay_0').parentsUntil('li').hide();
		}
		//80세 만기
		if(bogi == 'X80' && insAge > 59) {			
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X80' && insAge > 69) {			
			$('#pay_10').parentsUntil('li').hide();				
		}
		if(bogi == 'X80' && insAge > 70) {			
			$('#pay_0').parentsUntil('li').hide();
		}
	} else if(insType == 'ck2') {   //50% 환급형		
		$('#tab-term #bogi_N10').parentsUntil('li').hide();				
		$('#bogi_X55').parentsUntil('li').hide();				
		$('#bogi_X60').parentsUntil('li').hide();				
		
		//남성	/65세 만기
		if(bogi == 'X65' && insAge > 44) { //20년납				
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X65' && insAge > 54) { //10년납				
			$('#pay_10').parentsUntil('li').hide();
		}
		if(bogi == 'X65' && insAge > 55) { //전기납				
			$('#pay_0').parentsUntil('li').hide();
		}
		//70세 만기
		if(bogi == 'X70' && insAge > 49) {				
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X70' && insAge > 59) {				
			$('#pay_10').parentsUntil('li').hide();
		}
		if(bogi== 'X70' && insAge > 60) {				
			$('#pay_0').parentsUntil('li').hide();
		}
		//75세 만기
		if(bogi == 'X75' && insAge > 54) {				
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X75' && insAge > 64) {				
			$('#pay_10').parentsUntil('li').hide();
		}
		if(bogi == 'X75' && insAge > 65) {				
			$('#pay_0').parentsUntil('li').hide();
		}
		//80세 만기
		if(bogi == 'X80' && insAge > 59) {				
			$('#pay_20').parentsUntil('li').hide();
		}
		if(bogi == 'X80' && insAge > 69) {				
			$('#pay_10').parentsUntil('li').hide();
		}
		if(bogi == 'X80' && insAge > 70) {				
			$('#pay_0').parentsUntil('li').hide();
		}

	} else  {		//100% 환급형
		$('#tab-term #bogi_N10').parentsUntil('li').hide();				
		$('#bogi_X55').parentsUntil('li').hide();				
		$('#bogi_X60').parentsUntil('li').hide();				
												
		if(insSex == 1) {
			//남성	/65세 만기
			if(bogi == 'X65' && insAge > 44) { //20년납				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X65' && insAge > 54) { //10년납				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi == 'X65' && insAge > 55) { //전기납				
				$('#pay_0').parentsUntil('li').hide();
			}
			//70세 만기
			if(bogi == 'X70' && insAge > 49) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X70' && insAge > 59) {				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi== 'X70' && insAge > 60) {				
				$('#pay_0').parentsUntil('li').hide();
			}
			//75세 만기
			if(bogi == 'X75' && insAge > 54) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X75' && insAge > 64) {				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi == 'X75' && insAge > 65) {				
				$('#pay_0').parentsUntil('li').hide();
			}
			//80세 만기
			if(bogi == 'X80' && insAge > 59) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X80' && insAge > 68) {				
				$('#pay_10').parentsUntil('li').hide();
			}
 			if(bogi == 'X80' && insAge > 62) {		//64세 ->62세로 변경		
				$('#pay_0').parentsUntil('li').hide();
			} 
		} else {
			//여 	/65세 만기
			if(bogi == 'X65' && insAge > 44) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X65' && insAge > 54) {				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi == 'X65' && insAge > 55) {				
				$('#pay_0').parentsUntil('li').hide();
			}
			//70세 만기
			if(bogi == 'X70' && insAge > 49) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X70' && insAge > 59) {				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi == 'X70' && insAge > 60) {				
				$('#pay_0').parentsUntil('li').hide();
			}
			//75세 만기
			if(bogi == 'X75' && insAge > 54) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X75' && insAge > 64) {				
				$('#pay_10').parentsUntil('li').hide();
			}
			if(bogi == 'X75' && insAge > 65) {				
				$('#pay_0').parentsUntil('li').hide();
			}
			//80세 만기
			if(bogi == 'X80' && insAge > 59) {				
				$('#pay_20').parentsUntil('li').hide();
			}
			if(bogi == 'X80' && insAge > 69) {
				$('#pay_10').parentsUntil('li').hide();
			}
 			if(bogi == 'X80' && insAge > 69) {	//70세 -> 69세로 변경			
				$('#pay_0').parentsUntil('li').hide();
			} 
		}
	}
}

function valiTerm(){
	if($('input:radio[name="payment"]:checked').val() == undefined){
		$('input:radio[name="payment"]').eq(0).focus();
		alert('납입기간을 선택하세요.');
		return false;
	}
	if($('input:radio[name="insType"]:checked').val() == undefined){
		$('input:radio[name="insType"]').eq(0).focus();
		alert('보험종류를 선택하세요.');
		return false;
	}
	if($('input:radio[name="insJoinM"]:checked').val() == undefined){
		$('input:radio[name="insJoinM"]').eq(0).focus();
		alert('보험가입금액을 선택하세요.');
		return false;
	}
	if($('input:radio[name="insJoinM"]:checked').val() == '-1'){
		if($('input:radio[name="insJoinMTxt"]').val() == ''){
			$('input:radio[name="insJoinMTxt"]').focus();
			alert('보험가입금액의 직접입력란을 채워주세요.');
			return false;
		}
		else if(parseInt($('input:radio[name="insJoinMTxt"]').val()) < 1){
			$('input:radio[name="insJoinMTxt"]').focus();
			alert('보험가입금액의 직접입력란을 1천만원 이상으로 채워주세요.');
			$('input:radio[name="insJoinMTxt"]').val('');
			return false;
		}
		else if(parseInt($('input:radio[name="insJoinMTxt"]').val()) > 20){
			$('input:radio[name="insJoinMTxt"]').focus();
			alert('보험가입금액한도는 2억원까지 입니다.');
			$('input:radio[name="insJoinMTxt"]').val('');
			return false;
		}
	}
	if($('input:radio[name="bogi"]:checked').val() == undefined){
		$('input:radio[name="bogi"]').focus();
		alert('보험기간을 선택해주세요.');
		return false;
	}
	if($('#insJoinMReTxt').is(':visible')){
		if($('#insJoinMReTxt').val() == ''){
			$('#insJoinMReTxt').focus();
			alert('보장금액 입력란을 채워주세요.');
			return false;
		}
		else if(parseInt($('#insJoinMReTxt').val()) < 1){
			$('#insJoinMReTxt').focus();
			alert('보장금액 입력란을 1천만원 이상으로 채워주세요.');
			$('#insJoinMReTxt').val('');
			return false;
		}
		else if(parseInt($('#insJoinMReTxt').val()) > 20){
			$('#insJoinMReTxt').focus();
			alert('보장금액 한도는 2억원까지 입니다.');
			$('#insJoinMReTxt').val('');
			return false;
		}
		else return true;
	}
	else return true;
}