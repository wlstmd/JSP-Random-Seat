<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
// JSON 파싱
StringBuilder sb = new StringBuilder();
BufferedReader reader = request.getReader();
String line;
while ((line = reader.readLine()) != null) {
    sb.append(line);
}
String jsonStr = sb.toString();

// 간단한 JSON 파싱 (대괄호 제거 후 쉼표로 분리)
String[] nameArray = jsonStr.substring(1, jsonStr.length() - 1).split(",");
List<String> names = new ArrayList<>();
for (String name : nameArray) {
    names.add(name.trim().replace("\"", ""));
}

// 데이터베이스 연결 정보
String url = "jdbc:mysql://localhost:3306/students";
String user = "root";
String password = "jin009787~";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
} catch (ClassNotFoundException e) {
    out.print("{\"success\": false, \"error\": \"JDBC 드라이버를 찾을 수 없습니다: " + e.getMessage() + "\"}");
    return;
}

try (Connection conn = DriverManager.getConnection(url, user, password)) {
    // 기존 데이터 삭제
    try (Statement stmt = conn.createStatement()) {
        stmt.executeUpdate("TRUNCATE TABLE students;");
    }

    // 새 데이터 삽입
    String sql = "INSERT INTO students (name) VALUES (?)";
    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
        for (String name : names) {
            pstmt.setString(1, name);
            pstmt.executeUpdate();
        }
    }

    // 성공 응답
    out.print("{\"success\": true}");
} catch (SQLException e) {
    // 실패 응답
    out.print("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
    e.printStackTrace(); // 서버 로그에 스택 트레이스 출력
}
%>