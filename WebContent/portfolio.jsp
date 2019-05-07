			<jsp:include page="header.jsp" />
			
			<header>
				<h1>Portfolio</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<div class="accordion" id="accordionExample"> <!-- Begin Accordion -->
					<div class="card">
						<div class="card-header" id="headingOne">
							<h5 class="mb-0">
								<button class="btn btn-link text-dark" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
									eZoo
								</button>
							</h5>
						</div>
						<div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										Electronic zoo application for zoo employees to create, view, update and delete animals and zoo events.
									</li>
									<li class="list-group-item">
										Built with Java, Javascript, Bootstrap, Hibernate, Servlets, JSPs, PostgreSQL, Wildfly, Jersey/REST.
									</li>
									<li class="list-group-item">
										Three defined user roles: User, Employee, and Manager.
									</li>
									<li class="list-group-item">
										All users can attend or unattend events. Employees can assign or unassign animals to events.
									</li>
									<li class="list-group-item">
										Employee section allows employees to view their own employee information and insurance plans.
									</li>
									<li class="list-group-item">
										Managers have access to all user information, as well as hiring, demoting, and assigning/unassigning insurance plans to employees.
									</li>
									<li class="list-group-item">
										Employee section communicates with the Employee Management Service database through Jersey/REST (HTTP).
									</li>
									<li class="list-group-item">
										View details <a href="/Portfolio/eZoo">here</a>.
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-header" id="headingTwo">
							<h5 class="mb-0">
								<button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
									Online Shopping
								</button>
							</h5>
						</div>
						<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										Online shopping application similar concept to Amazon or other store websites.
									</li>
									<li class="list-group-item">
										Built with Java, Hibernate, Bootstrap, Servlets, JSPs, PostgreSQL, Wildfly.
									</li>
									<li class="list-group-item">
										Two defined user roles: User and Admin.
									</li>
									<li class="list-group-item">
										Admins can create, view, update, and delete products and categories. Products can be assigned or unassigned to a created category.
									</li>
									<li class="list-group-item">
										All users can create, view, and delete personal orders and add or remove products to them. Admins can view or delete all created orders.
									</li>
									<li class="list-group-item">
										All users can provide user information (phone number, address, email). Admins can view all user information, and remove users.
									</li>
									<li class="list-group-item">
										A full working demo can be found <a href=OnlineShoppingPlaceholder>here</a>.  Full code can be viewed <a href="http://github.com/tgoandrex/OnlineShopping">here</a>.
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-header" id="headingThree">
							<h5 class="mb-0">
								<button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
									Employee Management Service
								</button>
							</h5>
						</div>
						<div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										A Jersey/REST application that saves and updates employee and insurance information in its own database through HTTP.
									</li>
									<li class="list-group-item">
										Built with Java, Hibernate, PostgreSQL, Wildfly, Jersey/REST.
									</li>
									<li class="list-group-item">
										I currently have this working with eZoo.
									</li>
									<li class="list-group-item">
										View details <a href="/Portfolio/employeeManagementService">here</a>. Full code can be viewed <a href="http://github.com/tgoandrex/EmployeeManagementService">here</a>.
									</li>
								</ul>
							</div>
						</div>
					</div>
					<div class="card">
						<div class="card-header" id="headingFour">
							<h5 class="mb-0">
								<button class="btn btn-link text-dark collapsed" type="button" data-toggle="collapse" data-target="#collapseFour" aria-expanded="false" aria-controls="collapseFour">
									Sousmate
								</button>
							</h5>
						</div>
						<div id="collapseFour" class="collapse" aria-labelledby="headingFour" data-parent="#accordionExample">
							<div class="card-body">
								<ul class="list-group list-group-flush">
									<li class="list-group-item">
										An application that displays user created recipes, with built in countdown timers.
									</li>
									<li class="list-group-item">
										Built with Javascript, Web Storage, jQuery, JSON, Node.js, and AJAX.
									</li>
									<li class="list-group-item">
										Recipe and user information are stored in JSON files and retrieved via AJAX.
									</li>
									<li class="list-group-item">
										Timers use Web Workers separate from the main Javascript thread.
									</li>
									<li class="list-group-item">
										Login info and user preferences are retrieved and saved via Web Storage.
									</li>
									<li class="list-group-item">
										Current work in progress.
									</li>
									<li class="list-group-item">
										View details <a href="/Portfolio/sousmate">here</a>.
									</li>
								</ul>
							</div>
						</div>
					</div>
				</div> <!-- End Accordion -->
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />