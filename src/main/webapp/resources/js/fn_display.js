//대략적 결과값 표시(레이어 팝업 이용)
function display(data, id) {
	
	var a_data = JSON.parse(data.A);
	var c_data = JSON.parse(data.B);
	var b_data = JSON.parse(data.C);
	var d_data = JSON.parse(data.D);
	var e_data = JSON.parse(data.E);
	var f_data = JSON.parse(data.F);
	
	$('#tab-saveResultTbl').hide();
	$('#tab-termResultTbl').hide();
	$('#monthbill_recustom').hide();
	$('#insJoinM_recustom').hide();
	
	var d_data_key = Object.keys(d_data.D_main[0]).sort();
	var d_data_inside = d_data.D_main[0];

	var $tblCln = $('#'+id+'ResultTbl .template').clone();
	var $tblCln2 = $('#minResultTbl2 .template').clone();
	$('#'+id+'ResultTbl .cln').remove();
	$('#minResultTbl2 .cln').remove();
	
	$tblCln.removeClass("template").addClass("cln");
	$tblCln2.removeClass("template").addClass("cln");
	
	if(id == 'tab-save'){//저축보험
		$tblCln2.children('[data-role=""]')
			.attr("data-role","mainCnctRcst2")
			.text(f_data.F_cnctRcstList[f_data.F_cnctRcstList.length-1].mainCnctRcst2+"원");
		
		$('#reCal').html('월 납입금');
		$('#monthbill_recustom').show();
		$('#unit').html('만원');
		$('#'+id+"RtnResult").show();
	}
	else{//정기보험
		$tblCln.children('[data-role="h_healthPrice"]')
			.text(data.h_healthPrice);
	
		$tblCln2.children('[data-role=""]')
			.attr("data-role","str2")
			.text(e_data.E_prstList[e_data.E_prstList.length-1].str2);
		
		$('#reCal').html('보장금액');
		$('#insJoinM_recustom').show();
		$('#unit').html('천만원');
		$('#'+id+"RtnResult").show();
	}
	
	for(var dkey in d_data_inside){
		$tblCln.children('[data-role="'+dkey+'"]')
			.text(d_data_inside[dkey]);
		$tblCln2.children('[data-role="'+dkey+'"]')
			.text(d_data_inside[dkey]);
	}
	
	$('#'+id+'ResultTbl tbody').append($tblCln);
	$('#minResultTbl2 tbody').append($tblCln2);
	
	$('#'+id+'ResultTbl').show();
	$('#minResult').show();
	
}

//해지환급금 화면 set
function displayTerminateData(data, id) {
	var nowTime = new Date();

	var stdRate = '';
	var avgStdRate = '';
	var stdMinYonRate = '';
	
	if(id == 'tab-save'){
		var detail = data.F; //해지환급금 예시내용
		var jsonPrsTblBody = JSON.parse(detail); //해지환급금 Json
		
		var guidance = data.K;
		var jsonGuide = JSON.parse(guidance);
		
		/*기본비용 및 수수료*/
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

		/* 해지환급금 예시표 테스트(data- attribute 이용, clone() 이용) */
		//json F키 데이터에서 뽑아온 내가 짠 코드(2)
		if (jsonPrsTblBody.F_cnctRcstList.length > 0) {
			
			//thead title insert variables
			var jsonTblTitle = jsonPrsTblBody.F_cnctRcstTitl[0];
			var key = Object.keys(jsonTblTitle).sort();

			$('#resRefundAmount0 tbody .cln').remove();
			$('#resRefundAmount1 tbody .cln').remove();
			$('#resRefundAmount2 tbody .cln').remove();
			
			//tbody grid data append variables
			var $0tr = $('#resRefundAmount0 tbody .template');
			var $1tr = $('#resRefundAmount1 tbody .template');
			var $2tr = $('#resRefundAmount2 tbody .template');
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

				am0clone.removeClass("template").addClass('cln');
				am1clone.removeClass("template").addClass('cln');
				am2clone.removeClass("template").addClass('cln');

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

				$('#resRefundAmount0 tbody').append(am0clone);
				$('#resRefundAmount1 tbody').append(am1clone);
				$('#resRefundAmount2 tbody').append(am2clone);
			}
			
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

				$('.fee_info').remove();
				
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
	else{//tab-term 일때 해지환급금 - 일반과 건강고객으로 나뉜다.
		if (data.terminateData.length > 0) {
			
			//thead title insert variables
			var key = Object.keys(data.terminateData[0]).sort();

			
			//tbody grid data append variables
			var $0tr = $('#normal_table tbody .template');
			var $1tr = $('#health_table tbody .template');

			if(data.jsonData.isHealth == 'N'){//일반고객
				$('#normal_table tbody .cln').remove();
				//tbody grid data append
				for (var i = 0; i < data.terminateData.length; i++) {

					var row = data.terminateData[i];

					var am0clone = $0tr.clone();

					am0clone.removeClass("template").addClass('cln');

					for (var k in key) {
						am0clone.children('[data-role="'+k+'"]')
								.text(row[k]);
					}

					$('#normal_table tbody').append(am0clone);
				}
				$('#normal_table').hide();
			}
			else{
				$('#health_table tbody .cln').remove();
				//tbody grid data append
				for (var i = 0; i < data.terminateData.length; i++) {

					var row = data.terminateData[i];

					var am1clone = $1tr.clone();

					am1clone.removeClass("template").addClass('cln');

					for (var k in key) {
						am1clone.children('[data-role="'+k+'"]')
								.text(row[k]);
					}

					$('#health_table tbody').append(am1clone);
				}
				$('#health_table').hide();
			}
		}
	}
};