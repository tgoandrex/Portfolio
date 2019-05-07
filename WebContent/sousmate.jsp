			<jsp:include page="header.jsp" />
			
			<header>
				<h1>Sousmate</h1>
			</header>
			<section> <!-- Begin Main Content -->
				<h3>Table of Contents</h3>
				<ol>
					<li><a href="#log-in">Logging In</a></li>
					<li><a href="#create-recipe">Creating a Recipe</a></li>
					<li><a href="#using-timer">Using a Recipe Timer</a></li>
					<li><a href="#change-preferences">Changing Profile Preferences</a></li>
				</ol>
				<p>Note: Sousmate is a work in progress. Some examples shown may be changed or improved later.</p>
				<h3 id="log-in">Logging in</h3>
				<p>There are no databases set up like in eZoo, so the log in credentials are stored in session Web Storage. This is an example username 
				and password:</p>
				<pre>
sessionStorage.setItem("myKey", "!Password1234");
				</pre>
				<p>This is the function that checks if the password is at least 8 characters long, and contains at least one special character, one 
				number, and one letter. Regex is used to store the checked values:</p>
				<pre>
function checkPassword(password) {
	if (password.length &lt; 8) {
	  return false;
	}
	
	let isNumbers = 0;
	const numbers = /^\d+$/;
	let isLetters = 0;
	const letters = /^[A-Za-z]+$/;
	let isSpecialCharacters = 0;
	const specialCharacters = /[ !@#$%^&amp;*()_+\-=\[\]{};':"\\|,.&lt;&gt;\/?]/;
	
	for (let x = 0; x &lt;= password.length; x++) {
		if (password.charAt(x).match(numbers)) {
			isNumbers++;
		} else if (password.charAt(x).match(letters)) {
			isLetters++;
		} else if (password.charAt(x).match(specialCharacters)) {
			isSpecialCharacters++;
		}
	}
	
	if (isLetters &gt; 0 &amp;&amp; isNumbers &gt; 0 &amp;&amp; isSpecialCharacters &gt; 0) {
		return true;
	} else {
		return false;
	}
}
				</pre>
				<p>When the user puts in "myKey" as the username and "!Password1234" as the password in this form the login() function executes and the 
				user is redirected to profile.html:</p>
				<img src="${request.contextPath}resources\imgs\sousmate-page\log-in.PNG" class="img-fluid">
				<pre>
&lt;div id="login-form"&gt;
	&lt;h3>User Login&lt;/h3&gt;
	&lt;p>Enter your username and password&lt;/p&gt;
	&lt;label for="Username"&gt;Username: &lt;/label&gt;&lt;input type="text" name="Username" id="U" required&gt;&lt;br&gt;
	&lt;label for="Password"&gt;Password: &lt;/label&gt;&lt;input type="password" name="Password" id="P" required&lgt;&lt;br&gt;
	&lt;input class="button" onclick="logIn()" type="submit" value="Login">
&lt;/div>

function logIn() {
	const usernameInput = document.getElementById("U").value;
	const passwordInput = document.getElementById("P").value;
	if (passwordInput !== sessionStorage.getItem("myKey") || !checkPassword(passwordInput)) {
		return false;
	} else if (usernameInput !== sessionStorage.key(0)) {
		return false;
	} else {
		localStorage.setItem("sousmate-username", usernameInput);
		window.location.href = "profile.html";
		return true;
	}
}
				</pre>
				<p>If anything other than what is stored in the session Web Storage was entered in either username or password, the log in would fail 
				and the user would not be redirected to profile.html</p>
				<h3 id="create-recipe">Creating a Recipe</h3>
				<p>Recipes are created as JSON objects in recipes.json. Creating another recipe is as simple as making another recipe# object, 
				copying the fields, and filling them out. Here is the first recipe of three created:</p>
				<pre>
{
	"recipe1": {
		"id": 1,
		"name": "Barbeque Chicken",
		"category": "Poultry",
		"synopsis": "Chicken slow cooked on the grill and poured with barbeque sauce",
		"instructions": [
			"Remove unthawed chicken from package, season if desired",
			"Place chicken on grill and cook for 40 minutes, cook for longer if blood is present inside",
			"Pour barbeque sauce on grilled chicken and cool for 5 minutes",
			"Eat and enjoy"
		],
		"prepTime": 10,
		"cookTime": 40,
		"yield": "6 thighs or 12 drumsticks",
		"level": 3,
		"ingredients": [
			"Chicken (thighs or drumsticks)",
			"Barbeque sauce",
			"Seasoning of your choice (Optional)"
		],
		"author": "tgoandrex",
		"imagePath": "../Assets/Images/BBQChicken.jpg"
	}
}
				</pre>
				<p>An XHR object is created in order to get the recipe objects using jQuery:</p>
				<pre>
$(document).ready(function() {
	let xhr;
	xhr = new XMLHttpRequest();

	xhr.onreadystatechange = function() {
		if (xhr.readyState == 4 &amp;&amp; xhr.status == 200) {
			data = JSON.parse(xhr.responseText);
			myRecipes.push(data.recipe1, data.recipe2, data.recipe3);
			renderRecipes();
		}
	};

	xhr.open("GET", "http://localhost:5000/javascript/JSON/recipes.json");
	xhr.send();
});
				</pre>
				<p>The three received objects is then dynamically created on recipes.html using DOM traversal. Here is the final result:</p>
				<img src="${request.contextPath}resources\imgs\sousmate-page\Sousmate-image.png" class="img-fluid">
				<h3 id="using-timer">Using a Recipe Timer</h3>
				<p>When the recipes in recipes.json are dynamically created, there are timers that are also created with them. The time it counts down 
				from depends on what is declared in the "cookTime" variable. For instance, the "Barbeque Chicken" recipe has a "cookTime" variable of 
				40 minutes. So that is what the timer for that particular recipe will be set to:</p>
				<pre>
"cookTime": 40

minutes = `&dollar;{arrayItem.cookTime}`;
seconds = 0;
				</pre>
				<img src="${request.contextPath}resources\imgs\sousmate-page\countdown-timer.PNG" class="img-fluid">
				<p>One thing that is interesting about the countdown timers is that it is actually set up with Web Workers. Web Workers allow Javascript 
				programs to run on background threads away from the main thread. What it first does is create a Web Worker object that points to a 
				separate Javascript file called timer.js, which listens for the amount of minutes to countdown from. It then runs a function called 
				timer(), which subtracts the initially retrieved minutes by 1 second until it hits 0 minutes and 0 seconds. The minutes and seconds 
				is then sent back to the main thread, updating every 1000 milliseconds with setInterval():</p>
				<pre>
//From the main Javascript thread
function startWorker() {
	if(typeof(w) == "undefined") {
		w = new Worker('../Javascript/timer.js');
	}
	w.onmessage = function(x,y) {
		document.getElementById("HTMLMinute").innerHTML = x.data.minutes + " minutes";
		document.getElementById("HTMLSecond").innerHTML = x.data.seconds + " seconds";
}

//From timer.js (The Web Worker)
let seconds = 0;
let minutes;
let counter;

function timer() {
	if (minutes &gt; 0 || seconds &gt; 0 ) {
		seconds--;
	}
    if (seconds &lt; 0) {
		seconds = 59;
		minutes = minutes - 1;
	}
	postMessage({minutes:minutes,seconds:seconds});
}

onmessage = function(e) {
	if(!isNaN(e.data)) {
		minutes = e.data;
		counter = setInterval(function(){timer();}, 1000);
	} else if (e.data === "paused") {
		counter = clearInterval(counter);
	} else if (e.data === "resumed") {
		counter = setInterval(function(){timer();}, 1000);
	} else {
		console.log("Invalid data");
	}
}
				</pre>
				<p>You can also see that there are other defined Strings that the Web Worker listens for: "paused" and "resumed". These tell the 
				setInterval to clear and start again, essentially acting as pause and resume buttons. Pressing the stop button when the timer is 
				running will actually stop the timer by destroying the Web Worker:</p>
				<pre>
function stopWorker() {
	w.terminate();
	w = undefined;
}
				</pre>
				<p>There is only one flaw with this set-up. When starting another timer when one is already running will result in the first timer 
				counting down twice as fast, because we did not destroy the first Web Worker and setInterval() is going twice per 1000 milliseconds. 
				This is why it is always important to fully stop a timer before starting another one.</p>
				<h3 id="change-preferences">Changing Profile Preferences</h3>
				<p>There are two things that can be changed by a user: background color and profile picture. The background color is changed at 
				profile.html and changes the background color of the body throughout the application with this color type input field:</p>
				<img src="${request.contextPath}resources\imgs\sousmate-page\profile-page1.PNG" class="img-fluid">
				<p>You can see the color of the body is current set to a light blue. The current background color is saved in local Web Storage and 
				displayed on every page with the help of jQuery:</p>
				<pre>
//Function that displays the background color throughout the application
$(document).ready(function() {
	if (localStorage.getItem("sousmate-colorPreference")) {
		$("#body").css("background-color", localStorage.getItem("sousmate-colorPreference"));
	}
});

//In Local Storage
sousmate-colorPreference: #0080ff

//The Input field that changes the background color
$("#color").on("change", function(e) {
	setTimeout(function() {
		$("#body").css("background-color", localStorage.getItem("sousmate-colorPreference"));
		let colorVal = $("#color").val();
		localStorage.setItem("sousmate-colorPreference", colorVal);
		alert("Color preference auto saved!");
	}, 3000);
});
				</pre>
				<p>Let's change the background color to black. It is as simple as clicking the color box in "Background Color Preference" in profile.html. 
				This window will pop up:</p>
				<img src="${request.contextPath}resources\imgs\sousmate-page\color-change.PNG" class="img-fluid">
				<p>After pressing "OK" after choosing black an alert will show up saying your preference has been saved and when you refresh the page 
				the background color in the body has changed to black:</p>
				<img src="${request.contextPath}resources\imgs\sousmate-page\profile-page2.PNG" class="img-fluid"><img>
				<pre>
//In Local Storage
sousmate-colorPreference: #000000
				</pre>
				<p>The similar process is done with changing the profile picture:</p>
				<pre>
//In Local Storage
sousmate-profileImage: data:image/jpeg;base64,/9j/4AAQ...

//Function to change the profile picture
$("#img_input").on("change", function(e) {
	const file = e.target.files[0];
	const reader = new FileReader();
		
	reader.onloadend = function(event) {
		setTimeout(function() {
			localStorage.setItem("sousmate-profileImage", event.target.result);
			alert("Profile picture auto saved!");
		}, 3000);
	}
	reader.readAsDataURL(file);
});

//To display the profile picture
$("#profile_image").attr("src", localStorage.getItem("sousmate-profileImage"));
				</pre>
			</section> <!-- End Main Content -->
			
			<jsp:include page="footer.jsp" />