			<jsp:include page="header.jsp" />
			
			<header>
				<h1>Contact</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<form id="ajax-contact" method="post"> <!-- Begin Contact Form -->
					<div class="form-group">
						<label for="name">Name (Optional):</label>
						<input type="text" class="form-control" id="name" name="name">
					</div>
					<div class="form-group">
						<label for="email">Email:</label>
						<input type="email" class="form-control" id="email" name="email" placeholder="email@example.com" required>
					</div>
					<div class="field form-group">
						<label for="message">Message:</label>
						<textarea class="form-control" id="message" name="message" rows="6" required></textarea>
					</div>
					<div class="field form-group">
						<button type="submit" class="btn btn-dark">Send</button>
					</div>
				</form> <!-- End Contact Form -->
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />