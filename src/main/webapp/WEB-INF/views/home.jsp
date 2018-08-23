<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
	
<script	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>	
</head>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
<div id="test"></div>

<script type="text/javascript">
	var table = document.createElement("TABLE");
	for(var i = 0; i < 4 ; i++){
		var row = document.createElement("TR");
		for(var j = 0; j < 4 ; j++){
			var col = document.createElement("TD");
			col.appendChild(document.createTextNode("values"));
			row.appendChild(col);
		}
		table.appendChild(row);
	}
	console.log(typeof table);
	test.appendChild(table);
</script>
<table>
	<tr>
		<td rowspan="3">a</td>
		<td>a</td>
		<td rowspan="3">a</td>
		<td>a</td>
	</tr>
	<tr>
		<td>a</td>
		<td>a</td>
	</tr>
	<tr>
		<td>a</td>
		<td>a</td>
	</tr>
	<tr>
		<td>a</td>
		<td>a</td>
		<td>a</td>
		<td>a</td>
	</tr>
</table>

<div id="data_attr_test"></div>
<button type="button" id="btn">실행</button>
<script>
	$('#btn').on('click',function(){
		$("#data_attr_test").text("성공");		
		$("#data_attr_test").attr("data-test",'success');
		$("#data_attr_test").text("성공2");		
	});
</script>
</body>
</html>
