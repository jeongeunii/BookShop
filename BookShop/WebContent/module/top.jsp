<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	try {
		if (session.getAttribute("id") == null) {
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="../js/jquery-3.4.1.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
<style>
</style>
<title>top.jsp</title>
</head>
<body>

	<nav class="navbar navbar-inverse navbar-fixed-top">
		<div class="container-fluid">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="../shopping/shopMain.jsp">도서 쇼핑몰</a>
			</div>
			<div>
				<div class="collapse navbar-collapse" id="myNavbar">
					<form class="navbar-form navbar-right" action="../shopping/loginPro.jsp">
						<div class="form-group">
							<input type="text" class="form-control" name="id" size="12" maxlength="12" placeholder="아이디">
							<input type="password" class="form-control" name="passwd" size="12" maxlength="12" placeholder="비밀번호">
						</div>
						<button type="submit" class="btn btn-primary">
							<span class="glyphicon glyphicon-log-in"></span> 로그인
						</button>
						<a href="../shopping/logon/memberInsertForm.jsp" class="btn btn-danger" aria-pressed="true">
							<span class="glyphicon glyphicon-user"></span> 회원가입
						</a>
					</form>
				</div>
			</div>
		</div>
	</nav>

</body>
</html>

<%
		} else {
%>

<nav class="navbar navbar-inverse navbar-fixed-top" style="padding-right: 15px;">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a href="../shopping/shopMain.jsp" class="navbar-brand">도서 쇼핑몰</a>
        </div>
        <div class="form-group navbar-right" style="margin-bottom: 0;">
            <p class="navbar-text"><b><%=session.getAttribute("id")%>님, 즐거운 쇼핑시간 되십시오.</b></p>
            <a href="../shopping/shopMain.jsp" class="btn btn-success" aria-pressed="true" style="margin-top: 8px;">
                <span class="glyphicon glyphicon-eye-open"></span> 쇼핑 계속하기
            </a>
            
            <a href="../shopping/cartList.jsp?book_kind=all" class="btn btn-primary" aria-pressed="true" style="margin-top: 8px;">
                <span class="glyphicon glyphicon-shopping-cart"></span> 장바구니
            </a>
            
            <a href="../shopping/buyList.jsp" class="btn btn-warning" aria-pressed="true" style="margin-top: 8px;">
                <span class="glyphicon glyphicon-list-alt"></span> 구매 목록
            </a>
            
            <a href="../shopping/logon/memberUpDelForm.jsp" class="btn btn-info" aria-pressed="true" style="margin-top: 8px;">
                <span class="glyphicon glyphicon-user"></span> 회원 정보 수정/탈퇴
            </a>
            
            <a href="../shopping/logout.jsp" class="btn btn-danger" aria-pressed="true" style="margin-top: 8px;">
                <span class="glyphicon glyphicon-log-out"></span> 로그아웃
            </a>
        </div>
    </div>
</nav>

<%
		}
	} catch (NullPointerException e) {
		e.printStackTrace();
	} catch (Exception e) {
		e.printStackTrace();
	}
%>