package bookshop.shopping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class BuyDBBean {

	private static BuyDBBean instance = new BuyDBBean();

	public static BuyDBBean getInstance() {
		return instance;
	}

	// constructor
	private BuyDBBean() {
	}

	// 커넥션 풀로부터 커넥션 객체를 얻어내는 메소드
	private Connection getConnection() throws Exception {
		Context initCtx = new InitialContext();
		Context envCtx = (Context) initCtx.lookup("java:comp/env");
		DataSource ds = (DataSource) envCtx.lookup("jdbc/bookshopdb");

		return ds.getConnection();
	}
	
	// bank테이블에 있는 계좌 정보 전체를 구하는 메소드
	public List<String> getAccount() throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		List<String> accountList = null;
		
		try {
			conn = getConnection();
			sql = "select * from bank";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			accountList = new ArrayList<String>();
			while (rs.next()) {
				String account = new String(rs.getString("account") + " " + rs.getString("bank") + " " + rs.getString("name"));
				accountList.add(account);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return accountList;
	} // getAccount() method
	
	// 구매확정을 하면 발생하는 트랜잭션
	public void insertBuy(List<CartDataBean> lists, String buyer, String account, String deliveryName,
			String deliveryTel, String deliveryAddress) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		Timestamp reg_date = null;
		String maxDate = "";
		String number = "";
		String todayDate = "";
		String compareDate = "";
		long buyId = 0;
		short nowCount = 0;
		
		try {
			conn = getConnection();
			
			// 구매테이블에 넣을 buy_id를 만든다.
			reg_date = new Timestamp(System.currentTimeMillis());
			todayDate = reg_date.toString();
			compareDate = todayDate.substring(0, 4) + todayDate.substring(5, 7) + todayDate.substring(8, 10);

			sql = "select max(buy_id) from buy";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			// pstmt를 여러번 사용할 경우 한번 사용 후 clear해주는 것이 좋음
			// (단, rs 결과를 가져와야 하는 경우 제외)
			// pstmt.clearParameters();
			
			rs.next();
			if (rs.getLong(1) > 0) {
				Long val = new Long(rs.getLong(1));
				maxDate = val.toString().substring(0, 8);
				number = val.toString().substring(8);
				
				//오늘 날짜와 데이터 중 가장 큰 날짜를 비교한다.
				if (compareDate.equals(maxDate)) {
					if (Integer.parseInt(number) + 1 < 10000) {
						buyId = Long.parseLong(maxDate + (Integer.parseInt(number) + 1 + 10000));
					} else {
						buyId = Long.parseLong(maxDate + (Integer.parseInt(number) + 1));
					}
				} else {
					// 오늘 날짜와 구매테이블에 있는 제일 큰 날짜 + 일련번호와 비교해서 데이터가 없으면
					// 오늘 날짜(yyyyMMdd) 뒤에 00001을 붙여서 buyId를 만든다.
					compareDate += "00001";
					buyId = Long.parseLong(compareDate);
				}
			} else {
				// 구매테이블에 처음으로 데이터가 기록되는 경우 오늘 날짜(yyyyMMdd) 뒤에 00001을 붙여서 buyId를 만든다.
				compareDate += "00001";
				buyId = Long.parseLong(compareDate);
			}
			
			// Transaction 시작
			// MySQL은 기본적으로 AutoCommit이 자동설정되므로 비활성화 시킨다.
			conn.setAutoCommit(false);
			
			// 해당 아이디에 대한 cart테이블의 레코드들을 가져온 후 buy테이블에 추가
			for (int i = 0; i < lists.size(); i++) {
				CartDataBean cart = lists.get(i);
				sql = "insert into buy (buy_id, buyer, book_id, book_title, buy_price, buy_count, book_image,"
						+ "buy_date, account, deliveryName, deliveryTel, deliveryAddress) values(?,?,?,?,?,?,?,?,?,?,?,?)";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setLong(1, buyId);
				pstmt.setString(2, buyer);
				pstmt.setInt(3, cart.getBook_id());
				pstmt.setString(4, cart.getBook_title());
				pstmt.setInt(5, cart.getBuy_price());
				pstmt.setByte(6, cart.getBuy_count());
				pstmt.setString(7, cart.getBook_image());
				pstmt.setTimestamp(8, reg_date);
				pstmt.setString(9, account);
				pstmt.setString(10, deliveryName);
				pstmt.setString(11, deliveryTel);
				pstmt.setString(12, deliveryAddress);
				pstmt.executeUpdate();
				
				pstmt.clearParameters();
				pstmt.close();
				
				// 카트에 있는 상품이 구매되었으므로 book테이블에 있는 책과 일치하는 자료의 수량을 재조정 해야한다.
				sql = "select book_count from book where book_id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, cart.getBook_id());
				rs = pstmt.executeQuery();
				rs.next();
				
				nowCount = (short) (rs.getShort(1) - cart.getBuy_count());
				sql = "update book set book_count=? where book_id=?";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setShort(1, nowCount);
				pstmt.setInt(2, cart.getBook_id());
				pstmt.executeUpdate();
				pstmt.clearParameters();
			} // end of for
			
			// 카트에 있는 물품들에 대한 계산이 모두 끝나면 카트를 비운다.
			sql = "delete from cart where buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			pstmt.executeUpdate();
			pstmt.clearParameters();
			
			// 모든 테이블에 대한 작업이 끝났으므로 commit()을 실행한다.
			conn.commit();
			conn.setAutoCommit(true);
			// Transaction 종료
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
	} // insertBuy() method
	
	// buy_id에 해당하는 레코드의 건수를 구하는 메소드
	public int getListCount(String buyer) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int rtnCount = 0;
		
		try {
			conn = getConnection();
			sql = "select count(*) from buy where buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				rtnCount = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return rtnCount;
	} // getListCount() method
	
	public List<BuyDataBean> getBuyList(String buyer) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		List<BuyDataBean> lists = null;
		BuyDataBean buy = null;
		
		try {
			conn = getConnection();
			sql = "select * from buy where buyer=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, buyer);
			rs = pstmt.executeQuery();
			
			lists = new ArrayList<BuyDataBean>();
			
			while (rs.next()) {
				buy = new BuyDataBean();
				buy.setBuy_id(rs.getLong("buy_id"));
				buy.setBook_id(rs.getInt("book_id"));
				buy.setBook_title(rs.getString("book_title"));
				buy.setBuy_price(rs.getInt("buy_price"));
				buy.setBuy_count(rs.getByte("buy_count"));
				buy.setBook_image(rs.getString("book_image"));
				buy.setSanction(rs.getString("sanction"));
				
				lists.add(buy);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return lists;
	} // getBuyList(String) method
	
	// buy 테이블의 전체 레코드 개수를 구하는 메소드
	public int getListCount() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = "";
		int rtnCount = 0;
		
		try {
			conn = getConnection();
			sql = "select count(*) from buy";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			if (rs.next()) {
				rtnCount = rs.getInt(1);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
		return rtnCount;
	} // getListCount() method
	
	// buy 테이블에서 전체 판매 목록을 구하는 메소드
	public List<BuyDataBean> getBuyList() throws Exception {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;
		String sql = "";
		BuyDataBean buy = null;
		List<BuyDataBean> lists = null;
		
		try {
			conn = getConnection();
			sql = "select * from buy";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			lists = new ArrayList<BuyDataBean>();
			
			while (rs.next()) {
				buy = new BuyDataBean();
				buy.setBuy_id(rs.getLong("buy_id"));
				buy.setBuyer(rs.getString("buyer"));
				buy.setBook_title(rs.getString("book_title"));
				buy.setBuy_price(rs.getInt("buy_price"));
				buy.setBuy_count(rs.getByte("buy_count"));
				buy.setBuy_date(rs.getTimestamp("buy_date"));
				buy.setAccount(rs.getString("account"));
				buy.setDeliveryName(rs.getString("deliveryName"));
				buy.setDeliveryTel(rs.getString("deliveryTel"));
				buy.setDeliveryAddress(rs.getString("deliveryAddress"));
				buy.setSanction(rs.getString("sanction"));
				
				lists.add(buy);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (stmt != null)
				stmt.close();
			if (conn != null)
				conn.close();
		}
		return lists;
	} // getBuyList() method
	
	// 구매번호로 조회해서 배송상태를 가져온다.
	public int getDeliveryStatus(String buyId, String bookTitle) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		String status = "";
		int rtnVal = 0;
		
		try {
			conn = getConnection();
			sql = "select sanction from buy where buy_id=? and book_title=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setLong(1, Long.parseLong(buyId));
			pstmt.setString(2, bookTitle);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				// 배송상태 : 1(상품준비중), 2(배송중), 3(배송완료)
				status = rs.getString(1);
				if (status.contentEquals("상품준비중")) {
					rtnVal = 1;
				} else if (status.contentEquals("배송중")) {
					rtnVal = 2;
				} else if (status.contentEquals("배송완료")) {
					rtnVal = 3;
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return rtnVal;
	} // getDeliveryStatus() method
	
	public void updateDelivery(String buyId, String status, String bookTitle) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "";
		String sanction = "";
		
		if (Integer.parseInt(status) == 1) {
			sanction = "상품준비중";
		} else if (Integer.parseInt(status) == 2) {
			sanction = "배송중";
		} else if (Integer.parseInt(status) == 3) {
			sanction = "배송완료";
		}
		
		try {
			conn = getConnection();
			sql = "update buy set sanction=? where buy_id=? and book_title=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, sanction);
			pstmt.setLong(2, Long.parseLong(buyId));
			pstmt.setString(3, bookTitle);
			
			pstmt.executeUpdate();
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
	} // updateDelivery() method
	
	// 도서 종류별 연간 판매 비율
	public BuyBookKindDataBean buyBookKindYear(String year) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BuyBookKindDataBean buyKind = null;
		String sql = "";
		
		try {
			conn = getConnection();
			sql = "select ";
			sql += "ifnull(sum(case bk.book_kind when '100' then bu.buy_count end), 0) as 'qty100', ";
			sql += "ifnull(sum(case bk.book_kind when '200' then bu.buy_count end), 0) as 'qty200', ";
			sql += "ifnull(sum(case bk.book_kind when '300' then bu.buy_count end), 0) as 'qty300', ";
			sql += "ifnull(sum(bu.buy_count), 0) as 'total' ";
			sql += "from book bk, buy bu where bk.book_id = bu.book_id and date_format(bu.buy_date, '%Y') = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				buyKind = new BuyBookKindDataBean();
				
				buyKind.setBookQty100(rs.getInt(1));
				buyKind.setBookQty200(rs.getInt(2));
				buyKind.setBookQty300(rs.getInt(3));
				buyKind.setTotal(rs.getInt(4));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return buyKind;
	} // buyBookKindYear() method
	
	// 월별 판매 현황
	public BuyMonthDataBean buyMonth(String year) throws Exception {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		BuyMonthDataBean buyMonth = null;
		String sql = "";
		
		try {
			conn = getConnection();
			// date_format(buy.buy_date, '%m') : 월만 추출
			sql = "select ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '01' then buy_count end), 0) as '1월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '02' then buy_count end), 0) as '2월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '03' then buy_count end), 0) as '3월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '04' then buy_count end), 0) as '4월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '05' then buy_count end), 0) as '5월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '06' then buy_count end), 0) as '6월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '07' then buy_count end), 0) as '7월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '08' then buy_count end), 0) as '8월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '09' then buy_count end), 0) as '9월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '10' then buy_count end), 0) as '10월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '11' then buy_count end), 0) as '11월', ";
			sql += "ifnull(sum(case date_format(buy_date, '%m') when '12' then buy_count end), 0) as '12월', ";
			sql += "ifnull(sum(buy_count), 0) as 'total' ";
			sql += "from buy where date_format(buy_date, '%Y') = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, year);
			rs = pstmt.executeQuery();
			
			if (rs.next()) {
				buyMonth = new BuyMonthDataBean();
				
				buyMonth.setMonth01(rs.getInt(1));
				buyMonth.setMonth02(rs.getInt(2));
				buyMonth.setMonth03(rs.getInt(3));
				buyMonth.setMonth04(rs.getInt(4));
				buyMonth.setMonth05(rs.getInt(5));
				buyMonth.setMonth06(rs.getInt(6));
				buyMonth.setMonth07(rs.getInt(7));
				buyMonth.setMonth08(rs.getInt(8));
				buyMonth.setMonth09(rs.getInt(9));
				buyMonth.setMonth10(rs.getInt(10));
				buyMonth.setMonth11(rs.getInt(11));
				buyMonth.setMonth12(rs.getInt(12));
				buyMonth.setTotal(rs.getInt(13));
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
		return buyMonth;
	} // buyMonth() method

}
