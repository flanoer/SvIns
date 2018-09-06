<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-- 계산결과, 재계산, 해지환급금 -->
<div id="minResult">
	<h3>계산 결과</h3>
	<table id="tab-saveResultTbl">
		<colgroup>
			<col style="width: 40%">
			<col style="width: 20%">
			<col style="width: 20%">
			<col style="width: 20%">
		</colgroup>
		<thead>
			<tr>
				<th>보험명</th>
				<th>납입보험료</th>
				<th>납입방식</th>
				<th>이율</th>
			</tr>
		</thead>
		<tbody>
			<tr class="template">
				<td data-role="insuName"></td>
				<td data-role="prem"></td>
				<td data-role="paym"></td>
				<td data-role="iyul"></td>
			</tr>
		</tbody>
	</table>
	<table id="tab-termResultTbl">
		<colgroup>
			<col style="width: 40%">
			<col style="width: 20%">
			<col style="width: 20%">
			<col style="width: 20%">
		</colgroup>
		<thead>
			<tr>
				<th>보험명</th>
				<th>일반고객</th>
				<th>건강고객</th>
				<th>납입방식</th>
			</tr>
		</thead>
		<tbody>
			<tr class="template">
				<td data-role="insuName"></td>
				<td data-role="prem"></td>
				<td data-role="h_healthPrice"></td>
				<td data-role="paym"></td>
			</tr>
		</tbody>
	</table>
	<table id="minResultTbl2">
		<colgroup>
			<col style="width: 40%">
			<col style="width: 20%">
			<col style="width: 40%">
		</colgroup>
		<thead>
			<tr>
				<th>납부기간</th>
				<th>만기</th>
				<th>만기보험금</th>
			</tr>
		</thead>
		<tbody>
			<tr class="template">
				<td data-role="paymTermK"></td>
				<td data-role="intr"></td>
				<td data-role=""></td>
			</tr>
		</tbody>
	</table>
	<br /> <strong id="reCal"></strong>
	<ul id="reCalTxt" style="display: inline">
		<li id="monthbill_recustom" style="display: inline"><input
			type="number" maxlength="4" id="monthbillReTxt" name="monthbillReTxt"
			oninput="maxLengthCheck(this)" /></li>
		<li id="insJoinM_recustom" style="display: inline"><input
			type="number" id="insJoinMReTxt" name="insJoinMReTxt"
			placeholder="1~20" maxlength="2" oninput="maxLengthCheck(this)" /></li>
	</ul>
	<span id="unit"></span> <input id="recalc" type="button" value="재계산"
		onclick="fn_calc()" />
	<div id="tab-saveRtnResult" style="display: none">
		<h5>해지환급금/만기보험금 안내</h5>
		<input type="button" value="예시표" onclick="getCancelData('exmtbl')" />
		<input type="button" value="수수료" onclick="getCancelData('feetbl')" />
	</div>
	<div id="tab-termRtnResult" style="display: none">
		<h5>해지환급금 안내</h5>
		<input type="button" value="예시표" onclick="getCancelData('exmtbl2')" />
	</div>
	<!--// content-->
</div>

