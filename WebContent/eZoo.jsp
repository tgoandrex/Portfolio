			<jsp:include page="header.jsp" />
			
			<header>
				<h1>eZoo</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<h3>Table of Contents</h3>
				<ol>
					<li><a href="#log-in">Logging In</a></li>
					<li><a href="#create-schedule">Creating a Feeding Schedule</a></li>
					<li><a href="#assign-schedule">Assigning a Feeding Schedule to an Animal</a></li>
					<li><a href="#attend-event">Attending an Event</a></li>
					<li><a href="#promote-employee">Promoting to an Employee</a></li>
				</ol>
				<h3 id="log-in">Logging in</h3>
				<p>Besides the index page, eZoo is completely closed off to anyone without a log in and a defined role (User, Employee, or Manager). 
				To log in, click on any of the header links besides "Register" (In this example I will assume the user already registered). You will 
				be redirected to login.jsp:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\log-in.PNG" class="img-fluid">
				<p>This is the form in login.jsp. Some unnecessary code has been deprecated for clarity:</p>
				<pre>
&lt;form action="j_security_check" method="post"&gt;
	&lt;input type="text" name="j_username"/&gt;
	&lt;input type="password" name="j_password"/&gt;
	&lt;input type="submit"/&gt;
&lt;/form&gt;
				</pre>
				<p>"j_security_check", "j_username", and "j_password" are all required for the log in process to work correctly. Over at standalone.xml 
				in the Wildfly directory is this created security domain for checking if the username and password actually exists on the users and 
				user_roles database, as well as their role:</p>
				<pre>
&lt;security-domain name="FBADomain"&gt;
	&lt;authentication&gt;
		&lt;login-module code="Database" flag="required"&gt;
			&lt;module-option name="dsJndiName" value="java:/PostgresDS"/&gt;
			&lt;module-option name="principalsQuery" value="SELECT password FROM users WHERE username=?"/&gt;
			&lt;module-option name="rolesQuery" value="SELECT role, 'Roles' FROM user_roles WHERE username=?"/&gt;
		&lt;/login-module&gt;
	&lt;/authentication&gt;
&lt;/security-domain&gt;
				</pre>
				<p>jboss-web.xml is also needed to connect eZoo to the security domain FBADomain:</p>
				<pre>
&lt;jboss-web&gt;
	&lt;security-domain>FBADomain&lt;/security-domain&gt;
&lt;/jboss-web&gt;
				</pre>
				<p>If the user inputs the correct username and password, and has one of the three defined roles, the log in is successful and the user 
				may go to any page his role gives him access to.</p>
				<h3 id="create-schedule">Creating a Feeding Schedule</h3>
				<p>Creating a Feeding Schedule is very simple. Any user with the Employee or Manager role can do so. This is the feeding_schedules 
				database in pgAdmin 4, a program that displays and edits all the databases:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\schedule-dbase1.PNG" class="img-fluid">
				<p>Only one schedule created so far. The table at viewFeedingSchedules.jsp displays everything the feeding_schedules table contains:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\view-schedule1.PNG" class="img-fluid">
				<p>At createFeedingSchedules.jsp we have this form for creating a new Feeding Schedule:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\create-schedule.PNG" class="img-fluid">
				<p>Lets assume we filled out this in the form: Schedule = 7:00am. Recurrence = Twice. Diet = Vegetation. Notes = Needs medical shot 
				after first daily feeding. After pressing "Add" the form information is sent to the servlet CreateFeedingScheduleServlet.java. Some 
				code is deprecated for clarity:</p>
				<pre>
String feedingTime = request.getParameter("schedule");
String recurrence = request.getParameter("recurrence");
String food = request.getParameter("diet");
String notes = request.getParameter("notes");

FeedingSchedule schedule = new FeedingSchedule(feedingTime, recurrence, food, notes);

FeedingScheduleDAO dao = new FeedingScheduleDAOImpl();

try {
	dao.addFeedingSchedule(schedule);
}
				</pre>
				<p>The servlet calls the method addFeedingSchedule() to add the new Feeding Schedule to the database:</p>
				<pre>
