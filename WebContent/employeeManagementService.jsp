			<jsp:include page="header.jsp" />
			
			<header>
				<h1>Employee Management Service</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<h3>Table of Contents</h3>
				<ol>
					<li><a href="#promote-employee">Promoting to an Employee (Part 2)</a></li>
					<li><a href="#fire-employee">Firing an Employee</a></li>
					<li><a href="#create-insurance">Creating an Insurance Plan</a></li>
					<li><a href="#assign-insurance">Assigning an Insurance Plan</a></li>
				</ol>
				<p>Note: This is an application only for receiving data from outside applications into it's own database. Expect some of these 
				examples to have some code from my other application, <a href="/Portfolio/eZoo">eZoo</a>.</p>
				<h3 id="promote-employee">Promoting to an Employee (Part 2)</h3>
				<p>This is a continuation of promoting an Employee in eZoo. See the first part <a href="/Portfolio/eZoo#promote-employee">here</a>.</p>
				<p>So we successfully promoted the User "employee" back in eZoo, but what happened when the form data reached the Employee Management 
				Service? Here we have a method that listens for any POST requests to localhost:8080//EmployeeManagementService/service/employee:</p>
				<pre>
@POST
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public void createEmployee(MultivaluedMap&lt;String, String&gt; formInputs) throws Exception {
	String stringId = formInputs.getFirst("employeeId");
	long longId = Long.parseLong(stringId);
		
	String username = formInputs.getFirst("username");
		
	String stringSalary = formInputs.getFirst("salary");
	long longSalary = Long.parseLong(stringSalary);
	BigDecimal BDSalary = BigDecimal.valueOf(longSalary);
		
	Employee employee = new Employee(longId, username, BDSalary);
		
	dao.createEmployee(employee);
}
				</pre>
				<p>So the form data from eZoo is processed with this method and stored in the EMS database. We can see this change here in pgAdmin 4 
				with "employee" added to the database:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\employee-dbase1.PNG" class="img-fluid">
				<p>Now when a Manager in eZoo wants to view any Employees the employees database from EMS is sent back with this GET request listener
				and method:</p>
				<pre>
@GET
@Produces(MediaType.APPLICATION_JSON)
public Response getAllEmployees() {
	List&lt;Employee&gt; employeeList = dao.getAllEmployees();
	ResponseBuilder respBuilder = null;
		
	if (employeeList.isEmpty())
		respBuilder = Response.status(Response.Status.NOT_FOUND);
	else
		respBuilder = Response.status(Response.Status.OK);
		
	respBuilder.entity(employeeList);
	return respBuilder.build();
}

public List&lt;Employee&gt; getAllEmployees() {
	List&lt;Employee&gt; employees = new ArrayList&lt;&gt;();
	String hql = "from Employee";
		
	TypedQuery&lt;Employee&gt; query = session.createQuery(hql, Employee.class);
		
	employees = query.getResultList();
		
	session.close();
		
	return employees;
}
				</pre>
				<h3 id="promote-employee">Firing an Employee</h3>
				<p>Sometimes an Employee doesn't work out, so there needs to be an option to fire an Employee as well. Looking back at eZoo, in 
				employeeList.jsp we have this form:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\demote-employee.PNG" class="img-fluid">
				<p>Employee "andrex1234" just isn't cutting it so lets fire him. Pressing "update" will initialize the following code from 
				DeleteEmployeeServlet.java. Let's just focus on what information is being sent to the Employee Management Service instead of what is 
				being changed in eZoo's local database:</p>
				<pre>
Client client = ClientBuilder.newClient();
WebTarget target = client.target("http://localhost:8080//EmployeeManagementService/service/employee/" + id);
MultivaluedMap&lt;String, String&gt; formData = new MultivaluedHashMap&lt;String, String&gt;();
formData.add("stringId", stringId);
Response output = target.request().method("DELETE", Entity.form(formData));
				</pre>
				<p>Now back at EMS, this method that listens to DELETE requests and this method executes:</p>
				<pre>
@DELETE
@Path("{id}")
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public void deleteEmployee(@PathParam("id") String urlID) throws Exception {
	long longId = Long.parseLong(urlID);
	Employee employee = dao.getEmployeeByEmployeeId(longId);
		
	dao.deleteEmployee(employee);
}

public void deleteEmployee(Employee employee) throws Exception {
	session.beginTransaction();
		
	session.delete(employee);
		
	session.getTransaction().commit();
		
	session.close();
}
				</pre>
				<p>Now the employees database in EMS has updated to only have "employee" there, and "andrex1234" gone:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\employee-dbase2.PNG" class="img-fluid">
				<p>This change is reflected when a Manager observes the employeeList.jsp table in eZoo:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\view-employee.PNG" class="img-fluid">
				<h3 id="create-insurance">Creating an Insurance Plan</h3>
				<p>Creating an Insurance Plan is simple, even from another application. Here in Employee Management Service's database we have the 
				insurance_plans database:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\insurance-dbase1.PNG" class="img-fluid">
				<p>Let's go ahead and create another Insurance Plan through eZoo. Here is the form for creating one in healthPlanList.jsp:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\create-insurance.PNG" class="img-fluid">
				<p>By pressing "create" the following code is executed in CreateHealthPlanServlet.java to be sent to the EMS:</p>
				<pre>
final String coverage = request.getParameter("coverage");
		
try {
			
	Client client = ClientBuilder.newClient();
	WebTarget target = client.target("http://localhost:8080//EmployeeManagementService/service/healthinsurance");
	MultivaluedMap&lt;String, String&gt; formData = new MultivaluedHashMap&lt;String, String&gt;();
	formData.add("coverage", coverage);
	Response output = target.request().header("Content-Type", "application/x-www-form-urlencoded").post(Entity.form(formData));
}
				</pre>
				<p>Now at the EMS the form data is retrieved by a method listening for POST requests at localhost:8080//EmployeeManagementService/service/healthinsurance 
				and creates an Insurance Plan with it:</p>
				<pre>
@POST
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public void createInsurance(MultivaluedMap&lt;String, String&gt; formInputs) throws Exception {
	String stringCoverage = formInputs.getFirst("coverage");
	long longCoverage = Long.parseLong(stringCoverage);
	BigDecimal BDCoverage = BigDecimal.valueOf(longCoverage);
		
	InsurancePlan insurance = new InsurancePlan(BDCoverage);
		
	dao.createInsurance(insurance);
}

public void createInsurance(InsurancePlan insurance) throws Exception {
	session.beginTransaction();
		
	session.save(insurance);
		
	session.getTransaction().commit();
		
	session.close();
}
				</pre>
				<p>Now by observing the insurance_plans database in the EMS and the healthPlanList.jsp table in eZoo we can see the new Insurance 
				Plan:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\insurance-dbase2.PNG" class="img-fluid">
				<img src="${request.contextPath}resources\imgs\ems-page\view-insurance1.PNG" class="img-fluid">
				<p>The table can retrieve this information from the EMS because it calls a GET request to localhost:8080//EmployeeManagementService/service/healthinsurance 
				from it's servlet. This is the method in the EMS that responds to the GET request:</p>
				<pre>
@GET
@Produces(MediaType.APPLICATION_JSON)
public Response getAllPlans() {
	List&lt;InsurancePlan&gt; insuranceList = dao.getAllInsurancePlans();
	ResponseBuilder respBuilder = null;

	respBuilder.entity(insuranceList);
	return respBuilder.build();
}
				</pre>
				<h3 id="assign-insurance">Assigning an Insurance Plan</h3>
				<p>Employees can also be assigned to Insurance Plans. In healthPlanList.jsp we have this form:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\assign-insurance.PNG" class="img-fluid">
				<p>Insurance Plans and Employees have a "One to Many" relationship, meaning multiple Employees can share a single Insurance Plan. By 
				pressing "assign" the code in AssignHealthPlanServlet.java executes:</p>
				<pre>
final String insuranceId = request.getParameter("id");
final String username = request.getParameter("name");
		
UserDAO dao = new UserDAOImpl();
User employee = dao.getUserByUsername(username);
String employeeId = String.valueOf(employee.getUserId());
try {			
	Client client = ClientBuilder.newClient();
	WebTarget target = client.target("http://localhost:8080//EmployeeManagementService/service/healthinsurance");
	MultivaluedMap&lt;String, String&gt; formData = new MultivaluedHashMap&lt;String, String&gt;();
	formData.add("insuranceId", insuranceId);
	formData.add("employeeId", employeeId);
	Response output = target.request().method("DELETE", Entity.form(formData));
}
				</pre>
				<p>In the Employee Management Service, this method that listens to DELETE requests executes as well as the method assignHealthInsurance():</p>
				<pre>
@DELETE
@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
public void assignInsurance(MultivaluedMap&lt;String, String&gt; formInputs) throws Exception {
	String stringInsuranceId = formInputs.getFirst("insuranceId");
	long longInsuranceId = Long.parseLong(stringInsuranceId);
	InsurancePlan insurance = dao.getInsuranceByInsuranceId(longInsuranceId);
		
	String stringEmployeeId = formInputs.getFirst("employeeId");
	long longEmployeeId = Long.parseLong(stringEmployeeId);
	EmployeeDAO eDAO = new EmployeeDAOImpl();
	Employee employee = eDAO.getEmployeeByEmployeeId(longEmployeeId);
		
	dao.assignHealthInsurance(insurance, employee);
}

public void assignHealthInsurance(InsurancePlan insurancePlan, Employee employee) throws Exception {
		
	Session session = HibernateTest.getHibernateSession();
		
	insurancePlan = session.load(InsurancePlan.class, insurancePlan.getInsuranceId());
	employee = session.load(Employee.class, employee.getEmployeeId());
		
	employee.setInsurancePlan(insurancePlan);
		
	session.beginTransaction();
		
	session.update(employee);
		
	session.getTransaction().commit();
		
	session.close();
}
				</pre>
				<p>Now we can see in the employees database in the EMS the Insurance Plan assigned to "employee":</p>
				<img src="${request.contextPath}resources\imgs\ems-page\employee-dbase3.PNG" class="img-fluid">
				<p>Back at eZoo, we see the changes are also reflected here on the employeeList.jsp table:</p>
				<img src="${request.contextPath}resources\imgs\ems-page\view-employee2.PNG" class="img-fluid">
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />