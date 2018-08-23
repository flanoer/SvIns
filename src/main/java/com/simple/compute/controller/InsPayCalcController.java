package com.simple.compute.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.junit.runner.Request;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class InsPayCalcController {
	
	@ResponseBody
	@RequestMapping(value="/calcResult.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String calcResult(@RequestBody String paramData) throws Exception {
		
		//ajax 에서 폼에 담긴 정보를 serialize해서 가져올 때 그 정보를 파라미터별로 따로 받지 않고 
		//한번에 받아서 string객체에 저장할 수 있게 한다. @RequestBody
		//System.out.println(paramData);
		
		URL url = new URL("https://www.onsure.co.kr/m/contract/getSavingsInfo.do");
		
		HttpsURLConnection sconn = (HttpsURLConnection)url.openConnection();
		
		sconn.setRequestMethod("POST");
		sconn.setDoInput(true);
		sconn.setDoOutput(true);

		// 요청 헤더를 정의한다.( 원래 Content-Length값을 넘겨주어야하는데 넘겨주지 않아도 되는것이 이상하다. )
		sconn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		
		OutputStream os = sconn.getOutputStream();
		os.write(paramData.getBytes("UTF-8"));
		os.flush();
		os.close();

	    BufferedReader br = new BufferedReader(
	    		new InputStreamReader(sconn.getInputStream(),"UTF-8"));
	    
	    String bf;
	    
	    JSONParser jp = new JSONParser();
	    JSONObject obj = null;
	    
	    while((bf = br.readLine()) != null) {
//	    	System.out.println(bf);
	    	obj = (JSONObject)jp.parse(bf);
	    }
		
	    br.close();
	    
		return obj.toJSONString();
	}
	
	@ResponseBody
	@RequestMapping(value="/calcResultDetail.do",method=RequestMethod.POST,produces="text/json; charset=UTF-8")
	public String calcResultDetail(@RequestBody String paramData) throws Exception {
		
		URL url = new URL("https://www.onsure.co.kr/contract/getSavingsGridData.do");
		
		HttpsURLConnection sconn = (HttpsURLConnection)url.openConnection();
		
		sconn.setRequestMethod("POST");
		sconn.setDoInput(true);
		sconn.setDoOutput(true);

		// 요청 헤더를 정의한다.( 원래 Content-Length값을 넘겨주어야하는데 넘겨주지 않아도 되는것이 이상하다. )
		sconn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		
		OutputStream os = sconn.getOutputStream();
		os.write(paramData.getBytes("UTF-8"));
		os.flush();
		os.close();

	    BufferedReader br = new BufferedReader(
	    		new InputStreamReader(sconn.getInputStream(),"UTF-8"));
	    
	    String bf;
	    
	    JSONParser jp = new JSONParser();
	    JSONObject obj = null;
	    
	    while((bf = br.readLine()) != null) {
	    	obj = (JSONObject)jp.parse(bf);
	    }
		
	    br.close();
	    
		return obj.toJSONString();
	}
}