public void addFeedingSchedule(FeedingSchedule schedule) throws Exception {
	
	Session session = HibernateTest.getHibernateSession();
	
	session.beginTransaction();
	
	session.save(schedule);
	
	session.getTransaction().commit();
	
	session.close();
}
				</pre>
				<p>Looking back at pgAdmin 4, we see this schedule has now been added to the database as well as the table in viewFeedingSchedules.jsp:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\schedule-dbase2.PNG" class="img-fluid">
				<img src="${request.contextPath}resources\imgs\eZoo-page\view-schedule2.PNG" class="img-fluid">
				<p>Animals and Events are also created this way. Deleting and updating is also done in nearly the same way, just with different DAO 
				methods, servlets, and forms.</p>
				<h3 id="assign-schedule">Assigning a Feeding Schedule to an Animal</h3>
				<p>Animals can be assigned to Feeding Schedules. The animals and feeding_schedules tables are set 
				up to have a "Many to One" relationship, meaning many Animals can share a single Feeding Schedule. This is shown in Animal.java:</p>
				<pre>
@ManyToOne(cascade = CascadeType.ALL)
	@JoinColumn(name="schedule_id")
	private FeedingSchedule feedingSchedule;
				</pre>
				<p>Going to assignFeedingSchedules.jsp, we can see both a table displaying the one Animal in our database and a form to assign said
				Animal to any available Feeding Schedules if we so desire:<p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\assign-schedule1.PNG" class="img-fluid">
				<p>Pressing "Assign" will bind the Animal named Nigel to the Feeding Schedule of the ID number of 2. The servlet AssignFeedingScheduleServlet.java 
				and the method assignFeedingSchedule() handles this process. Some code has been deprecated for clarity:</p>
				<pre>
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	final long scheduleId = Long.parseLong(request.getParameter("scheduleid"));
	FeedingScheduleDAO fDAO = new FeedingScheduleDAOImpl();
		
	FeedingSchedule schedule = fDAO.getScheduleById(scheduleId);
		
	final long animalId = Long.parseLong(request.getParameter("animalid"));
	AnimalDAO aDAO = new AnimalDaoImpl();
		
	try {
		Animal animal = aDAO.getAnimalById(animalId);
		fDAO.assignFeedingSchedule(animal, schedule);
	}
}

public void assignFeedingSchedule(Animal animal, FeedingSchedule schedule) throws Exception {
		
	Session session = HibernateTest.getHibernateSession();
		
	animal = session.load(Animal.class, animal.getAnimalId());
	schedule = session.load(FeedingSchedule.class, schedule.getScheduleId());
		
	animal.setFeedingSchedule(schedule);
		
	session.beginTransaction();
		
	session.update(animal);
		
	session.getTransaction().commit();
		
	session.close();
}
				</pre>
				<p> We can confirm this Feeding Schedule has been assigned by checking both on the animals database (note the column schedule_id has 
				a "2" in it) and on assignFeedingSchedules.jsp:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\schedule-dbase3.PNG" class="img-fluid">
				<img src="${request.contextPath}resources\imgs\eZoo-page\assign-schedule2.PNG" class="img-fluid">
				<h3 id="attend-event">Attending an Event</h3>
				<p>All Users, Employees, and Managers can attend any available Events. Events are created, updated, and deleted by any Employees and 
				Managers. Here in pgAdmin 4 we have the events database:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\event-dbase1.PNG" class="img-fluid">
				<p>There is a second database that is equally important: users_events. This is a sort of connecting table for the database users 
				and the database events because it allows multiple Users attend multiple Events, or what is called a Many to Many relationship:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\userevent-dbase1.PNG" class="img-fluid">
				<p>This code in User.java describes the Many to Many relationship:</p>
				<pre>
@ManyToMany(cascade = { CascadeType.ALL }, fetch=FetchType.EAGER)
    @JoinTable(
        name = "users_events", 
        joinColumns = { @JoinColumn(name = "user_id") }, 
        inverseJoinColumns = { @JoinColumn(name = "event_id") }
    )
    private Set&lt;Event&gt; events;
				</pre>
				<p>This is the table that displays all Events in viewEventDetails.jsp. Note that the Animal Nigel is a part of the event, another 
				function available to Employees and Managers:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\view-event.PNG" class="img-fluid">
				<p>This is the form to attend any created Events in attendEvents.jsp:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\attend-event.PNG" class="img-fluid">
				<p>Clicking "Attend" will cause the servlet AttendEventServlet.java and the method attendEvent() to execute. Some code has been 
				deprecated for clarity:</p>
				<pre>
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	final String username = request.getUserPrincipal().getName();
		
	final long eventId = Long.parseLong(request.getParameter("id"));
		
	UserDAO uDAO = new UserDAOImpl();
	User user = uDAO.getUserByUsername(username);
		
	EventDAO eDAO = new EventDAOImpl();
	Event event = eDAO.getEventById(eventId);
		
	try {
		uDAO.attendEvent(user, event);
	}
}

