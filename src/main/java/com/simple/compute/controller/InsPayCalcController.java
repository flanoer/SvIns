package com.simple.compute.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class InsPayCalcController {
	
	@ResponseBody
	@RequestMapping("/calcResult.do")
	public String calcResult(
			@RequestParam String bj,
			@RequestParam String bjCode,
			@RequestParam String u0,
			@RequestParam String insSsn,
			@RequestParam String insSex,
			@RequestParam String insAge,
			@RequestParam String insManAge,
			@RequestParam String napgiCode,
			@RequestParam String bogiCode,
			@RequestParam String healthYn,
			@RequestParam String step,
			@RequestParam String napgi,
			@RequestParam String insuCode,
			@RequestParam String sskey,
			@RequestParam String sendUrlChk,
			@RequestParam String jumpStep,
			@RequestParam String applyType
			) throws Exception {
		
	    String params = "bj="+bj+"&bjCode="+bjCode+"&u0="+u0+"&insSsn="+insSsn+"&insSex="+
						insSex+"&insAge="+insAge+"&insManAge="+insManAge+"&napgiCode="+napgiCode+"&bogiCode="+bogiCode+
						"&healthYn="+healthYn+"&step="+step+"&napgi="+napgi+"&insuCode="+insuCode+"&sskey="+
						sskey+"&sendUrlChk="+sendUrlChk+"&jumpStep="+jumpStep+"&applyType="+applyType;
	    
		URL url = new URL("https://www.onsure.co.kr/m/contract/getSavingsInfo.do");
		
		HttpsURLConnection sconn = (HttpsURLConnection)url.openConnection();
		
		sconn.setRequestMethod("POST");
		sconn.setDoInput(true);
		sconn.setDoOutput(true);

		// 요청 헤더를 정의한다.( 원래 Content-Length값을 넘겨주어야하는데 넘겨주지 않아도 되는것이 이상하다. )
		sconn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		
		OutputStream os = sconn.getOutputStream();
		os.write(params.getBytes("UTF-8"));
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
}