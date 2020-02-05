<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="../css/main.css" rel="stylesheet" type="text/css">
<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
<script src="../js/jquery-3.4.1.js"></script>
<script src="../bootstrap/js/bootstrap.min.js"></script>
<style>
	html, body {
		margin-bottom: 20px;
	}
</style>
<title>도서 쇼핑몰</title>
</head>
<body>

	<jsp:include page="../module/top.jsp" flush="false"/>

	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-3 col-md-2 sidebar">
				<ul class="nav nav-sidebar">
					<jsp:include page="../module/left.jsp" flush="false" />
				</ul>
			</div>
			<div class="col-sm-9 col-sm-offset-3 col-md-9 col-md-offset-2 main" style="padding-left: 100px;">
				<jsp:include page="list.jsp" flush="false" />
			</div>
		</div>
	</div>

</body>
</html>