public void attendEvent(User user, Event event) throws Exception {
	    
	session.beginTransaction();
		
	user.getEvents().add(event);
	event.getUsers().add(user);
	    
	session.save(user);
	session.save(event);
	    
	session.getTransaction().commit();
	    
	session.close();
}
				</pre>
				<p>Now another table in viewAttendedEvents.jsp will display Christmas Event again, but this table is only associated with what the 
				specific logged in User is attending. So if we have three created Events, only Christmas Event will show up here because that is the 
				only Event the logged in User is attending. Here is the database users_events after attending Christmas Event:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\userevent-dbase2.PNG" class="img-fluid">
				<p>The two numbers are associated with the ID of the User and the ID of the Event, respectively. If the same User unattended the
				event, this database would be empty, and the table at viewAttendingEvents.jsp would be empty, despite not actually deleting the 
				Event.</p>
				<h3 id="promote-employee">Promoting to an Employee</h3>
				<p>Users can be promoted to Employees which grants them more access to eZoo such as creating, updating, and deleting Animals, Events, 
				and Feeding Schedules as well as assigning and unassigning Animals to Events, or Animals to Feeding Schedules. Here at our user_roles 
				database in pgAdmin 4, we have three usernames with three different roles:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\userroles-dbase1.PNG" class="img-fluid">
				<p>Here in userList.jsp is a table that lists only usernames with the User role as well as a form that promotes any Users into 
				Employees:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\view-user.PNG" class="img-fluid">
				<p>The username "employee" is only a User right now, which doesn't make a lot of sense so let's promote him by pressing "Promote user" 
				on the form and giving him a salary. Here is PromoteUserServlet.java and promoteToEmployee() that handles this process. Some code has 
				been deprecated for clarity:</p>
				<pre>
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	final String username = request.getParameter("name");
	final String salary = request.getParameter("salary");
		
	UserDAO dao = new UserDAOImpl();
		
	User user = dao.getUserByUsername(username);
	long id = user.getUserId();
	final String employeeId = String.valueOf(id);
	try {
		dao.promoteToEmployee(user);
	}
}

public void promoteToEmployee(User user) throws Exception {
		
	UserRoles userRole = user.getRole();
		
	session.beginTransaction();
		
	userRole.setRole("Employee");
		
	session.save(userRole);
		
	session.getTransaction().commit();
		
	session.close();
}
				</pre>
				<p>Now when we go back to our user_roles database and to employeeList.jsp we see the changes were successful:</p>
				<img src="${request.contextPath}resources\imgs\eZoo-page\userroles-dbase2.PNG" class="img-fluid">
				<img src="${request.contextPath}resources\imgs\eZoo-page\view-employee.PNG" class="img-fluid">
				<p>There are however a few things odd going on here. Where is the salary and insurance data coming from? Nowhere in eZoo's database 
				has this information. The road to this answer lies within this code also present in PromoteUserServlet.java:</p>
				<pre>
Client client = ClientBuilder.newClient();
WebTarget target = client.target("http://localhost:8080//EmployeeManagementService/service/employee");
MultivaluedMap&lt;String, String&gt; formData = new MultivaluedHashMap&lt;String, String&gt;();
formData.add("employeeId", employeeId);
formData.add("username", username);
formData.add("salary", salary);
Response output = target.request().header("Content-Type", "application/x-www-form-urlencoded").post(Entity.form(formData));
				</pre>
				<p>This code actually sends the form data we filled out from userList.jsp to an entirely separate application called the 
				<a href="/Portfolio/employeeManagementService#promote-employee">Employee Management Service</a>, which processes the sent data and stores it in it's 
				own separate database, all while sending information back to eZoo which is why we can see the salary and insurance data on this table. 
				Please head over to the EMS page to see how this process happens.</p>
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />