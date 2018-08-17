function maxLengthCheck(obj){
	if(obj.value.length > obj.maxLength){
		obj.value = obj.value.slice(0,obj.maxLength);
	}
};

/**
 * 보험 나이 계산
 * @param oJumin
 * @returns
 */
function getInsAge(oJumin)
{
	var yBirth;
	if (oJumin.substring(0,1)==0 || oJumin.substring(0,1)==1 )
	{
		yBirth = parseFloat(oJumin.substr(0,2)) + 2000;  // 생년월일
	}
	else
	{
		yBirth = parseFloat(oJumin.substr(0,2)) + 1900;  // 생년월일
	}
	var mBirth = parseFloat(oJumin.substr(2,2));
	var dBirth = parseFloat(oJumin.substr(4,2));
	
	var today = (typeof testStanDardDate == "undefined") ? '' : testStanDardDate;
	var yToday = '';
	var mToday = '';
	var dToday = '';
	
	if (today == '' || today.length < 8) {
		var curDate = new Date();        // 오늘
		yToday = curDate.getFullYear();	//getFullYear()는 ie, 파폭, 크롬에서 같은값 호출
		mToday = curDate.getMonth() + 1;
		dToday = curDate.getDate();		
		
	} else {
		yToday = parseInt(today.substring(0, 4), 10);
		mToday = parseInt(today.substring(4, 6), 10);
		dToday = parseInt(today.substring(6,8), 10);
	}

	var yDiff = yToday - yBirth;
	var mDiff = mToday - mBirth - (dToday < dBirth? 1: 0);

	if(mDiff < 0) mDiff += 12, --yDiff;
	if(yDiff < 0) return true;
	
	if(mDiff == 5 && dToday < dBirth && dToday == lastDay(yToday,mToday)) ++mDiff;
	
	oInsAge = yDiff + (6 <= mDiff? 1: 0);	
	return oInsAge;
};

/**
 * 만 나이 계산
 * @param oJumin
 * @returns
 */
function getManAge(oJumin)
{
	var yBirth;
	if (oJumin.substring(0,1)==0 || oJumin.substring(0,1)==1 )
	{
		yBirth = parseFloat(oJumin.substr(0,2)) + 2000;  // 생년월일
	}
	else
	{
		yBirth = parseFloat(oJumin.substr(0,2)) + 1900;  // 생년월일
	}
	var mBirth = parseFloat(oJumin.substr(2,2));
	var dBirth = parseFloat(oJumin.substr(4,2));
	
	var today = (typeof testStanDardDate == "undefined") ? '' : testStanDardDate;
	var yToday = '';
	var mToday = '';
	var dToday = '';	
	
	if (today == '' || today.length < 8) {
		var curDate = new Date();        // 오늘
		yToday = curDate.getFullYear();	//getFullYear()는 ie, 파폭, 크롬에서 같은값 호출
		mToday = curDate.getMonth() + 1;
		dToday = curDate.getDate();		
		
	} else {
		yToday = parseInt(today.substring(0, 4), 10);
		mToday = parseInt(today.substring(4, 6), 10);
		dToday = parseInt(today.substring(6,8), 10);
	}	
	var yDiff = yToday - yBirth;
	var mDiff = mToday - mBirth - (dToday < dBirth? 1: 0);

	if(mDiff < 0) mDiff += 12, --yDiff;
	if(yDiff < 0) return true;
	
	oManAge = yDiff;
	return oManAge;
};

//저축 관련 validate
function savingsValidate(jumin){
	if(getManAge(jumin) < 19 || getInsAge(jumin) > 69) {
		alert('만 19세 ~ 69세까지 가입할 수 있습니다');
		$('[name="birthday"]').val('');
		$('[name="birthday"]').focus();
		return false;
	}
};

function replaceNumType(str){
	
	var returnVal = 0;
	
	var regex = /[^0-9]/g;
	returnVal = str.replace(regex,"");
	
	if(str.indexOf("*")>-1) {
		return str;
	} else {
		return Number(returnVal);
	}
};

function commaNum(number) {	
	number = String(number);
	var len = number.length;
	var point = len % 3;
	var str = number.substring(0, point);
	while(point < len) {
		if(str != '') { str += ','; }
		str += number.substring(point, point + 3);
		point += 3;
	}
	return str;
};

function lastDay(year, month){
	switch(month){
		case 2:  return year % 4 == 0? 29: 28;
		case 4:
		case 6:
		case 9:
		case 11: return 30;
		default: return 31;
	}
}

/*
 * 정확한 생년월일 판별
 */
function birthChecking(jumin) {
	var month = Number(jumin.substr(2,2));
	var day= Number(jumin.substr(4,2));

	if(month > 12 || day > 31) {
		return false;
	}
	if(month < 0 || month > 12) {
		return false;
	}
	switch(month) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			if(day >31) {
				return false;
			}
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			if(day >30) {
				return false;
			}
			break;
		case 2 : 
			if(day>29) {
				return false;
			}
			break;
	}		
	return true;			
}