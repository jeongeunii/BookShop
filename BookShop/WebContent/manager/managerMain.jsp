<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String managerId = "";
	try {
		managerId = (String) session.getAttribute("managerId");

		// 세션값이 없으면 로그인화면으로 이동시킨다.
		if (managerId == null || managerId.equals("")) {
			response.sendRedirect("logon/managerLoginForm.jsp?useSSL=false");
		} else {
%>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <script src="../js/jquery-3.4.1.js"></script>
    <script src="../bootstrap/js/bootstrap.min.js"></script>
    <title>managerMain.jsp</title>
    <style>
        body {
            position: relative;
        }
        .affix {
            top: 0;
            width: 100%;
            z-index: 9999 important;
        }
        .navbar {
            margin-bottom: 0px;
        }
        .affix ~, container-fluid {
            position: relative;
            top: 50px;
        }
    </style>
</head>
<body data-spy="scroll" data-target=".navbar" data-offset="50">
    
    <div class="container-fluid" style="background-color: coral; color: #FFF; height: 200px">
        <h1 style="text-align: center;">도 서 쇼 핑 몰 관 리</h1><br><br>
        <h4 style="text-align: center;">상품 등록 및 수정 / 판매리스트 / 배송 현황 / 원별 판매 통계</h4>
        <h4 style="text-align: center;">도서 쇼핑몰 관리자 : 김정은</h4>
    </div>
    
    <nav class="navbar navbar-inverse" data-spy="affix" data-offset-top="197">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a href="#" class="navbar-brand">BookShop</a>
            </div>
            <div class="collapse navbar-collapse" id="myNavbar">
                <ul class="nav navbar-nav">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">상품관리 <span class="caret"></a>
                        <ul class="dropdown-menu">
                            <li><a href="productProcess/bookRegisterForm.jsp">상품등록</a></li>
                            <li><a href="productProcess/bookList.jsp?book_kind=all">상품수정/삭제</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">판매관리 <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="orderedProduct/orderList.jsp">판매리스트</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">배송관리 <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="delivery/deliveryList.jsp">배송리스트</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                    	<a href="#" class="dropdown-toggle" data-toggle="dropdown">통계관리 <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="statistics/monthStatsForm.jsp">월별판매리스트(꺽은선)</a></li>
                            <li><a href="statistics/monthBarStatsForm.jsp">월별판매리스트(막대)</a></li>
                            <li><a href="statistics/bookKindStatsForm.jsp">도서종류별 연간판매비율(도너츠)</a></li>
                        </ul>
                    </li>
                    <li>
                    	<a href="logon/managerLogout.jsp">로그아웃</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
</body>
</html>

<%
		} // end - else
	} catch (Exception e) {
		e.printStackTrace();
	}
%>