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
#mybarchart {
	margin-top: 50px;
}
</style>
<title>월별 판매 현황</title>
</head>
<body>

	<div class="container" id="cc">
	    <h2 align="center" style="margin-bottom: 40px;"><b><%=year%>년도 월별 판매 현황</b></h2>
	    <form action="monthBarStatsForm.jsp" class="form-horizontal" role="form" method="post" name="monthBarStatsForm">
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
	    
	<div id="mybarchart" style="height: 400px; text-align: center;"></div>
	
	</div>
	
	
	<script>
		new Morris.Bar({
			element: 'mybarchart',
			data: [
				{x: '1월', y:<%=buyMonthList.getMonth01()%>},
				{x: '2월', y:<%=buyMonthList.getMonth02()%>},
				{x: '3월', y:<%=buyMonthList.getMonth03()%>},
				{x: '4월', y:<%=buyMonthList.getMonth04()%>},
				{x: '5월', y:<%=buyMonthList.getMonth05()%>},
				{x: '6월', y:<%=buyMonthList.getMonth06()%>},
				{x: '7월', y:<%=buyMonthList.getMonth07()%>},
				{x: '8월', y:<%=buyMonthList.getMonth08()%>},
				{x: '9월', y:<%=buyMonthList.getMonth09()%>},
				{x: '10월', y:<%=buyMonthList.getMonth10()%>},
				{x: '11월', y:<%=buyMonthList.getMonth11()%>},
				{x: '12월', y:<%=buyMonthList.getMonth12()%>},
			],
			xkey: 'x',
			ykeys: ['y'],
			labels: ['Qty'],
			barColors: function (row, series, type) {
				if (type === 'bar') {
					var red = Math.ceil(255 * row.y / this.ymax);
					return 'rgb(' + red + ', 0, 0)';
				} else {
					return '#000';
				}
			}
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