<div id="refund_exmtbl" class="pop-layer">
	<div class="btn-r">
		<a href="#" class="btn-layerClose">Close</a>
	</div>
	<div class="pop-container">
		<div class="pop-conts">
			<div class="tbl">
				<h2>예시표</h2>
				<p class="desc">
					아래 예시된 연복리A <span id="resStdRate3"></span> %는 “금융감독원장이 정하는 바에 따라
					산정한 평균공시이율 <span id="resStdRate3-1"></span> %와 공시이율(저축) <span
						id="resStdMinYonRate3"></span> %(<span id="year3"></span>년 <span
						id="month3"></span> 월 현재) 중 작은 이율을 적용하며, 연복리B <span
						id="resStdMinYonRate4"></span> %는 공시이율(저축) <span id="year4"></span>년
					<span id="month4"></span> 월 현재 <span id="resStdMinYonRate5"></span>%를
					적용합니다.
				</p>
				<br />
				<table id="resRefundAmount0">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="colgroup" colspan="4" data-role-title="title0"></th>
						</tr>
						<tr>
							<th scope="col">경과기간</th>
							<th scope="col">납입보험료</th>
							<th scope="col">해지환급금</th>
							<th scope="col">환급률</th>
						</tr>
					</thead>
					<tbody>
						<tr class="template">
							<th data-role="cnctEltrMnth"></th>
							<td data-role="paymPrem"></td>
							<td data-role="mainCnctRcst0"></td>
							<td data-role="mainRfndRato0"></td>
						</tr>
					</tbody>
				</table>
				<br />
				<table id="resRefundAmount1">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="colgroup" colspan="4" data-role-title="title1"></th>
						</tr>
						<tr>
							<th scope="col">경과기간</th>
							<th scope="col">납입보험료</th>
							<th scope="col">해지환급금</th>
							<th scope="col">환급률</th>
						</tr>
					</thead>
					<tbody>
						<tr class="template">
							<th data-role="cnctEltrMnth"></th>
							<td data-role="paymPrem"></td>
							<td data-role="mainCnctRcst1"></td>
							<td data-role="mainRfndRato1"></td>
						</tr>
					</tbody>
				</table>
				<br />
				<table id="resRefundAmount2">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 35%" />
						<col style="width: 35%" />
						<col style="width: 15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="colgroup" colspan="4" data-role-title="title2"></th>
						</tr>
						<tr>
							<th>경과기간</th>
							<th>납입보험료</th>
							<th>해지환급금</th>
							<th>환급률</th>
						</tr>
					</thead>
					<tbody>
						<tr class="template">
							<th data-role="cnctEltrMnth"></th>
							<td data-role="paymPrem"></td>
							<td data-role="mainCnctRcst2"></td>
							<td data-role="mainRfndRato2"></td>
						</tr>
					</tbody>
				</table>

				<ul id="resRefundInfo" style="list-style-type: none;">
				</ul>
			</div>
		</div>
	</div>
</div>

<div id="refund_exmtbl2" class="pop-layer">
	<div class="btn-r">
		<a href="#" class="btn-layerClose">Close</a>
	</div>
	<div class="pop-container">
		<div class="pop-conts">
			<div class="tbl">
				<h2>예시표</h2>
				<br />
				<div>
					<strong><a class="normal" href="javascript:select_health('normal')">일반고객</a></strong>
					<strong><a class="health" href="javascript:select_health('health')">건강고객</a></strong>
				</div>
				<div class="tab-container">
					<table id="normal_table">
						<colgroup>
							<col style="width: 15%" />
							<col style="width: 35%" />
							<col style="width: 35%" />
							<col style="width: 15%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">경과기간</th>
								<th scope="col">납입보험료</th>
								<th scope="col">해지환급금</th>
								<th scope="col">환급률</th>
							</tr>
						</thead>
						<tbody>
							<tr class="template">
								<th data-role="0"></th>
								<td data-role="1"></td>
								<td data-role="2"></td>
								<td data-role="3"></td>
							</tr>
						</tbody>
					</table>
					<table id="health_table">
						<colgroup>
							<col style="width: 15%" />
							<col style="width: 35%" />
							<col style="width: 35%" />
							<col style="width: 15%" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">경과기간</th>
								<th scope="col">납입보험료</th>
								<th scope="col">해지환급금</th>
								<th scope="col">환급률</th>
							</tr>
						</thead>
						<tbody>
							<tr class="template">
								<th data-role="0"></th>
								<td data-role="1"></td>
								<td data-role="2"></td>
								<td data-role="3"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<ul id="resRefundInfo" style="list-style-type: none;">
				</ul>
			</div>
		</div>
	</div>
</div>

<div id="refund_feetbl" class="pop-layer">
	<div class="btn-r">
		<a href="#" class="btn-layerClose">Close</a>
	</div>
	<div class="pop-container">
		<div class="pop-conts">
			<div class="tbl">
				<h2>수수료</h2>
				<span id="resStandard"></span>
				<h3>기본 비용 및 수수료</h3>
				<table id="guide_fee">
					<colgroup>
						<col style="width: 15%">
						<col style="width: 25%">
						<col style="width: 14%">
						<col style="width: 46%">
					</colgroup>
					<thead>
						<tr>
							<th scope="col">구분</th>
							<th scope="col">목적</th>
							<th scope="col">시기</th>
							<th scope="col">비용</th>
						</tr>
					</thead>
					<tbody>
						<tr class="template">
							<th scope="row" data-role="str0"></th>
							<td data-role="str1"></td>
							<td data-role="str2"></td>
							<td data-role="str3"></td>
						</tr>
					</tbody>
				</table>
				<p>주)경과이자 : 매월 계약해당일의 계약자적립금에서 이미 납입한 보험료를 차감한 금액</p>
			</div>
		</div>
	</div>
</div>