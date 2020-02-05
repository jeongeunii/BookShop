<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="bookshop.shopping.BuyMonthDataBean"%>
<%@ page import="bookshop.shopping.BuyDBBean"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>

<%
	request.setCharacterEncoding("utf-8");

	String managerId = "";
	try {
		managerId = (String) session.getAttribute("managerId");
		if (managerId == null || managerId.equals("")) {
			response.sendRedirect("../logon/managerLoginForm.jsp");
		} else {
			String year = request.getParameter("year");

			BuyMonthDataBean buyMonthList = null;
			BuyDBBean buyProcess = BuyDBBean.getInstance();
			buyMonthList = buyProcess.buyMonth(year);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="../../css/morris.css" rel="stylesheet">
<script src="../../js/jquery-3.4.1.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<script src="../../js/morris.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<style>
#tt, #dd, #cc {
	margin-top: 20px;
}
#mychart {
	margin-top: 50px;
}
</style>
<title>월별 판매 현황</title>
</head>
<body>

	<div class="container" id="cc">
	    <h2 align="center" style="margin-bottom: 40px;"><b><%=year%>년도 월별 판매 현황</b></h2>
	    <form action="monthStatsForm.jsp" class="form-horizontal" role="form" method="post" name="monthStatsForm">
	        <div class="form-group" style="text-align: center;" id="dd">
	            <div class="col-sm-1">
	                <h4><span class="label label-info">검색년도</span></h4>
	            </div>
	            <div class="col-sm-2">
	                <input type="text" class="form-control" id="year" name="year" placeholder="Enter Year" maxlength="4">
	            </div>
	            <div class="col-sm-2">
	                <input type="submit" class="btn btn-danger btn-sm" value="검색하기">
	                <input type="button" class="btn btn-info btn-sm" value="메인으로" onclick="javascript:window.location='../managerMain.jsp'">
	            </div>
	        </div>
	        <table class="table table-bordered border=1" width="700" cellsapcing="0" cellpadding="0" align="center" id="tt">
                <thead>
                    <tr class="info" height="30">
                        <td align="center">1월</td>
                        <td align="center">2월</td>
                        <td align="center">3월</td>
                        <td align="center">4월</td>
                        <td align="center">5월</td>
                        <td align="center">6월</td>
                        <td align="center">7월</td>
                        <td align="center">8월</td>
                        <td align="center">9월</td>
                        <td align="center">10월</td>
                        <td align="center">11월</td>
                        <td align="center">12월</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td align="center"><%=buyMonthList.getMonth01()%></td>
                        <td align="center"><%=buyMonthList.getMonth02()%></td>
                        <td align="center"><%=buyMonthList.getMonth03()%></td>
                        <td align="center"><%=buyMonthList.getMonth04()%></td>
                        <td align="center"><%=buyMonthList.getMonth05()%></td>
                        <td align="center"><%=buyMonthList.getMonth06()%></td>
                        <td align="center"><%=buyMonthList.getMonth07()%></td>
                        <td align="center"><%=buyMonthList.getMonth08()%></td>
                        <td align="center"><%=buyMonthList.getMonth09()%></td>
                        <td align="center"><%=buyMonthList.getMonth10()%></td>
                        <td align="center"><%=buyMonthList.getMonth11()%></td>
                        <td align="center"><%=buyMonthList.getMonth12()%></td>
                    </tr>
                    <tr class="danger">
                        <td align="right" colspan="12">
                            <h3><p class="bg-danger">총 판매수량 : <%=buyMonthList.getTotal()%></p></h3>
                        </td>
                    </tr>
                </tbody>
	        </table>
	    </form>
	    
	<div id="mychart" style="height: 400px; text-align: center;"></div>
	
	</div>
	
	
	<script>
		var m01 = <%=year%> + "-01";
		var m02 = <%=year%> + "-02";
		var m03 = <%=year%> + "-03";
		var m04 = <%=year%> + "-04";
		var m05 = <%=year%> + "-05";
		var m06 = <%=year%> + "-06";
		var m07 = <%=year%> + "-07";
		var m08 = <%=year%> + "-08";
		var m09 = <%=year%> + "-09";
		var m10 = <%=year%> + "-10";
		var m11 = <%=year%> + "-11";
		var m12 = <%=year%> + "-12";
		
		new Morris.Line({
			element: 'mychart',
			data: [
				{year: m01, value: <%=buyMonthList.getMonth01()%>},
				{year: m02, value: <%=buyMonthList.getMonth02()%>},
				{year: m03, value: <%=buyMonthList.getMonth03()%>},
				{year: m04, value: <%=buyMonthList.getMonth04()%>},
				{year: m05, value: <%=buyMonthList.getMonth05()%>},
				{year: m06, value: <%=buyMonthList.getMonth06()%>},
				{year: m07, value: <%=buyMonthList.getMonth07()%>},
				{year: m08, value: <%=buyMonthList.getMonth08()%>},
				{year: m09, value: <%=buyMonthList.getMonth09()%>},
				{year: m10, value: <%=buyMonthList.getMonth10()%>},
				{year: m11, value: <%=buyMonthList.getMonth11()%>},
				{year: m12, value: <%=buyMonthList.getMonth12()%>},
			],
			xkey: 'year',
			ykeys: ['value'],
			labels: ['Value'],
		});
	</script>

</body>
</html>

<%
		} // end of if
	} catch (Exception e) {
		e.printStackTrace();
	}
%>