<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>온슈어 계산기</title>
<script src="https://code.jquery.com/jquery-1.9.1.js"
	integrity="sha256-e9gNBsAcA0DBuRWbm0oZfbiCyhjLrI6bmqAl5o+ZjUA="
	crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/comm_compute.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/fave_data.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/fn_display.js"></script>

<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css">
<script type="text/javascript">
var defUrl = "${pageContext.request.contextPath}";
var saveCalResultUrl = defUrl+"/SaveCalResult.do";
var termCalResultUrl = defUrl+"/TermCalResult.do";
var saveCalDetailUrl = defUrl+"/SaveCalDetail.do";
var termCalDetailUrl = defUrl+"/TermCalDetail.do";
var selectInsUrl 	 = defUrl+"/tabChange.do?page=";

var url = '';

//tab-cons div 아래 a 태그들로 탭컨트롤(가지수가 늘어나도 무관)
function select_ins(mode){
	//tabs내 모든 div들을 숨기고
	$('#tabs div').each(function(){
		if($(this).attr("id") == "calculator_exec"){
			return false;			
		}
		$(this).empty().removeClass("calc_this");
	});
	
	url = selectInsUrl+mode;
	
	$('#'+mode).load(url);
	/* , function(respTxt, sttsTxt, xhr){
		if(sttsTxt == "success") 
			console.log("External content loaded Success");
		if(sttsTxt == "error") 
			console.log("Error : "+xhr.status+": "+xhr.statusText);
	} */
	
	//환급금 div 모두 숨기고
	$('#tab-saveRtnResult, #tab-termRtnResult').hide();
	
	//탭컨트롤용 모든 a태그에 select클래스 삭제 및 deselect추가
	$('#tab-cons a').removeClass("selected").addClass("deselect");
	
	//탭컨트롤용 중 선택된 a태그에 select클래스 추가 및 deselect삭제
	$('.'+mode).removeClass("deselect").addClass("selected");
	
	//선택된 tab만 표시
	$('#'+mode).show().addClass("calc_this");

	//계산하기, 다시계산하기 버튼 표시
	$('#calculator_exec').show();
	
	fn_reset();
	
	//선택된 모든 div태그의 하위 input들 모두 초기화(생년월일, 성별은 초기화 안시킴)
	$('#tabs div:not(:visible) input').each(function(){
		$(this).prop("checked",false);
		if($(this).attr("type") == 'number'){
			$(this).val('');
			$(this).parent().hide();
		}
		return;
	});
};

function fn_submit(id) {
	
	var params = $("#mainForm").serialize();

	if(id == 'tab-save'){
		url = saveCalResultUrl;
		
		//결과데이터 가져오기
		ajaxCalSetup(id, url, params);
		
		readGridData(id, 'Y');
		
	}
	else{
		url = termCalResultUrl;
		
		ajaxCalSetup(id, url, params);
		
		readGridData(id, 'N');
		readGridData(id, 'Y');
	}
};

//환급 grid data 읽어오는 함수
function readGridData(id, healthYn){

	//저축보험 -> type : 'save', heathYn : 'y'
	//정기보험 -> type : 'term', heathYn : 'y' or 'n'
	setMainFormData(id,healthYn);
	var params = $('#mainForm').serialize();
	
	if(id == 'tab-save'){//저축보험일 경우
		url = saveCalDetailUrl;
		ajaxCalSetup(id, url, params);
	}
	else{//정기보험일 경우
		url = termCalDetailUrl;
		ajaxCalSetup(id, url, params);
	}
};

$(document).ready(function(){
	
	//첫화면을 저축보험으로 보여준다.
	select_ins('tab-save');
	
	$('#minResult').hide();
	
	var jbOffset = $('.pop-layer').offset();
	$('.pop-layer').scroll(function() {
		if ($(this).scrollTop() > jbOffset.top) {
			$('.pfixed').css({// -20 은 .pop-layer와 pop-container에 적용된 우측 padding값
				"left":$(this).outerWidth()-20+'px'
			});
			$('.btn-r').addClass('pfixed');
		}
		else {
			$('.btn-r').removeClass('pfixed');
		}
	});
	
	$('input:radio[name="gender02"]').on("click",function(){
		$(this).parent().addClass("on");
		$('input:radio[name="gender02"]').each(function(){
			if($(this).prop("checked") == false){
				$(this).parent().removeClass("on");
			}
		});
	});
	
});
</script>
</head>
<body>
	<jsp:include page="tabcon.jsp"/>
	<div id="mask"></div>
	<div class="tab-container">
		<jsp:include page="commonCalc.jsp"/>
		<div id="tabs">
			<div id="tab-save"></div>
			<div id="tab-term"></div>
			<input type="button" value="계산하기" onclick="fn_calc()" />
			<input type="button" value="다시계산" onclick="fn_reset()"/>
		</div>
		<jsp:include page="calcResult.jsp"/>
	</div>
	<jsp:include page="mainform.jsp"/>
</body>
</html>