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
	
	function tabValChk(id){
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
			$('[name="birthday"]').focus();
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
</body>
</html>