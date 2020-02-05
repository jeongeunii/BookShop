<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.DeliveryDataBean"%>
<%@ page import="bookshop.shopping.BuyDataBean"%>
<%@ page import="bookshop.shopping.BuyDBBean"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.NumberFormat"%>

<%
	request.setCharacterEncoding("utf-8");
	String managerId = (String) session.getAttribute("managerId");
	String sanction = request.getParameter("sanction");
	String buyId = request.getParameter("buyId");
	String bookTitle = request.getParameter("bookTitle");
	int rtnVal = 0;

	if (managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	}

	BuyDBBean buyProcess = BuyDBBean.getInstance();
	rtnVal = buyProcess.getDeliveryStatus(buyId, bookTitle);
	
	// 배송상태 : 1(상품준비중), 2(배송중), 3(배송완료)
	String[] deliveryName = {"상품준비중", "배송중", "배송완료"};
	String[] deliveryRatio = {"30", "50", "20"};
	String[] deliveryColor = {"success", "warning", "danger"};
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="../../js/jquery-3.4.1.js"></script>
<script src="../../bootstrap/js/bootstrap.min.js"></script>
<style>
	h2, #lb, #fg {
		margin-top: 30px;
	}
</style>
<title>배송 상태 수정</title>
</head>
<body>

	<div class="container">
	    <form class="form-horizontal" role="form" method="post" name="deliveryUpModalPro" action="deliveryUpModalPro.jsp">
	        <div class="form-group" style="text-align: center;">
	            <div class="col-sm-3"></div>
	            <div class="col-sm-6" style="margin-top: 30px;">
	            	<h2 align="center"><b>배송 상태 수정</b></h2>
	            </div>
	        </div>
	        <div class="form-group" style="text-align: center;">
	            <div class="col-sm-12" id="lb">
                	<label class="radio-inline">
                		<input type="radio" id="sanction" name="sanction" value="1" <%if (rtnVal == 1) {%>checked<%}%>>&nbsp;상품준비중&nbsp;&nbsp;
                	</label>
	                <label class="radio-inline">
	                	<input type="radio" id="sanction" name="sanction" value="2" <%if (rtnVal == 2) {%>checked<%}%>>&nbsp;배송중&nbsp;&nbsp;
                	</label>
                	<label class="radio-inline">
                    	<input type="radio" id="sanction" name="sanction" value="3" <%if (rtnVal == 3) {%>checked<%}%>>&nbsp;배송완료
                	</label>
                	<input type="hidden" name="buyId" value="<%=buyId%>">
                	<input type="hidden" name="bookTitle" value="<%=bookTitle%>">
	            </div>
	        </div>
	        <div class="form-group" style="text-align: center;">
	            <div class="progress">
	                <%for (int i = 0; i <= rtnVal - 1; i++) {%>
	                	<div class="progress-bar progress-bar-<%=deliveryColor[i]%> progress-bar-striped"
	                		style="width: <%=deliveryRatio[i]%>%; height: 100px;"><%=deliveryName[i]%></div>
	                <%}%>
	            </div>
	        </div>
	        <div class="form-group" style="text-align: center; margin-top: 40px;" id="fg">
	            <div class="col-sm-offset-3 col-sm-6"">
	                <button type="submit" class="btn btn-primary">수정</button>
	                <button type="reset" class="btn btn-danger">취소</button>
	            </div>
	        </div>
	    </form>
	</div>
	
</body>
</html>