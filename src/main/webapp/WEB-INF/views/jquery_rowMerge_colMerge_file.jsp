<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>  
<HEAD>  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<TITLE>New Document</TITLE>  
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>  
<style>  
.merge { background-color:#FF0; color:#03F; text-align:center}  
</style>  
<script type="text/javascript">  
  
  
/*   
 *   
 * 같은 값이 있는 열을 병합함  
 *   
 * 사용법 : $('#테이블 ID').rowspan(0);  
 *   
 */       
$.fn.rowspan = function(colIdx, isStats) {         
    return this.each(function(){        
    	//colIdx 는 사실상 tr인 행 전체를 뜻한다.
        var that;       
        $('tr', this).each(function(row) {
        	console.log("로우 : "+row);
        	console.log("열인덱스 : "+colIdx);
            $('td',this).eq(colIdx).filter(':visible').each(function(col) {
            	  console.log("열 : "+col);
                if ($(this).html() == $(that).html()  
                    && (!isStats   
                            || isStats && $(this).prev().html() == $(that).prev().html()  
                            )  
                    ) {              
                    rowspan = $(that).attr("rowspan") || 1;  
                    rowspan = Number(rowspan)+1;  
  
                    $(that).attr("rowspan",rowspan);  
                      
                    // do your action for the colspan cell here              
                    $(this).hide();  
                      
                    //$(this).remove();   
                    // do your action for the old cell here  
                      
                } else {              
                    that = this;           
                }            
                  
                // set the that if not already set  
                that = (that == null) ? this : that;        
            });       
        });      
    });    
};   
  
  
/*   
 *   
 * 같은 값이 있는 행을 병합함  
 *   
 * 사용법 : $('#테이블 ID').colspan (0);  
 *   
 */     
/* 
 $.fn.colspan = function(rowIdx) {  
    return this.each(function(){  
          
 var that;  
  $('tr', this).filter(":eq("+rowIdx+")").each(function(row) {  
  $(this).find('td').filter(':visible').each(function(col) {  
      if ($(this).html() == $(that).html()) {  
        colspan = $(that).attr("colSpan");  
        if (colspan == undefined) {  
          $(that).attr("colSpan",1);  
          colspan = $(that).attr("colSpan");  
        }  
        colspan = Number(colspan)+1;  
        $(that).attr("colSpan",colspan);  
        $(this).hide(); // .remove();  
      } else {  
        that = this;  
      }  
      that = (that == null) ? this : that; // set the that if not already set  
  });  
 });  
  
 });  
}  
  
 */  
  
  
  
</script>  
</HEAD>  
  
<BODY>  
<table border="1" id="listTable">  
  <tr>  
    <th width="60">hy1</th>  
    <th width="60">a1</th>  
    <th width="60">a1</th>  
    <th width="60">a1</th>  
    <th width="60">a1</th>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">1.1</td>  
    <td width="60" class="merge">2.1</td>  
    <td width="60" class="merge">2.1</td>  
    <td width="60" class="merge">2.1</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">&nbsp;</td>  
    <td width="60">&nbsp;</td>  
    <td width="60">6</td>  
    <td width="60">6</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60" class="merge">8</td>  
    <td width="60" class="merge">8</td>  
    <td width="60" class="merge">8</td>  
    <td width="60" class="merge">8</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">10</td>  
    <td width="60">11</td>  
    <td width="60">12</td>  
    <td width="60">12</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">13</td>  
    <td width="60">11</td>  
    <td width="60">15</td>  
    <td width="60">15</td>  
  </tr>  
  <tr>  
    <th width="60">hy2</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
  <tr>  
    <th width="60">hy2</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
  <tr>  
    <th width="60">hy1</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
  <tr>  
    <th width="60">hy2</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
  <tr>  
    <th width="60">hy2</th>  
    <td width="60">1</td>  
    <td width="60">2</td>  
    <td width="60">3</td>  
    <td width="60">3</td>  
  </tr>  
</table>  
<script type="text/javascript">  
$(document).ready(function() {  
/*   
 * 특정행을 지정할때는 rowspan(행수)  
 * $('#listTable ID').rowspan(0);  
 */  
	$('table tbody tr:visible').each(function(cols) {  
		console.log(cols);
	   $('#listTable').rowspan(cols);  
	});  
  
});  
</script>  
  
</BODY>  
</HTML>  

