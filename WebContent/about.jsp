			<jsp:include page="header.jsp" />
			
			<header>
				<h1>About</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<h3>Hello</h3>
				<p>My name is Andrew Stapleton, an aspiring web developer. After a tough decision to change my focus from history studies to programming I 
				have come a long ways from knowing nothing to having four projects done, learning two programming languages, learning many programming 
				concepts and technologies, and enjoying the challenge of how to build web applications on my own! Please, take the time to look over my 
				<a href="/Portfolio/skills">skills</a> and <a href="/Portfolio/portfolio">portfolio</a>. Also feel free to 
				<a href="/Portfolio/contact">contact</a> me about any questions or employment opportunities. I'm currently looking for any entry level 
				java developer opportunities in the San Antonio and Austin area. Thanks for visiting me!</p>
				<h3>Portfolio Preview</h3>
				<div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel"> <!-- Begin Carousel -->
					<ol class="carousel-indicators">
						<li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
						<li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
						<li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
						<li data-target="#carouselExampleIndicators" data-slide-to="3"></li>
					</ol>
					<div class="carousel-inner">
						<div class="carousel-item active">
							<img class="d-block w-100" src="${request.contextPath}resources\imgs\eZoo-image.png" alt="First slide">
						</div>
						<div class="carousel-item">
							<img class="d-block w-100" src="${request.contextPath}resources\imgs\OnlineShopping-image.png" alt="Second slide">
						</div>
						<div class="carousel-item">
							<img class="d-block w-100" src="${request.contextPath}resources\imgs\Sousmate-image.png" alt="Fourth slide">
						</div>
					</div>
					<a class="carousel-control-prev" href="#carouselExampleIndicators" role="button" data-slide="prev">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="sr-only">Previous</span>
					</a>
					<a class="carousel-control-next" href="#carouselExampleIndicators" role="button" data-slide="next">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="sr-only">Next</span>
					</a>
				</div> <!-- End Carousel -->
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />
