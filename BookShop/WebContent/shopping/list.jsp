<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="bookshop.master.ShopBookDataBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="bookshop.master.ShopBookDBBean"%>
<%@ page import="bookshop.master.ShopBookDataBean"%>

<%
	String realFolder = "";
	realFolder = "http://localhost:8889/BookShop/imageFile";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="../js/jquery-3.4.1.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
<style>
html, body {
	margin-bottom: 20px;
}
</style>
<title></title>
</head>
<body>

	<br>
	<br>
	<br>
	<h2 align="center">신간 목록 더보기</h2>

	<%
		ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
		List<ShopBookDataBean> bookLists = null;
		String book_kindName = request.getParameter("book_kind");
		bookLists = bookProcess.getBooks(book_kindName);

		ShopBookDataBean books[] = new ShopBookDataBean[bookLists.size()];
		bookLists.toArray(books);

		
		if (book_kindName.equals("100")) {
			book_kindName = "문학";
		} else if (book_kindName.equals("200")) {
			book_kindName = "외국어";
		} else if (book_kindName.equals("300")) {
			book_kindName = "컴퓨터";
		} else {
			book_kindName = "전체";
		}
	%>

	<br>
	<table class="table table-bordered table-striped nanum table-hover"
		style="margin-bottom: 0">
		<tr class="info" height="30">
			<td width="550"><font size="+1"> <b><%=book_kindName%> 분류의 신간 목록</b>
			</font></td>
		</tr>
	</table>

	<%
		for (int i = 0; i < books.length; i++) {
	%>

	<table class="table table-bordered table-striped nanum table-hover">
		<tr height="30">
			<td rowspan="4" width="100" height="180px"><a
				href="bookContent.jsp?book_id=<%=books[i].getBook_id()%>&book_kind=<%=books[i].getBook_kind()%>">
					<img src="<%=realFolder%>/<%=books[i].getBook_image()%>"
					alt="이미지 없음" border="0" width="100%" height="125%">
			</a></td>
			<td width="350"><font size="+1"> <b> <a
						href="bookContent.jsp?book_id=<%=books[i].getBook_id()%>&book_kind=<%=books[i].getBook_kind()%>">
							<%=books[i].getBook_title()%>
					</a>
				</b>
			</font></td>
			<td rowspan="4" width="100">
				<%
					if (books[i].getBook_count() <= 0) {
				%>

				<h4 align="center">
					<b><font color="red">일시 품절</font></b>
				</h4> <%
 					} else {
 				%>

				<h4 align="center">
					<b><font color="blue">구매 가능</font></b>
				</h4> <%
 					}
 				%>

			</td>
		</tr>
		<tr>
			<td>저 자 : <%=books[i].getAuthor()%></td>
		</tr>
		<tr>
			<td>출판사 : <%=books[i].getPublishing_com()%></td>
		</tr>
		<tr>
			<td>정 가 : <%=books[i].getBook_price()%>원 <br>판매가 : <b><font
					color="red"> <%=NumberFormat.getInstance().format(
						(int) (books[i].getBook_price()) * ((double) (100 - books[i].getDiscount_rate()) / 100))%>
				</font></b>원
			</td>
		</tr>
	</table>

	<%
		}
	%>

</body>
</html>