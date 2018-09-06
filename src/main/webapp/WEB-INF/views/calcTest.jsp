<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>온슈어 저축보험 계산기</title>
<style type="text/css">
.template {
	display: none;
}
</style>
<script src="https://code.jquery.com/jquery-1.9.1.js"
	integrity="sha256-e9gNBsAcA0DBuRWbm0oZfbiCyhjLrI6bmqAl5o+ZjUA="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

<script type="text/javascript">

	//인기조건 샘플 데이터
	var g_faveData = {
		'2030' : {
			'payment' : '3', // 납입기간   2 : 2년납, 3 : 3년납, 0 : 일시납
			'monthbill' : '20', // 월 보험료  u0 = 10 : 10만원, 20 : 20만원,  30 : 30만원
			'bogi' : 'N10' // 보험기간   N10 = 10 으로 고정 10년
		},
		'3080' : {
			'payment' : '3', // 납입기간   2 : 2년납, 3 : 3년납, 0 : 일시납
			'monthbill' : '30', // 월 보험료  u0 = 10 : 10만원, 20 : 20만원,  30 : 30만원
			'bogi' : 'N10' // 보험기간   N10 = 10 으로 고정 10년
		},
		'default' : {
			'payment' : '3', // 납입기간   2 : 2년납, 3 : 3년납, 0 : 일시납
			'monthbill' : '20', // 월 보험료  u0 = 10 : 10만원, 20 : 20만원,  30 : 30만원
			'bogi' : 'N10' // 보험기간   N10 = 10 으로 고정 10년
		}
	};

	$(function() {
		$('input [name="birthday"]').on("change",function(){
			$('#pro_check01').prop("checked",false);
		});
		
		$('input:radio[name="gender02"]').on("change",function(){
			$('#pro_check01').prop("checked",false);
		});
		
		$('input:radio[name="payment"]').on("change",function(){
			$('#pro_check01').prop("checked",false);
		});
		
		$("input:radio[name='monthbill']").on("click", function() {
			$('#pro_check01').prop("checked",false);
			if ($(this).val() == '-1') {
				$("#monthbill_custom").show();
			} else {
				$("#monthbill_custom").hide();
			}
		});
	});
	
	function initPage(){
		$('fieldset').css('float','left');
		$('#termCalc').hide();
	};

	function select_ins(mode){
		if(mode == 'save'){
			$('#termins').parent().hide();
			$('#saveCalc').show();
		}
		else{
			$('#saveins').parent().hide();
			$('#termCalc').show();
		}
	}
	//인기조건 설계하기
	$(document).ready(function() {
		
		initPage();
		
		$('#pro_check01').on("click", function() {
			if (vali_proCheck() == false) {
				return false;
			} else {
				if ($(this).is(':checked')) {
					setFaveData();
				} else {
					$("#compute_start").fadeOut();
					$("#pro_checked").fadeOut();
					clearSavingsData();
				}
			}
		});
		
	});

	function vali_proCheck() {
		if ($('[name="birthday"]').val() == '') {
			alert("생년월일을 입력해주세요.");
			$('[name="birthday"]').focus();
			return false;
		}

		if (/^\d{6}$/.test($('[name="birthday"]').val()) == false) {
			alert('생년월일은 YYMMDD의 6자리로 입력하여 주십시오.');
			$('[name="birthday"]').focus();
			return false;
		}
		if ($('input:radio[name="gender02"]:checked').val() == undefined) {
			alert('성별을 입력해 주세요.');
			$('input:radio[name="gender02"]').eq(0).focus();
			return false;
		}

	};
	//사용자 나이를 반영 디폴트 조건 선정
	function setFaveData() {
		var birthday = $('[name="birthday"]').val();

		if (birthday) {
			var age = getInsAge(birthday);

			if (age >= 20 && age < 30) {
				setSavingsData(birthday, g_faveData['2030']);
			} else if (age >= 30 && age < 81) {
				setSavingsData(birthday, g_faveData['3080']);
			} else {
				setSavingsData(birthday, g_faveData['default']);
			}
		}
	}

	//저축 관련 항목 set
	function setSavingsData(birthday, obj) {

		var payment = obj.payment;
		var monthbill = obj.monthbill;
		var bogi = obj.bogi;

		//납입기간 설정
		if (setPayment(payment) != "ok") {
			setDefaultData();
			return false;
		}

		//월보험료 설정		
		if (setMonthBill(monthbill) != "ok") {
			setDefaultData();
			return false;
		}

	}

	//납입기간 설정
	function setPayment(payment) {

		$('input:radio[name="payment"]').each(function() {
			$(this).prop('checked', false);
		});

		switch (payment) {
		case '2':
			$('#pay_2').prop('checked', true);
			return "ok";
			break;
		case '3':
			$('#pay_3').prop('checked', true);
			return "ok";
			break;
		case '5':
			$('#pay_5').prop('checked', true);
			return "ok";
			break;
		case '7':
			$('#pay_7').prop('checked', true);
			return "ok";
			break;
		default:
			$('#pay_10').prop('checked', true);
			return "ok";
			break;
		}
	}

	//월보험료 설정
	function setMonthBill(bill) {
		$('input:radio[name="monthbill"]').each(function() {
			$(this).prop('checked', false);
		});

		$('#monthbillTxt').val('');
		$('#monthbill_custom').hide();

		switch (bill) {
		case '10':
			$('#monthbill_10').prop('checked', true);
			return "ok";
			break;
		case '20':
			$('#monthbill_20').prop('checked', true);
			return "ok";
			break;
		case '30':
			$('#monthbill_30').prop('checked', true);
			return "ok";
			break;
		default:
			$('#monthbill_-1').prop('checked', true);
			$('#monthbill_custom').show();
			$('#monthbillTxt').val(val);
			return "ok";
			break;
		}
	}

	function setDefaultData() {
		alert('인기조건이 없으니, 세부 항목을 선택하신 후 설계하시기 바랍니다.');
		clearSavingsData();
	}

	//게산기 초기화
	function clearSavingsData() {

		//납입기간 초기화		
		$('input:radio[name="payment"]').each(function() {
			$(this).prop('checked', false);
		});

		//월보험료 초기화	
		$('input:radio[name="monthbill"]').each(function() {
			$(this).prop('checked', false);
		});

		$('#monthbillTxt').val('');
		$('#monthbillTxt').hide();

		$('#mainForm>[name="sskey"]').val("");
		$("#jumpStep").val("");

	}

	function vali_form(mode) {
		if(mode == 'save'){
			$mode = $('#saveins');
			if ($mode.children('[name="birthday"]').val() == '') {
				alert('생년월일을 입력하세요.');
				$('[name="birthday"]').focus();
				return false;
			}
	
			if ($mode.children('input:radio[name="gender02"]:checked').val() == undefined) {
				alert('성별을 선택하세요.');
				return false;
			}
	
			if ($mode.children('input:radio[name="payment"]:checked').val() == undefined) {
				alert('납입기간을 선택하세요.');
				return false;
			}
	
			if ($mode.children('input:radio[name="monthbill"]:checked').val() == undefined
					&& $mode.children('input:radio[name="monthbill"]:checked').val() != '-1') {
				alert('월보험료를 선택하세요.');
				return false;
			}
	
			tabValChk();
	
			savingsValidate($mode.children('[name="birthday"]').val());
	
			if (!birthChecking($mode.children('[name="birthday"]').val())) {
				alert('생년월일을 정확히 입력해주세요 (예: 800101)');
				$mode.children('[name="birthday"]').val('');
				$mode.children('[name="birthday"]').focus();
				return false;
			}
	
			setMainFormData($mode);
	
			fn_submit();
		}
		else{
			
		}

	};

	function fn_submit() {

		var params = $("#mainForm").serialize();
		var temp = "";

		$.ajax({
			url : '<c:url value="/calcResult.do"/>',
			accepts : {
				text : 'application/json'
			},
			type : 'post',
			data : params,
			dataType : 'json',
			success : function(response) {
				if (response.serverSideSuccessYn == 'Y') {
					//결과페이지 display				
					display(response.result.jsonData);
					//해지환급금 테이블 설정
					//tableReadMore();		
					$('#mainForm>[name="sskey"]').val(
							response.result.jsonData.new_sskey);
				}
			},
			error : function(xhr, status, error) {
				console.log("에러 : " + error + "상태 : " + status);
			}
		});

	};

	//월보험료 세팅
	function getMonthBill() {
		var monthbill = $('input:radio[name="monthbill"]:checked').val();
		if (monthbill == -1) {
			return $('#monthbillTxt').val();
		} else {
			return monthbill;
		}
	}

	//납입기간 세팅
	function getNapgi(mode) {
		var napgiCode = mode.children('input:radio[name="payment"]:checked').val();
		var napgi;
		if (napgiCode == '0') {
			napgi = getBogi();
		} else {
			napgi = napgiCode;
		}
		return napgi;
	}

	//보험기간 세팅
	function getBogi() {
		var bogiCode = $('input:radio[name="bogi"]:checked').val();
		var bogi;
		if (bogiCode.indexOf('X') >= 0) {
			bogi = Number(bogiCode.replace('X', ''))
					- getInsAge($('[name="birthday"]').val());
		} else {
			bogi = Number(bogiCode.replace('N', ''))
		}
		return bogi;
	}

	//계산결과 화면 값 set
	function display(data) {

		/*월보험료 setting*/
		var monthbill = data.u0;

		/*납입 보험료*/
		var napgiStart = data.napgi_start; //납입시작나이 start
		var napgiEnd = data.napgi_end; //납입종료나이 end			

		/*에상 연금액*/
		var bogiStart = data.bogi_start; //예상연금액 start
		var bogiEnd = data.bogi_end; //예상연금액 end	

		/*납입보험료 & 예상수령액 셋팅*/
		var rtnPrice3 = data.rtn_price3; //예상수령액(현공시이율)	
		var stdMinYonRate = data.std_min_yon_rate; //현공시이율		
		var refundRate = splData[108]; //환급율

		/*상세연금액*/
		var rtnPrice1 = data.rtn_price1; //예상수령액(최저보증이율)	
		var rtnPrice2 = data.rtn_price2; //예상수령액(표준)	

		/*결과 화면 set*/
		$('#monthInsurance').val(monthbill);
		$('#resMonthbill').text(monthbill);
		if ($('#resRtnPrice').text(commaNum(replaceNumType(rtnPrice3))) != 'undefined') {
			$("#resRtnPrice_li").show();
			$("#resRtnPrice_recalc").show();
			$("#btn_refund_tbl_li").show();
			$("#btn_refund_fee_li").show();
		}
		;
		$('#resRefundRate').text(refundRate);

		$('#resStdMinYonRate, #resExamStdMinYonRate').text(stdMinYonRate);

		//연금액 안내
		$('#resExamYear').text(new Date().getFullYear()); // 올해
		$('#resExamMonth').text(new Date().getMonth() + 1); // 이번달	

		var detail = data.F; //해지환급금 예시내용
		var jsonPrsTblBody = JSON.parse(detail); //해지환금금 json

	}

	function recalc() {
		if ($("#resRtnPrice").val() != 'undefined') {
			$("#resRtnPrice_li").hide();
			$("#resRtnPrice_recalc").hide();
			$("#btn_refund_tbl_li").hide();
			$("#btn_refund_fee_li").hide();
			$('[name="birthday"]').focus();
			$('#refund').hide();
			$('#refund2').hide();
		}
	}

	//해지환급금 조회
	function getCancelData(type) {
		readGridData('my', '1');
		if (type == 'tbl') {
			if ($('#refund2').hasClass("on")) {
				$('#refund2').removeClass("on");
				$('#refund2').hide();
			}
			$('#refund').addClass("on");
			$('#refund').show();
		} else {
			if ($('#refund').hasClass("on")) {
				$('#refund').removeClass("on");
				$('#refund').hide();
			}
			$('#refund2').addClass("on");
			$('#refund2').show();
		}
	}

	//해지환급금 정보 가져오기
	function readGridData(type, step) {

		var num;
		var curData = new Date();
		var year = String(curData.getFullYear() - 40).substring(2, 4);
		var tmpSsn = year + '0101';
		if (getInsAge(tmpSsn) > 40) {
			var nYear = Number(year) + 1;
			tmpSsn = String(nYear) + '0101';

		} else if (getInsAge(tmpSsn) < 40) {
			var nYear = Number(year) - 1;
			tmpSsn = String(nYear) + '0101';

		}

		if (type == 'my') { // 자신이 직접 입력한 데이터로 해지 환급금을 조회한다.

			//데이터를 정제하여 폼에 넣는다.
			//$('#mainForm>input[name="bjCode"]').val($('input:radio[name="insType"]:checked').val());
			$('#mainForm>input[name="insSsn"]').val(
					$('[name="birthday"]').val());
			$('#mainForm>input[name="insSex"]').val(
					$('input:radio[name="gender02"]:checked').val());
			$('#mainForm>input[name="insAge"]').val(
					getInsAge($('[name="birthday"]').val()));
			$('#mainForm>input[name="insManAge"]').val(
					getManAge($('[name="birthday"]').val()));
			$('#mainForm>input[name="u0"]').val(getMonthBill());
			$('#mainForm>input[name="bogiCode"]').val(
					$('input:radio[name="bogi"]:checked').val());
			$('#mainForm>input[name="napgiCode"]').val(
					$('input:radio[name="payment"]:checked').val());
			$('#mainForm>input[name="healthYn"]').val('Y');
			$('#mainForm>input[name="step"]').val(step);

			num = '01';
		}

		//데이터 조회
		$.ajax({
			type : 'POST',
			accepts : {
				text : 'application/json'
			},
			url : '<c:url value="/calcResultDetail.do"/>',
			data : $('#mainForm').serialize(),
			async : true,
			dataType : 'json',
			success : function(response) {
				if (response.serverSideSuccessYn == 'Y') {
					if (parseInt(step) == 1) {
						//해지환급금
						displayTerminateData(response.result.jsonData, num,
								type);
					}
					if (response.result.jsonData) {
						if (parseInt(step) == 2) {
							//연금액 예시(상품설명 나오면 코딩)
							displayAmountData(response.result.jsonData);
						}
					}
				}
			},
			error : function(xhr, status, error) {
				console.log("에러 : " + error + "상태 : " + status);
			}
		});
	}

	//해지환급금 화면 set
	function displayTerminateData(data, num, type) {
		var nowTime = new Date();

		var stdRate = '';
		var avgStdRate = ''
		var stdMinYonRate = ''

		var detail = data.F; //해지환급금 예시내용
		var guidance = data.K;
		var jsonPrsTblBody = JSON.parse(detail); //해지환급금 Json
		var jsonGuide = JSON.parse(guidance);

		//추후 dummy데이터 때문에 분기부분 남겨 놓음
		if (type == 'my') {

			/*기본비용 및 수수료*/
			if (data) {
				//환급금 테이블 표 표준이율, 현재 공시율
				stdRate = data.std_rate; //표준이율 	->	연복리A
				stdMinYonRate = data.std_min_yon_rate; //현공시이율	->	연복리 B
				avgStdRate = data.avg_std_rate; //평균공시이율

				/*해지 환급금 화면 set*/
				//연금액, 환급금 테이블 표 표준이율, 현재 공시이률 셋
				$('#resStdMinYonRate2, #resStdMinYonRate3, #resStdMinYonRate4, #resStdMinYonRate5, #resStdMinYonRate6')
						.text(stdMinYonRate);
				$('#resStdRate2, #resStdRate3, #resStdRate4').text(stdRate);
				$('#resStdRate3-1').text(avgStdRate);

				// 연도, 월
				$("#year3, #year4, #year5, #year6").text(
						new Date().getFullYear());
				$("#month3, #month4, #month5, #month6").text(
						new Date().getMonth() + 1);
			}

			/* 해지환급금 예시표 테스트(data- attribute 이용, clone() 이용) */
			//json F키 데이터에서 뽑아온 내가 짠 코드(2)
			if (jsonPrsTblBody.F_cnctRcstList.length > 0) {

				if ($('#refund').hasClass("dsc-on") == false) {
					//thead title insert variables
					var jsonTblTitle = jsonPrsTblBody.F_cnctRcstTitl[0];
					var key = Object.keys(jsonTblTitle).sort();

					//tbody grid data append variables
					var $0tr = $('#resRefundAmount0 .template');
					var $1tr = $('#resRefundAmount1 .template');
					var $2tr = $('#resRefundAmount2 .template');
					var list_key = Object
							.keys(jsonPrsTblBody.F_cnctRcstList[0]);

					//thead title insert
					for (var i = 0; i < key.length; i++) {
						$('[data-role-title="title' + i + '"]').text(
								jsonTblTitle[key[i]]);
					}
					$('[data-role-title="test"]').text(jsonTblTitle.tit0);

					//tbody grid data append
					for (var i = 0; i < jsonPrsTblBody.F_cnctRcstList.length; i++) {

						var row = jsonPrsTblBody.F_cnctRcstList[i];

						var am0clone = $0tr.clone();
						var am1clone = $1tr.clone();
						var am2clone = $2tr.clone();

						am0clone.removeClass("template");
						am1clone.removeClass("template");
						am2clone.removeClass("template");

						for (var j = 0; j < list_key.length; j++) {
							var role = list_key[j];
							//키값을 구했기 때문에
							//굳이 switch-case 문으로 나눌 필요가 없다... 바보..
							for (var k in key) {
								am0clone.children('[data-role="' + role + '"]')
										.text(row[role]);
								am1clone.children('[data-role="' + role + '"]')
										.text(row[role]);
								am2clone.children('[data-role="' + role + '"]')
										.text(row[role]);
							}
						}

						$('#resRefundAmount0').append(am0clone);
						$('#resRefundAmount1').append(am1clone);
						$('#resRefundAmount2').append(am2clone);

					}
				} else {
					return;
				}
				$('#refund').addClass("dsc-on");
			}

			if (jsonGuide != null) {
				var standard = jsonGuide.K_guide_fee_dec[0].str;
				var guideFee = jsonGuide.K_guide_fee;
				
				//데이터가 늘어나는 경우 테스트
				//var guideFee2 = jsonGuide.K_guide_fee;
				//var guideFeeCC = guideFee.concat(guideFee2);
				//console.log(guideFeeCC);
				var rowspan = 0;
				standard = standard.substring(1, standard.length - 1);

				$('#resStandard').text(standard);

				//var guideHtml = '';
				//$('#guide_fee').html(guideHtml);

				if(guideFee.length > 0) {
					
					//jQuery를 이용한 표를 만든 이후 표의 정보들을 통해 병합하기
					//헤더가 되는 칼럼의 키값을 정렬하기 위해 키값을 가져오고 정렬 후 객체에 담음
					//아직 행병합은 안되는 상태임. 아래 편 주석 확인할 것
					var key = Object.keys(guideFee[0]).sort();
					var $tr = $('#guide_fee .template');

					for(var i in guideFee) {

						var trCln = $tr.clone();
						trCln.removeClass("template").addClass("fee_info");
						
						for(var j in guideFee[i]) {
							trCln.children('[data-role='+j+']')
								.html(guideFee[i][j].replace("\n","<br/>"));
						}

						$('#guide_fee').append(trCln);
						
					}
					
					//jquery 행병합.. 나중에 다시!! jquery_rowMerge_colMerge_file.jsp 참조
					/* http://interdigm.tistory.com/entry/jquery-%EC%97%B4%EA%B3%BC-%ED%96%89-%EC%9E%90%EB%8F%99%ED%95%A9%EC%B9%98%EA%B8%B0 */
					$('#guide_fee tr:visible').each(function(rows){
						console.log('행 : '+rows);
						var prev;
						$('tr').each(function(row){
							
						});
						
					});
					
					//행병합을 해야되는 첫번째 열(중복의 시작열)에게 클래스를 줘서 구분
					//행병합이 되는 두번째 혹은 그 이후의 열에게도 클래스를 줘서 구분(삭제용)
					//반복이 끝난 후 삭제
					//화이팅!
				}

			}
		}

		//해지환급금 예시안내
		if (detail && detail.length > 0) {

			var infoHtml = '';
			var subCnt = 0;
			var fDown = jsonPrsTblBody.F_cnctRcstDown;
			var fDownSize = fDown.length;

			for (var i = 0; i < fDownSize; i++) {
				var _this = fDown[i];
				var _next = fDown[(i + 1)];
				var isThisSub = (_this.explPrgp.substr(0, 1) == '-' && _this.listMark == '') ? true
						: false;
				var isNextSub = (_next != null && (_next.explPrgp.substr(0, 1) == '-' && _next.listMark == '')) ? true
						: false;

				if (isThisSub) {
					infoHtml += '<li>' + _this.explPrgp.replace(/&nbsp;/gm, '')
							+ '</li>\n';
					if (!isNextSub) {
						infoHtml += '</ul>\n</li>\n';
					}
				} else {
					infoHtml += '<li>';
					infoHtml += _this.listMark + ' '
							+ _this.explPrgp.replace(/&nbsp;/gm, '');
					if (!isNextSub) {
						infoHtml += '</li>\n';
					} else {
						infoHtml += '\n<ul style="list-style-type: none;">\n';
					}
				}
			}

			$('#resRefundInfo').html(infoHtml); //해지환급금 안내문
		}
	}
</script>
</head>
<body>
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
	<fieldset>
		<strong><a href="javascript:select_ins('save')">저축보험</a></strong>
		<strong><a href="javascript:select_ins('term')">정기보험</a></strong>
		<div id="saveCalc">
			<ul id="saveins" style="list-style-type: none;">
				<li>생년월일 : <input type="tel" id="birthday" name="birthday"
					maxlength="6" placeholder="생년월일(예:880704)" /></li>
				<li>성&nbsp;&nbsp;&nbsp;&nbsp;별 : <label>남성 <input
						type="radio" id="gen_m" name="gender02" value="1" /></label><label>여성
						<input type="radio" id="gen_f" name="gender02" value="2" />
				</label></li>
				<li><label>추천조건 설계하기 <input type="checkbox"
						id="pro_check01" /></label>
				<li>납입기간 : <label>2년<input type="radio" id="pay_2"
						name="payment" value="2" /></label> <label>3년<input type="radio"
						id="pay_3" name="payment" value="3" /></label> <label>5년<input
						type="radio" id="pay_5" name="payment" value="5" /></label> <label>7년<input
						type="radio" id="pay_7" name="payment" value="7" /></label> <label>10년<input
						type="radio" id="pay_10" name="payment" value="10" /></label>
				</li>
				<li>월보험료 : <label>10만원<input type="radio"
						id="monthbill_10" name="monthbill" value="10" /></label> <label>20만원<input
						type="radio" id="monthbill_20" name="monthbill" value="20" /></label> <label>30만원<input
						type="radio" id="monthbill_30" name="monthbill" value="30" /></label> <label>직접입력<input
						type="radio" id="monthbill_-1" name="monthbill" value="-1" /></label> <span
					id="monthbill_custom" style="display: none"><input
						type="number" maxlength="4" id="monthbillTxt" name="monthbillTxt"
						oninput="maxLengthCheck(this)" />만원</span>
				</li>
				<li>보험기간 : <label>10년<input type="radio" name="bogi"
						id="bogi_N10" value="N10" checked /></label></li>
				<li style="float: left; margin-right: 10px"><input type="button"
					value="계산 결과" onclick="vali_form('save')"></li>
				<li id="resRtnPrice_recalc" style="display: none"><input
					type="button" value="다시 계산" onclick="recalc()" /></li>
				<li id="resRtnPrice_li" style="display: none"><span
					id="resRtnPrice"></span>원</li>
				<li style="float: left; margin-right: 10px; display: none"
					id="btn_refund_tbl_li"><input type="button"
					value="해지환급금 예시표 조회" onclick="getCancelData('tbl')" /></li>
				<li id="btn_refund_fee_li" style="display: none"><input
					type="button" value="해지환급금 수수료 조회" onclick="getCancelData('fee')" /></li>
			</ul>
		</div>
		<div id="termCalc">
			<ul id="termins" style="list-style-type: none;">
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
				<li>
					보험종류 : 
					<label><input type="radio" id="it1" name="insType" value="ck1" />순수보장형(환급없음)</label>
					<label><input type="radio" id="it2" name="insType" value="ck2" />(만기시)50% 환급형</label>
					<label><input type="radio" id="it3" name="insType" value="ck3" />(만기시)100% 환급형</label>
				</li>
				<li>
					납입금액 : 
					<label><input type="radio" id="insJoinM_05"  name="insJoinM" value="0.5" />5천만원</label>
					<label><input type="radio" id="insJoinM_1" name="insJoinM" value="1" />1억원</label>
					<label><input type="radio" id="insJoinM_2" name="insJoinM" value="2" />2억원</label>
					<label><input type="radio" id="insJoinM_M1" name="insJoinM" value="-1" />직접입력</label>
					<input type="number" value="" style="display: none" id="insJoinMTxt" name="insJoinMTxt" placeholder="1~20" maxlength="2" oninput="maxLengthCheck(this)" title="금액 입력 폼(숫자만 입력)" /><span>천만원</span>
				</li>
				<li>보험기간 : 
					<label><input type="radio" id="bogi_N10" name="bogi" value="N10" /> <span id="bogi_N10_txt" >50세(10년)</span></label>
					<label><input type="radio" id="bogi_X55" name="bogi" value="X55" /> <span id="bogi_X55_txt" >55세</span></label>
					<label><input type="radio" id="bogi_X60" name="bogi" value="X60" /> <span id="bogi_X60_txt" >60세</span></label>
					<label><input type="radio" id="bogi_X65" name="bogi" value="X65" /> <span id="bogi_X65_txt" >65세</span></label>
					<label><input type="radio" id="bogi_X70" name="bogi" value="X70" /> <span id="bogi_X70_txt" >70세</span></label>
					<label><input type="radio" id="bogi_X75" name="bogi" value="X75" /> <span id="bogi_X75_txt" >75세</span></label>
					<label><input type="radio" id="bogi_X80" name="bogi" value="X80" /> <span id="bogi_X80_txt" >80세</span></label>
				</li>
				<li>납입기간 : 
					<label><input type="radio" id="pay_10" name="payment" value="10" /> 10년</label>
					<label><input type="radio" id="pay_20" name="payment" value="20"/> 20년</label>
					<label><input type="radio" id="pay_0"name="payment" value="0" /> 전기납</label>
				</li>
			</ul>
		</div>
	</fieldset>
	<fieldset id="refund" style="display: none">
		<legend style="font-size: 2em">
			<strong>예시표</strong>
		</legend>
		<p class="desc">
			아래 예시된 연복리A <span id="resStdRate3"></span> %는 “금융감독원장이 정하는 바에 따라 산정한
			평균공시이율 <span id="resStdRate3-1"></span> %와 공시이율(저축) <span
				id="resStdMinYonRate3"></span> %(<span id="year3"></span>년 <span
				id="month3"></span> 월 현재) 중 작은 이율을 적용하며, 연복리B <span
				id="resStdMinYonRate4"></span> %는 공시이율(저축) <span id="year4"></span>년
			<span id="month4"></span> 월 현재 <span id="resStdMinYonRate5"></span>%를
			적용합니다.
		</p>
		<br />
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width: 15%" />
				<col style="width: 35%" />
				<col style="width: 35%" />
				<col style="width: 15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;"
						data-role-title="title0"></th>
				</tr>
				<tr>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount0">
				<tr class="template">
					<th style="padding: 10px; border: 1px solid #ddd;"
						data-role="cnctEltrMnth"></th>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="paymPrem"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="mainCnctRcst0"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="mainRfndRato0"></td>
				</tr>
			</tbody>
		</table>
		<br />
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width: 15%" />
				<col style="width: 35%" />
				<col style="width: 35%" />
				<col style="width: 15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;"
						data-role-title="title1"></th>
				</tr>
				<tr>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount1">
				<tr class="template">
					<th style="padding: 10px; border: 1px solid #ddd;"
						data-role="cnctEltrMnth"></th>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="paymPrem"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="mainCnctRcst1"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="mainRfndRato1"></td>
				</tr>
			</tbody>
		</table>
		<br />
		<table style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width: 15%" />
				<col style="width: 35%" />
				<col style="width: 35%" />
				<col style="width: 15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="colgroup" colspan="4"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;"
						data-role-title="title2"></th>
				</tr>
				<tr>
					<th
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">경과기간</th>
					<th
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">납입보험료</th>
					<th
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">해지환급금</th>
					<th
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">환급률</th>
				</tr>
			</thead>
			<tbody id="resRefundAmount2">
				<tr class="template">
					<th style="padding: 10px; border: 1px solid #ddd;"
						data-role="cnctEltrMnth"></th>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="paymPrem"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role="mainCnctRcst2"></td>
					<td
						style="padding: 10px; border: 1px solid #ddd; text-align: right"
						data-role=""></td>
				</tr>
			</tbody>
		</table>

		<ul id="resRefundInfo" style="list-style-type: none;">
		</ul>
	</fieldset>
	<fieldset id="refund2" style="display: none">
		<legend style="font-size: 2em">
			<strong>수수료</strong>
		</legend>
		<span id="resStandard"></span>
		<h3>기본 비용 및 수수료</h3>
		<table id="guide_fee" style="border-collapse: collapse; border-top: 3px solid #168;">
			<colgroup>
				<col style="width: 15%">
				<col style="width: 25%">
				<col style="width: 14%">
				<col style="width: 46%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">구분</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">목적</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">시기</th>
					<th scope="col"
						style="color: #168; background: #f0f6f9; padding: 10px; border: 1px solid #ddd;">비용</th>
				</tr>
			</thead>
			<tbody>
				<tr class="template">
					<th scope="row" style="padding: 10px; border: 1px solid #ddd;" data-role="str0"></th>
					<td style="padding: 10px; border: 1px solid #ddd;" data-role="str1"></td>
					<td style="padding: 10px; border: 1px solid #ddd;" data-role="str2"></td>
					<td style="padding: 10px; border: 1px solid #ddd;" data-role="str3"></td>
				</tr>
			</tbody>
		</table>
		<p>주)경과이자 : 매월 계약해당일의 계약자적립금에서 이미 납입한 보험료를 차감한 금액</p>
	</fieldset>
</body>
</html>