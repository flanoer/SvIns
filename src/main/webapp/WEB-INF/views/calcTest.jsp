<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

<script type="text/javascript">
	$(function(){
		$("input:radio[name='monthbill']").on("click",function(){
			if($(this).val() == '-1'){
				$("#monthbill_custom").show();
			}
			else{
				$("#monthbill_custom").hide();
			}
		});
	});
	
	function vali_form(){
		if($('[name="birthday"]').val() == ''){
			alert('생년월일을 입력하세요.');
			$('[name="birthday"]').focus();
			return false;
		}
		
		if($('input:radio[name="gender02"]:checked').val() == undefined){
			alert('성별을 선택하세요.');
			return false;
		}
		
		if($('input:radio[name="payment"]:checked').val() == undefined){
			alert('납입기간을 선택하세요.');
			return false;
		}
		
		if($('input:radio[name="monthbill"]:checked').val() == undefined && $('input:radio[name="monthbill"]:checked').val() != '-1' ){
			alert('월보험료를 선택하세요.');
			return false;
		}
		
		tabValChk();
		
		savingsValidate($('[name="birthday"]').val());
		
		if(!birthChecking($('[name="birthday"]').val())) {
			alert('생년월일을 정확히 입력해주세요 (예: 800101)');
			$('[name="birthday"]').val('');
			$('[name="birthday"]').focus();
			return false;
		}
		
		setMainFormData();
		
		fn_submit();
		
	};
	
	function fn_submit(){
		
		var params = $("#mainForm").serialize();
		console.log(params);
		var temp = "";
		
		$.ajax({
			url: '<c:url value="/calcResult.do"/>',
			accepts: {
				text: 'application/json'
			},
			type: 'post',
			data: params,
			dataType: 'json',
			success: function(response) {
				if(response.serverSideSuccessYn == 'Y') {
					//결과페이지 display				
					display(response.result.jsonData);					
					//해지환급금 테이블 설정
					//tableReadMore();		
					$('#mainForm>[name="sskey"]').val(response.result.jsonData.new_sskey);
				}
			},
			error : function(xhr, status, error) {
				console.log("에러 : " + error + "상태 : "+ status);
			}
		});
	};
	
	//mainform value set
	function setMainFormData() {	
		$('#mainForm>input[name="bjCode"]').val('ck1');
		$('#mainForm>input[name="insSsn"]').val($('[name="birthday"]').val());
		$('#mainForm>input[name="insSex"]').val($('input:radio[name="gender02"]:checked').val());
		$('#mainForm>input[name="insAge"]').val(getInsAge($('[name="birthday"]').val()));
		$('#mainForm>input[name="insManAge"]').val(getManAge($('[name="birthday"]').val()));
		$('#mainForm>input[name="u0"]').val(getMonthBill());		
		$('#mainForm>input[name="napgiCode"]').val($('input:radio[name="payment"]:checked').val());
		$('#mainForm>input[name="bogiCode"]').val($('input:radio[name="bogi"]:checked').val());
			
		$('#mainForm>input[name="napgi"]').val(getNapgi());	
		$('#mainForm>input[name="bogi"]').val(getBogi());	
		$('#mainForm>input[name="healthYn"]').val('N');
	}
	
	//월보험료 세팅
	function getMonthBill(){
		var monthbill = $('input:radio[name="monthbill"]:checked').val();
		if(monthbill == -1) {
			return $('#monthbillTxt').val();
		}
		else {
			return monthbill;
		}		
	}
	
	//납입기간 세팅
	function getNapgi(){
		var napgiCode = $('input:radio[name="payment"]:checked').val();
		var napgi;
		if(napgiCode == '0'){
			napgi = getBogi();
		} else {
			napgi = napgiCode;
		}
		return napgi;
	}
	
	//보험기간 세팅
	function getBogi(){
		var bogiCode = $('input:radio[name="bogi"]:checked').val();
		var bogi;
		if(bogiCode.indexOf('X') >= 0){
			bogi = Number(bogiCode.replace('X', '')) - getInsAge($('[name="birthday"]').val());
		}else {
			bogi = Number(bogiCode.replace('N', ''))
		}
		return bogi;
	}
	
	function tabValChk(){
		if($('[name="birthday"]').val() == '') {				
			alert('생년월일을 입력해 주세요.');
			$('[name="birthday"]').focus();				
			return false;
		}
		if(/^\d{6}$/.test($('[name="birthday"]').val()) == false) {
			alert('생년월일은 YYMMDD의 6자리로 입력하여 주십시오.');
			$('[name="birthday"]').focus();				
			return false;
		}
	}
	
	//계산결과 화면 값 set
	function display(data){
			
		var splData = data.surData.split('@');
		/*월보험료 setting*/
		var monthbill = data.u0;
		
		/*납입 보험료*/
		var napgiStart = data.napgi_start; //납입보험료 start
		var napgiEnd = data.napgi_end; //납입보험료 end			
					
		/*에상 연금액*/
		var bogiStart = data.bogi_start; //예상연금액 start
		var bogiEnd = data.bogi_end; //예상연금액 end	
		
		/*그래프 setting*/
		//var bogiName = data.bogiName; //연금형태	
		//var yonAge = data.pr_7 //연금개시 연령		
		//var insAge = data.pr_6 //가입연령
		//var napgi = data.napgi; //납입기간
		//var gurtPaymTerm = data.gurtPaymTerm //연금지급기간
				
		//graphInit(); //초기화가 필요없어 주석
		var graphType = 'E1'; //저축은 하나라 직접 설정
		
		/*graph 화면 set*/
		//$('#resNapgiStart'+graphType).text(napgiStart);
		$('#resNapgiEnd'+graphType).text(replaceNumType(napgiEnd));
		//$('#resBogiStart'+graphType).text(bogiStart);
		$('#resBogiEnd'+graphType).text(replaceNumType(bogiEnd));	
				
		/*납입보험료 & 예상수령액 셋팅*/		
		var rtnPrice3 = data.rtn_price3; //예상수령액(현공시이율)	
		var stdMinYonRate = data.std_min_yon_rate; //현공시이율		
		var refundRate = splData[108]; //환급율
		console.log("환급율 : "+refundRate);
		console.log("결과값 : "+splData);
		
		/*상세연금액*/
		var rtnPrice1 = data.rtn_price1; //예상수령액(최저보증이율)	
		var rtnPrice2 = data.rtn_price2; //예상수령액(표준)	
			
		/*결과 화면 set*/	
		$('#monthInsurance').val(monthbill);
		$('#resMonthbill').text(monthbill);	
		if($('#resRtnPrice').text(commaNum(replaceNumType(rtnPrice3))) != 'undefined'){
			$("#resRtnPrice_li").show();
			$("#resRtnPrice_recalc").show();
			$("#btn_refund_li").show();
		};
		$('#resRefundRate').text(refundRate);
		
		$('#resStdMinYonRate, #resExamStdMinYonRate').text(stdMinYonRate);	
		
		//연금액 안내
		$('#resExamYear').text(new Date().getFullYear()); // 올해
		$('#resExamMonth').text(new Date().getMonth() + 1); // 이번달	
		
		
		var detail = data.F;						//해지환급금 예시내용
		var jsonPrsTblBody = JSON.parse(detail);	//해지환금금 json
		
		//해지환급금 예시안내
		if(detail && detail.length>0){
			
			var apHtml = "";
			
			$(jsonPrsTblBody.F_cnctRcstList).each(function(idx){
				apHtml += '<tr>\n';
				apHtml += '<th scope="row">'+this.cnctEltrMnth+'</th>\n';
				apHtml += '<td class="price">'+this.paymPrem+'</td>\n';
				apHtml += '<td class="price">'+this.mainCnctRcst0+'</td>\n';
				apHtml += '<td class="price">'+this.mainRfndRato0+'</td>\n';
				apHtml += '</tr>\n';
			});			
			
			var infoHtml = '';
			var subCnt = 0;
			var fDown = jsonPrsTblBody.F_cnctRcstDown;
			var fDownSize = fDown.length;
			
			for (var i = 0 ; i < fDownSize; i++) {
				var _this = fDown[i];
				var _next = fDown[(i+1)];
				var isThisSub = (_this.explPrgp.substr(0, 1) == '-' && _this.listMark == '') ? true : false;
				var isNextSub = (_next != null && (_next.explPrgp.substr(0, 1) == '-' && _next.listMark == '')) ? true : false;
				
				if (isThisSub) {
					infoHtml += '<li>'+_this.explPrgp.replace(/&nbsp;/gm, '') + '</li>\n';
					
					if (!isNextSub) {
						infoHtml += '</ul>\n</li>\n';
					}
					
				} else {

					infoHtml += '<li>';
					infoHtml += _this.listMark +' '+ _this.explPrgp.replace(/&nbsp;/gm, '');
					if (!isNextSub) {
						infoHtml += '</li>\n';
					} else {
						infoHtml += '\n<ul>\n';
					}
				}
			}				
			
			$('#resRefundInfo2').html(infoHtml);		//해지환급금 예시 안내문
		}
	}
	
	function recalc(){
		if($("#resRtnPrice").val() != 'undefined'){
			$("#resRtnPrice_li").hide();
			$("#resRtnPrice_recalc").hide();
			$("#btn_refund_li").hide();
			$('[name="birthday"]').focus();
			$('#refund').hide();
			$('#refund2').hide();
		}
	}
	
	//해지환급금 조회
	function getCancelData(){
		readGridData('my', '1');						
		$('#refund').show();
		$('#refund2').show();
	}
	
	//해지환급금 정보 가져오기
	function readGridData(type, step){
		
		var num;
		var curData = new Date();
		var year = String(curData.getFullYear() - 40).substring(2,4);
		var tmpSsn = year + '0101';
		if(getInsAge(tmpSsn) > 40){
			var nYear = Number(year) + 1; 
			tmpSsn = String(nYear)+ '0101';
			
		}else if(getInsAge(tmpSsn) < 40){
			var nYear = Number(year) - 1; 
			tmpSsn = String(nYear)+ '0101';
			
		}
			
		if(type == 'dummy3'){  // 4텝 상세페이지
			//기준 : 남자, 40세, 10년만기, 3년납, 월납, 보험료 10만원
			
			//데이터를 정제하여 폼에 넣는다.
			//$('#mainForm>input[name="bjCode"]').val($('input:radio[name="insType"]:checked').val());
			$('#mainForm>input[name="insSsn"]').val(tmpSsn);
			$('#mainForm>input[name="insSex"]').val(1);
			$('#mainForm>input[name="insAge"]').val(getInsAge(tmpSsn));
			$('#mainForm>input[name="insManAge"]').val(getManAge(tmpSsn));
			$('#mainForm>input[name="u0"]').val(20);
			$('#mainForm>input[name="bogiCode"]').val('N10');
			$('#mainForm>input[name="napgiCode"]').val('3');
			$('#mainForm>input[name="healthYn"]').val('N');
			$('#mainForm>input[name="step"]').val(step);
			
			num = '03';
		}
		else if(type == 'my'){  // 자신이 직접 입력한 데이터로 해지 환급금을 조회한다.
			
			//데이터를 정제하여 폼에 넣는다.
			//$('#mainForm>input[name="bjCode"]').val($('input:radio[name="insType"]:checked').val());
			$('#mainForm>input[name="insSsn"]').val($('[name="birthday"]').val());
			$('#mainForm>input[name="insSex"]').val($('input:radio[name="gender02"]:checked').val());
			$('#mainForm>input[name="insAge"]').val(getInsAge($('[name="birthday"]').val()));
			$('#mainForm>input[name="insManAge"]').val(getManAge($('[name="birthday"]').val()));
			$('#mainForm>input[name="u0"]').val(getMonthBill());
			$('#mainForm>input[name="bogiCode"]').val($('input:radio[name="bogi"]:checked').val());
			$('#mainForm>input[name="napgiCode"]').val($('input:radio[name="payment"]:checked').val());
			$('#mainForm>input[name="healthYn"]').val('Y');
			$('#mainForm>input[name="step"]').val(step);
			
			num = '01';
		}else if(type == 'pension'){  // 4텝 상품 상세내용 데이터 연동
			// 여자 40세 10년만기 3년납 월납 보험료 20만원
			$('#mainForm>input[name="insSsn"]').val(tmpSsn);
			$('#mainForm>input[name="insSex"]').val(2); 
			$('#mainForm>input[name="insAge"]').val(getInsAge(tmpSsn));
			$('#mainForm>input[name="insManAge"]').val(getManAge(tmpSsn));
			$('#mainForm>input[name="u0"]').val(20);
			$('#mainForm>input[name="bogiCode"]').val('N10');
			$('#mainForm>input[name="napgiCode"]').val('3');
			$('#mainForm>input[name="healthYn"]').val('N');
			$('#mainForm>input[name="step"]').val(step);
			
			num = '01';
		}
		
		//데이터 조회
		$.ajax({
			type: 'POST',
			accepts: {
				text: 'application/json'
			},
			url: '<c:url value="/calcResultDetail.do"/>',
			data: $('#mainForm').serialize(),
			async: true,
			dataType: 'json',
			success: function(response) {				
				if(response.serverSideSuccessYn == 'Y') {					
					if(parseInt(step) == 1) {
						console.log("해지환급금 관련정보 \r\n jsonData : "+response.result.jsonData+
									"\r\n num : "+num+
									"\r\n type : "+type);
						//해지환급금
						displayTerminateData(response.result.jsonData, num, type);
					}
					if(response.result.jsonData) {
						if(parseInt(step) == 2) {
							//연금액 예시(상품설명 나오면 코딩)
							displayAmountData(response.result.jsonData);
						}
					}
				}
			},
			error: function(xhr, status, error) {
				console.log("에러 : " + error + "상태 : "+ status);
			}
		});
	}
	
	//해지환급금 화면 set
	function displayTerminateData(data, num, type){
		var nowTime = new Date();		
			
		var stdRate = '';
		var avgStdRate = ''
		var stdMinYonRate = ''	
		
		var detail = data.F;				//해지환급금 예시내용
		var jsonPrsTblBody = JSON.parse(detail);	//해지환급금 Json
		
		//추후 dummy데이터 때문에 분기부분 남겨 놓음
		if(type == 'my'){
			
			/*기본비용 및 수수료*/
			if(data){
				//환급금 테이블 표 표준이율, 현재 공시율
				stdRate = data.std_rate; //표준이율 	->	연복리A
				stdMinYonRate = data.std_min_yon_rate; //현공시이율	->	연복리 B
				avgStdRate = data.avg_std_rate; //평균공시이율
						
				/*해지 환급금 관련 절정*/	
				//기준 공통(예시표, 수수료)
				var insSex = data.pr_1; //성별
				var insAge = data.pr_2 //시작나이
				var monthbill = data.u0; //보험료
				var napgi = data.napgiName; //납입기간
				//var yonAge = data.pr_7 //연금개시 나이
				
				//수수료에 뜨는 부분
				//(기준 : 남 36세, 10년만기, 3년납, 보험료 300,000원 )
				var standard = '기준 : '+insSex+'자, '+insAge+'세, 10년만기, '+napgi+'납, 보험료 '+commaNum(Number(monthbill)*10000)+'원';
						
				/*수수료(기본 비용 및 수수료) set*/
				var conclusionCost1 = data.pr_135; //체결비용			
				var manageCost1 = data.pr_136; //관리비용			
				var manageCost2 = data.pr_137; //관리비용
				var manageCost3 = data.pr_142; //관리비용
				var dangerCost1 = data.pr_147; //위험비용
				var dangerCost2 = data.pr_148; //위험비용
				var dangerCost3 = data.pr_145; //위험비용
				var dangerCost4 = data.pr_146; //위험비용
				
				//수수료 관련 변수들
				//보험관련비용(계약체결비용)
				var standardCost1 = napgi+'미만 : 경과이자의 5%(최대'+commaNum(conclusionCost1)+'원)';			
				//보험관련비용(계약관리비용)
				var standardCost2 = napgi+'미만 : 경과이자의 15%(최대'+commaNum(manageCost1)+'원)';
				var standardCost3 = napgi+'이상 : 보험료의 '+manageCost3+'%('+commaNum(manageCost2)+'원)';
				//보험관련비용(위험비용)
				var standardCost4 = '보험료의 '+dangerCost1+'% - '+dangerCost2+'% ('+commaNum(dangerCost3)+'원 ~ '+commaNum(dangerCost4)+'원)';
				
						
				/*수수료(기본 비용 및 수수료) 화면*/		
				$('#resStandard1, #resStandard2').text(standard);
				$('#resStandardCost1').text(standardCost1);
				$('#resStandardCost2').text(standardCost2);
				$('#resStandardCost3').text(standardCost3);
				$('#resStandardCost4').text(standardCost4);
				
				/*해지 환급금 화면 set*/	
				//연금액, 환급금 테이블 표 표준이율, 현재 공시이률 셋
				$('#resStdMinYonRate2, #resStdMinYonRate3, #resStdMinYonRate4, #resStdMinYonRate5, #resStdMinYonRate6').text(stdMinYonRate);
				$('#resStdRate2, #resStdRate3, #resStdRate4').text(stdRate);
				$('#resStdRate3-1').text(avgStdRate);

				// 연도, 월
				$("#year3, #year4, #year5, #year6").text(new Date().getFullYear());
				$("#month3, #month4, #month5, #month6").text(new Date().getMonth() + 1);
			}			
			
			/*해지환급금 예시표*/		
			if(jsonPrsTblBody.F_cnctRcstList.length > 0){
				//body 영역 초기화
				$('#resRefundAmount1').empty();
				$('#resRefundAmount2').empty();
				$('#resRefundAmount3').empty();
				
				for(var i=0; i<jsonPrsTblBody.F_cnctRcstList.length; i++){
				
					var row = jsonPrsTblBody.F_cnctRcstList[i];
					
					//최저보증이율 가정시
					var bufRefundAmt0 ='';
					bufRefundAmt0 += '<tr>'
					bufRefundAmt0 += '	<th scope="row" style="text-align: center; padding: 10px; border: 1px solid #ddd;">'+row.cnctEltrMnth+'</th>';//기간
					bufRefundAmt0 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.paymPrem+'</td>'//납입보험료
					bufRefundAmt0 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainCnctRcst0+'</td>'//해지환급금
					bufRefundAmt0 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainRfndRato0+'</td>'//환급률
					bufRefundAmt0 += '</tr>'
					
					$('#resRefundAmount0').append(bufRefundAmt0);
					
					//연복리A 2.5% 가정시
					var bufRefundAmt1 ='';
					bufRefundAmt1 += '<tr>'
					bufRefundAmt1 += '	<th scope="row" style="text-align: center; padding: 10px; border: 1px solid #ddd;">'+row.cnctEltrMnth+'</th>';//기간
					bufRefundAmt1 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.paymPrem+'</td>'//납입보험료
					bufRefundAmt1 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainCnctRcst1+'</td>'//해지환급금
					bufRefundAmt1 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainRfndRato1+'</td>'//환급률
					bufRefundAmt1 += '</tr>'
					
					$('#resRefundAmount1').append(bufRefundAmt1);

					//연복리B 2.79% 가정시
					var bufRefundAmt2 ='';
					bufRefundAmt2 += '<tr>'
					bufRefundAmt2 += '	<th scope="row" style="text-align: center; padding: 10px; border: 1px solid #ddd;">'+row.cnctEltrMnth+'</th>';//기간
					bufRefundAmt2 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.paymPrem+'</td>'//납입보험료
					bufRefundAmt2 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainCnctRcst2+'</td>'//해지환급금
					bufRefundAmt2 += '	<td style="text-align: right; padding: 10px; border: 1px solid #ddd;">'+row.mainRfndRato2+'</td>'//환급률
					bufRefundAmt2 += '</tr>'
					
					$('#resRefundAmount2').append(bufRefundAmt2);
								
				}
			}
		}
		
		//해지환급금 예시안내
		if(detail && detail.length>0){
			
			var infoHtml = '';
			var subCnt = 0;
			var fDown = jsonPrsTblBody.F_cnctRcstDown;
			var fDownSize = fDown.length;
			
			for (var i = 0 ; i < fDownSize; i++) {
				var _this = fDown[i];
				var _next = fDown[(i+1)];
				var isThisSub = (_this.explPrgp.substr(0, 1) == '-' && _this.listMark == '') ? true : false;
				var isNextSub = (_next != null && (_next.explPrgp.substr(0, 1) == '-' && _next.listMark == '')) ? true : false;
				
				if (isThisSub) {
					infoHtml += '<li>'+_this.explPrgp.replace(/&nbsp;/gm, '') + '</li>\n';
					if (!isNextSub) {
						infoHtml += '</ul>\n</li>\n';
					}
				} else {
					infoHtml += '<li>';
					infoHtml += _this.listMark +' '+ _this.explPrgp.replace(/&nbsp;/gm, '');
					if (!isNextSub) {
						infoHtml += '</li>\n';
					} else {
						infoHtml += '\n<ul>\n';
					}
				}
			}
			
			$('#resRefundInfo').html(infoHtml);		//해지환급금 안내문
		}	
	}
