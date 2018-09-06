package com.simple.compute.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.junit.runner.Request;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.simple.compute.HomeController;

@Controller
public class InsPayCalcController {

	private static final Logger logger = LoggerFactory.getLogger(InsPayCalcController.class);
	
	//tab-control용
	@RequestMapping("/tabChange.do")
	public String tabChange(
			@RequestParam(value="page") String pname) { return pname; }
	
	//ajax 에서 폼에 담긴 정보를 serialize해서 가져올 때 그 정보를 파라미터별로 따로 받지 않고 
	//한번에 받아서 string객체에 저장할 수 있게 한다. @RequestBody
	//@RequestBody 로 데이터를 한번에 받아올 수는 있으나 받아온 데이터에 대한 검증이 불편해지며
	//null 이나 빈문자열에 해당하는 키값을 알고 싶을 때 번거로울 수 있다.
	//한마디로 편하다고 좋기만 한건 아니라는 거!!!
	
	/**
	 * 저축보험 결과
	 * @param 개인정보 및 보험상품 선택에 관한 데이터들
	 * @return JSON String
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/SaveCalResult.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String saveCalResult(@RequestBody String paramData) throws Exception {
		
		URL url = new URL("https://www.onsure.co.kr/m/contract/getSavingsInfo.do");
		
		return commonCalc(paramData, url, null);
	}
	
	/**
	 * 저축보험 환급
	 * @param 개인정보 및 보험상품 선택에 관한 데이터들
	 * @return JSON String
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/SaveCalDetail.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String SaveCalDetail(@RequestBody String paramData) throws Exception {
		
		URL url = new URL("https://www.onsure.co.kr/contract/getSavingsGridData.do");
		
		return commonCalc(paramData, url, null);
	}
	
	/**
	 * 정기보험 결과
	 * @param 개인정보 및 보험상품 선택에 관한 데이터들
	 * @return JSON String
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/TermCalResult.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String termCalResult(@RequestBody String paramData) throws Exception{
		
		URL url = new URL("https://www.onsure.co.kr/m/contract/getTermInfo.do");

		return commonCalc(paramData, url, null);
	}
	
	/**
	 * 정기보험 해지환급
	 * @param 개인정보 및 보험상품 선택에 관한 데이터들
	 * @return JSON String
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value="/TermCalDetail.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String termCalDetail(@RequestBody String paramData) throws Exception{
		
		URL url = new URL("https://www.onsure.co.kr/contract/getTermGridData.do");
		
		return commonCalc(paramData, url, null);
	}
	
	/**
	 * 반복되는 코딩 삭제, 메소드로 합침.
	 * @param 개인정보 및 보험상품에 관련된 데이터
	 * @param 데이터에 대한 결과를 받아올 수 있는 url
	 * @param JSON객체
	 * @return JSON String
	 * @throws Exception
	 */
	public String commonCalc(String paramData, URL url, JSONObject jobj) throws Exception{
		
		HttpsURLConnection sconn = (HttpsURLConnection)url.openConnection();
		
		sconn.setRequestMethod("POST");
		sconn.setDoInput(true);
		sconn.setDoOutput(true);

		sconn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		
		OutputStream os = sconn.getOutputStream();
		os.write(paramData.getBytes("UTF-8"));
		os.flush();
		os.close();

	    BufferedReader br = new BufferedReader(
	    		new InputStreamReader(sconn.getInputStream(),"UTF-8"));
	    
	    String bf;
	    
	    JSONParser jp = new JSONParser();
	    
	    while((bf = br.readLine()) != null) jobj = (JSONObject)jp.parse(bf);
		
	    br.close();
		
		return jobj.toJSONString();
	}
}