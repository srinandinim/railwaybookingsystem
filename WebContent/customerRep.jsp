<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<jsp:include page="header.jsp" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<style>
table {
	width: 90%;
}

table, th, tr, td {
	border: 1px solid black;
	border-right: 1px solid black;
	border-collapse: collapse;
	margin-left: auto;
	margin-right: auto;
}

button {
	width: 88%;
	padding: 2px;
	background-color: #38586b;
	border: 0;
	box-sizing: border-box;
	cursor: pointer;
	font-weight: bold;
	font-size: 16px;
	color: #ffffff;
}

</style>
<title>Customer Representative</title>
</head>

<body>
	<% if (session.getAttribute("isEmployee") !=null && ((boolean) session.getAttribute("isEmployee"))) { %>
	<!-- PUT EVERYTHING ADMINS/EMPLOYEES SHOULD SEE IN THIS IF STATEMENT -->
	<div class="center padding" id="trainScheduleTable">
		<br>
		<h4 style="font-weight: bold">Train Schedule</h4>
		<p></p>
		<table>
			<tr class="tableHeader">
				<th>Transit Line</th>
				<th>Departure Date/Time</th>
				<th>Arrival Date/Time</th>
				<th>Fare</th>
				<th>Origin Station</th>
				<th>Destination Station</th>
				<th>Train ID</th>
			</tr>
			<% try { ApplicationDB db=new ApplicationDB(); Connection con=db.getConnection(); Statement
                                stmt=con.createStatement(); String trainScheduleInfo="SELECT * FROM train_schedule;" ;
                                ResultSet trainScheduleInfoResult=stmt.executeQuery(trainScheduleInfo); while
                                (trainScheduleInfoResult.next()) { %>
			<tr>
				<td><%=trainScheduleInfoResult.getString(1)%></td>
				<td><%=trainScheduleInfoResult.getString(2)%></td>
				<td><%=trainScheduleInfoResult.getString(3)%></td>
				<td>$<%=trainScheduleInfoResult.getString(4)%></td>
				<% Statement stmt1=con.createStatement(); String
                                        getOriginStation="SELECT name FROM station WHERE BINARY station_id=\'" +
                                        trainScheduleInfoResult.getString(5) + "\';" ; ResultSet
                                        originStation=stmt1.executeQuery(getOriginStation); while(originStation.next()){
                                        %>
				<td><%=originStation.getString(1)%> <%-- , Station ID: <%=trainScheduleInfoResult.getString(5) %> --%>
				</td>
				<%}%>
				<% stmt1=con.createStatement(); String
                                                getDestinationStation="SELECT name FROM station WHERE BINARY station_id=\'"
                                                + trainScheduleInfoResult.getString(6) + "\';" ; ResultSet
                                                destinationStation=stmt1.executeQuery(getDestinationStation);
                                                while(destinationStation.next()){ %>
				<td><%=destinationStation.getString(1)%> <%-- , Station ID: <%=trainScheduleInfoResult.getString(6) %>
                                                            --%></td>
				<%}%>
				<td><%=trainScheduleInfoResult.getString(7)%></td>
			</tr>
			<% } db.closeConnection(con); } catch (Exception e) { System.out.print(e); } %>
		</table>
	</div>
	<br>
	<div class="padding" id="addTrainSchedule">
		<h4 class="subheading">Add New Train Schedule</h4>
		<p style="margin: 0; padding: 0">Please make sure that Transit Line and Train ID are unique. </p>
		<p> The departure and arrival date and time should be entered in the format: "YYYY-MM-DD HH:MM:SS" </p>
		<form action="CusRepTrainScheduleController" method="POST">
		  <div class="row justify-content-start" >
		    <div class="col-sm-2">
		    	<input type="text" name="newTransitLine" placeholder="Transit Line" maxlength="50" required>
			  	<p></p>
			  	<select name="originStationID" id="originStationID">
					<option value="" selected disabled>Select An Origin</option>
					<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
		
							Statement stmt = con.createStatement();
		
							String stationNames = "SELECT station_id, name FROM station ORDER BY name;";
							ResultSet result = stmt.executeQuery(stationNames);
		
							while (result.next()) {
								%>
								<option value="<%=result.getString(1)%>"><%=result.getString(2)%></option>
								<%
							}
							db.closeConnection(con);
						} catch (Exception e) {
							System.out.print(e);
						}
					%>
				</select>			  	
				<p></p>
				<input type="text" name="departureDateTime" placeholder="Departure Date & Time"	maxlength="19" required>
				<p><p>
				<input type="text" name="fare" placeholder="Fare" class="editVerifyAdd" required> 
		    </div>
		    <div class="col-sm-2">
		    	<input type="text" name="trainID" placeholder="Train ID" required>
			  	<p></p>
			  	<select name="destinationStationID" id="destinationStationID">
					<option value="" selected disabled>Select An Destination</option>
					<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
		
							Statement stmt = con.createStatement();
		
							String stationNames = "SELECT station_id, name FROM station ORDER BY name;";
							ResultSet result = stmt.executeQuery(stationNames);
		
							while (result.next()) {
								%>
								<option value="<%=result.getString(1)%>"><%=result.getString(2)%></option>
								<%
							}
							db.closeConnection(con);
						} catch (Exception e) {
							System.out.print(e);
						}
					%>
				</select>
				<p></p>
				<input type="text" name="arrivalDateTime" placeholder="Arrival Date & Time" maxlength="19" required>
				<p></p>
				<button type="submit" formmethod="POST">Add</button>
			</div>
		  </div>
		</form>
	</div>

	<br>
	
	<div class="padding" id="editTrainSchedule">
		<h4 class="subheading">Edit Existing Train Schedule</h4>
		<p style="margin: 0; padding: 0">Please make sure that Transit Line and Train ID match. </p>
		<p> The departure and arrival date and time should be entered in the format: "YYYY-MM-DD HH:MM:SS" </p>
		<form action="CusRepTrainScheduleController" method="POST">
		  <div class="row justify-content-start" >
		    <div class="col-sm-2">
		    	<input type="text" name="editTransitLine" placeholder="Transit Line" maxlength="50" required>
			  	<p></p>	  	
			  	<select name="originStationID" id="originStationID">
					<option value="" selected disabled>Select An Origin</option>
					<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
		
							Statement stmt = con.createStatement();
		
							String stationNames = "SELECT station_id, name FROM station ORDER BY name;";
							ResultSet result = stmt.executeQuery(stationNames);
		
							while (result.next()) {
								%>
								<option value="<%=result.getString(1)%>"><%=result.getString(2)%></option>
								<%
							}
							db.closeConnection(con);
						} catch (Exception e) {
							System.out.print(e);
						}
					%>
				</select>
				<p></p>
				<input type="text" name="departureDateTime" placeholder="Departure Date & Time" maxlength="19">
				<p><p>
				<input type="text" name="fare" placeholder="Fare" class="editVerifyAdd"> 
		    </div>
		    
		    <div class="col-sm-2">
		    	<input type="text" name="trainID" placeholder="Train ID" required>
				<p></p>				
				<select name="destinationStationID" id="destinationStationID">
					<option value="" selected disabled>Select An Destination</option>
					<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
		
							Statement stmt = con.createStatement();
		
							String stationNames = "SELECT station_id, name FROM station ORDER BY name;";
							ResultSet result = stmt.executeQuery(stationNames);
		
							while (result.next()) {
								%>
								<option value="<%=result.getString(1)%>"><%=result.getString(2)%></option>
								<%
							}
							db.closeConnection(con);
						} catch (Exception e) {
							System.out.print(e);
						}
					%>
				</select>
				<p></p>
				<input type="text" name="arrivalDateTime" placeholder="Arrival Date & Time" maxlength="19">
				<p></p>
				<button type="submit" formmethod="POST">Edit</button>
			</div>
		  </div>
		</form>
	</div>
	<br>
	
	<div class="padding" id="deleteRep">
		<h4 class="subheading">Delete Existing Train Schedule</h4>
		<p style="margin: 0; padding: 0">Please make sure that Transit Line and Train ID match. </p>
		<p>Warning: Deleting an existing train schedule will also delete all reservations and stops associated with this train schedule</p>
		<form action="CusRepTrainScheduleController" method="POST">
		  <div class="row justify-content-start" >
		    <div class="col-sm-2">
		    	<input type="text" name="deleteTransitLine"
				placeholder="Transit Line" maxlength="50" required>
			  	<p></p>
		    </div>
		    <div class="col-sm-2">
		    	<input
				type="text" name="trainID" placeholder="Train ID" required>
			  	<p></p>
		    </div>
		    <div class="col-sm-2">
		    	<button type="submit" formmethod="POST">Delete</button>
			  	<p></p>
		    </div>
		  </div>
		</form>
	</div>
	
	<br>
	
	<div class="padding" id="listTrainSchedules">
		<h4 class="subheading">Search Train Schedules</h4>
		<p>Filter train schedules by origin, destination, or normal stop.</p>
		<form action="ListTrainSchedulesController" method="POST">
		  <div class="row justify-content-start" >
		    <div class="col-sm-3">
		    	<select id="trainStop"
				name="trainStop">
				<option value="none" selected disabled>Select a Station</option>
				<% try { ApplicationDB db=new ApplicationDB(); Connection con=db.getConnection();
                                    Statement stmt=con.createStatement(); String
                                    originStations="SELECT station_id, name FROM station;" ; ResultSet
                                    result=stmt.executeQuery(originStations); while (result.next()) { %>
				<option value="<%=result.getString(1)%>">
					<%=result.getString(2)%>
				</option>
				<% } result.close();} catch (Exception e) { System.out.print(e); } %>
			</select>
				<p></p>
		    </div>
		    <div class="col-sm-2">
		    	<button type="submit" formmethod="POST">Get Train Schedules</button>
			  	<p></p>
		    </div>
		  </div>
		</form>
	</div>
	
	<div class="center" id="selectedScheduleTableList">
		<% if (request.getAttribute("valid-schedules") !=null) { 
				ArrayList<TrainSchedule> std = (ArrayList<TrainSchedule>) request.getAttribute("valid-schedules");
        %>
		<table>
			<tr class="tableHeader">
				<th>Stop</th>
				<th>Transit Line</th>
				<th>Train ID</th>
				<th>Origin</th>
				<th>Destination</th>
				<th>Departure Datetime</th>
				<th>Arrival Datetime</th>
			</tr>
			<% for (TrainSchedule s : std) { %>
			<tr>
			<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
							
					
							Statement stmt =con.createStatement();
							
							String getSql = "SELECT distinct station.name FROM station, stops WHERE station.station_id = stops.station_id AND stops.station_id = \'"+s.getstopID()+"\';";
							ResultSet result = stmt.executeQuery(getSql);
							
							while(result.next()) {	
								%>
								<td><%=result.getString(1)%></td>
								<%	
							}
						} catch (SQLException e) {
							e.printStackTrace();
						}
				%>
				<td><%=s.getTransitLine()%></td>
				<td><%=s.getTrainID()%></td>
				<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
					
							Statement stmt =con.createStatement();
							
							String getSql = "SELECT name FROM station WHERE station_id = \'"+s.getOriginID()+"\';";
							ResultSet result = stmt.executeQuery(getSql);
							
								while(result.next()) {	
									%>
									<td><%=result.getString(1)%></td>
									<%	
								}
								
						} catch (SQLException e) {
							e.printStackTrace();
						}
				%>
				<%
						try {
							ApplicationDB db = new ApplicationDB();
							Connection con = db.getConnection();
					
							Statement stmt =con.createStatement();
							
							String getSql = "SELECT name FROM station WHERE station_id = \'"+s.getDestinationID()+"\';";
							ResultSet result = stmt.executeQuery(getSql);
							
								while(result.next()) {	
									%>
									<td><%=result.getString(1)%></td>
									<%	
								}
								
						} catch (SQLException e) {
							e.printStackTrace();
						}
				%>
				<td><%=s.getDepartureDatetime().substring(0, s.getDepartureDatetime().length()-3)%></td>
				<td><%=s.getArrivalDatetime().substring(0, s.getArrivalDatetime().length()-3)%></td>
			</tr>
			<%}%>
		</table>
		<% } %>
	</div>
	<br>
	<div class="padding" id="customerSearch">
		<h4 class="subheading">Search Reservations by Date</h4>
		<p>Find all customers that have a reservation on a specified transit line on a specified date.</p>
		<form action="CusRepReservationSearchController" method="POST">
		  <div class="row justify-content-start" >
		    <div class="col-sm-2">
		    	<select id="transitLine" name="transitLine" required>
				<option value="" selected disabled>Select a Transit Line</option>
				<% try { ApplicationDB db=new ApplicationDB(); Connection con=db.getConnection();
                                    Statement stmt=con.createStatement(); String
                                    originStations="SELECT DISTINCT transit_line FROM train_schedule;" ; ResultSet
                                    result=stmt.executeQuery(originStations); while (result.next()) { %>
				<option value="<%=result.getString(1)%>">
					<%=result.getString(1)%>
				</option>
				<% } db.closeConnection(con); } catch (Exception e) { System.out.print(e); } %>
			</select>
				<p></p>
		    </div>
		    <div class="col-sm-2">
		    	<input type="date" name="reservationDate" placeholder="Date [YYYY-MM-DD]" required>
			  	<p></p>
		    </div>
		    <div class="col-sm-2">
		    	<button type="submit" formmethod="POST">Get Customers</button>
			  	<p></p>
		    </div>
		  </div>
		</form>
	</div>
	
	<div class="padding" id="customerList">
		<% 
		if (request.getAttribute("valid-customers") != null){ 
			ArrayList<String> std = (ArrayList <String>) request.getAttribute("valid-customers");
			if (std.size() > 0) {
		%>
			<p style="margin: 0; padding: 0">Customers: </p>
			<ul>
				<% for (String s : std) { %>
					<li><%=s%></li>
				<%}%>
			</ul>
			
		<% } else {%>
			<p> There are no customers reserved for that transit-line and day. </p>
		<%
		}
		}
		%>
	</div>
	
	<% } else { %>
	<h1>You are not an employee or admin.</h1>
	<% } %>
</body>

</html>
