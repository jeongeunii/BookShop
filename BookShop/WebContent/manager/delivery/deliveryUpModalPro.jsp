<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.BuyDBBean"%>

<%
	request.setCharacterEncoding("utf-8");
	String managerId = (String) session.getAttribute("managerId");

	if (managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	} else {
		String buy_id = request.getParameter("buyId");
		String bookTitle = request.getParameter("bookTitle");
		
		// 라디오버튼은 같은 이름이 여러개라도 선택된 값만 전송되기 때문에 getParameter로 받는다.
		String sanction = request.getParameter("sanction");
		
		BuyDBBean buyProcess = BuyDBBean.getInstance();
		buyProcess.updateDelivery(buy_id, sanction, bookTitle);
	}
%>

<script>
	alert("배송 상태가 수정되었습니다.");
	history.go(-1);
</script>