</script>
</head>
<body>
	<fieldset>
		<legend>저축보험</legend>
		<ul id="info">
			<li>생년월일 : <input type="tel" id="birthday" name="birthday"
				maxlength="6" placeholder="생년월일(예:880704)"></li>
			<li>성&nbsp;&nbsp;&nbsp;&nbsp;별 : <label>남성 <input
					type="radio" id="gen_m" name="gender02" value="1"></label><label>여성
					<input type="radio" id="gen_f" name="gender02" value="2">
			</label></li>
			<li>납입기간 : 
				<label>2년<input type="radio" id="pay_2" name="payment" value="2"></label>
				<label>3년<input type="radio" id="pay_3" name="payment" value="3"></label>
				<label>5년<input type="radio" id="pay_5" name="payment" value="5"></label> 
				<label>7년<input type="radio" id="pay_7" name="payment" value="7"></label> 
				<label>10년<input type="radio" id="pay_10" name="payment" value="10"></label>
			</li>
			<li>월보험료 : 
			<label>10만원<input type="radio" id="monthbill_10" name="monthbill" value="10"></label>
			<label>20만원<input type="radio" id="monthbill_20" name="monthbill" value="20"></label> 
			<label>30만원<input type="radio" id="monthbill_30" name="monthbill" value="30"></label>
			<label>직접입력<input type="radio" id="monthbill_-1" name="monthbill" value="-1"></label>
			<span id="monthbill_custom" style="display: none"><input
					type="number" maxlength="4" id="monthbillTxt" name="monthbillTxt"
					oninput="maxLengthCheck(this)">만원</span>
			</li>
			<li>보험기간 : <label>10년<input type="radio" name="bogi"
					id="bogi_N10" value="N10" checked></label></li>
			<li><input type="button" value="계산 결과" onclick="vali_form()"></li>
			<li id="resRtnPrice_recalc" style="display: none"><input type="button" value="다시 계산" onclick="recalc()"></li>
			<li id="resRtnPrice_li" style="display: none"><span id="resRtnPrice"></span>원</li>
			<li id="btn_refund_li" style="display: none"><input type="button" value="해지환급금 조회" onclick="getCancelData()"></li> 
		</ul>

		<form id="mainForm" method="post">
			<input type="hidden" name="bj" />
			<!-- 보정코드 -->
			<input type="hidden" name="bjCode" />
			<!-- 보정코드 -->
			<input type="hidden" name="u0" />
			<!-- 가입금액(가입한도) -->
			<input type="hidden" name="insSsn" />
			<!-- 주민번호 -->
			<input type="hidden" name="insSex" />
			<!-- 성별 -->
			<input type="hidden" name="insAge" />
			<!-- 나이 -->
			<input type="hidden" name="insManAge" />
			<!-- 보험 만나이 -->
			<input type="hidden" name="napgiCode" />
			<!-- 납입기간코드 -->
			<input type="hidden" name="bogiCode" value="N10" />
			<!-- 보험기간 -->
			<input type="hidden" name="healthYn" />
			<!--  -->
			<input type="hidden" name="step" />
			<!-- 팝업ID -->
			<input type="hidden" name="napgi" />
			<!-- 납입기간 -->
			<input type="hidden" name="insuCode" value="CM090401" />
			<!-- 연금형태 -->
			<input type="hidden" id="sskey" name="sskey" />
			<!-- sskey -->
			<input type="hidden" name="sendUrlChk" value="C" /> <input
				type="hidden" name="jumpStep" id="jumpStep" value="" /> <input
				type="hidden" id="applyType" name="applyType" value="M" />
		</form>
	</fieldset>
	<fieldset id="refund" style="display: none">
		<legend style="font-size:2em"><strong>예시표</strong></legend>
		<p class="desc">아래 예시된 연복리A <span id="resStdRate3"></span>
			%는 “금융감독원장이 정하는 바에 따라 산정한 평균공시이율 <span id="resStdRate3-1"></span>
			%와 공시이율(저축) <span id="resStdMinYonRate3"></span>
			%(<span id="year3"></span>년 <span id="month3"></span>
			월 현재) 중 작은 이율을 적용하며, 연복리B <span id="resStdMinYonRate4"></span>
			%는 공시이율(저축) <span id="year4"></span>년 <span id="month4"></span>
			월 현재 <span id="resStdMinYonRate5"></span>%를 적용합니다.
		</p>
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:35%" />
				<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4" 
					style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">최저보증이율 가정 시</th>
				</tr>
				<tr>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount0" style="padding: 10px; border: 1px solid #ddd;">
			</tbody>
		</table>
		<br/>
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:35%" />
				<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4"
					 style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">연복리A 2.5% 가정시</th>
				</tr>
				<tr>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount1" style="padding: 10px; border: 1px solid #ddd;">
			</tbody>
		</table>
		<br/>
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width:15%" />
				<col style="width:35%" />
				<col style="width:35%" />
				<col style="width:15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4"
					 style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">연복리B 2.79% 가정시</th>
				</tr>
				<tr>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount2" style="padding: 10px; border: 1px solid #ddd;">
			</tbody>
		</table>
		
		<ul id="resRefundInfo">
		</ul>
	</fieldset>
	<fieldset id="refund2" style="display: none">
		<legend style="font-size:2em"><strong>수수료</strong></legend>
			<span id="resStandard2"></span>
			<h3>기본 비용 및 수수료</h3>
			<table style="border-collapse: collapse; border-top: 3px solid #168;">
				<colgroup>
					<col style="width:15%">
					<col style="width:25%">
					<col style="width:14%">
					<col style="width:46%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">구분</th>
						<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">목적</th>
						<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">시기</th>
						<th scope="col" style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">비용</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th scope="row" rowspan="3" style="padding: 10px; border: 1px solid #ddd;">보험 관계 비용</th>
						<td style="padding: 10px; border: 1px solid #ddd;">계약 체결 비용</td>
						<td style="padding: 10px; border: 1px solid #ddd;">매월</td>
						<td style="padding: 10px; border: 1px solid #ddd;"><span id="resStandardCost1"></span></td>
					</tr>
					<tr>
						<td style="padding: 10px; border: 1px solid #ddd;">계약 관리비용</td>
						<td style="padding: 10px; border: 1px solid #ddd;">매월</td>
						<td style="padding: 10px; border: 1px solid #ddd;">
							<span id="resStandardCost2"></span>
							<br/>
							<span id="resStandardCost3"></span>
						</td>
					</tr>
					<tr>
						<td style="padding: 10px; border: 1px solid #ddd;">위험보험료</td>
						<td style="padding: 10px; border: 1px solid #ddd;">매월</td>
						<td style="padding: 10px; border: 1px solid #ddd;">
							<span id="resStandardCost4"></span>
						</td>
					</tr>
					<tr>
						<th scope="row" style="padding: 10px; border: 1px solid #ddd;">해지공제</th>
						<td style="padding: 10px; border: 1px solid #ddd;">해지에 따른 패널티</td>
						<td style="padding: 10px; border: 1px solid #ddd;">해지시</td>
						<td style="padding: 10px; border: 1px solid #ddd;">해당 없음</td>
					</tr>
				</tbody>
			</table>
			<p>주)경과이자 : 매월 계약해당일의 계약자적립금에서 이미 납입한 보험료를 차감한 금액</p>
	</fieldset>
</body>
</html>