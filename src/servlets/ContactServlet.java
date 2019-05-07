package servlets;

import java.io.IOException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("contact.jsp").forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String  d_email = request.getParameter("email"), // placeholder
				d_password = "password", // placeholder
	            d_host = "smtp.gmail.com",
	            d_port  = "465",
	            m_to = "tgoandrex@gmail.com",
	            m_subject = "New Message From " + request.getParameter("name") + " via Portfolio Contact!",
	            m_text = request.getParameter("message");

		
		Properties props = new Properties();
		props.put("mail.smtp.user", d_email);
        props.put("mail.smtp.host", d_host);
        props.put("mail.smtp.socketFactory.port", d_port);
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.fallback", "false");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.debug", "true");
        props.put("mail.smtp.port", d_port);
        props.put("mail.smtp.starttls.enable","true");
		
		Session emailSession = Session.getInstance(props, new javax.mail.Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(d_email, d_password);
			}
		});
		
		try {
			MimeMessage message = new MimeMessage(emailSession);
			message.setText(m_text);
			message.setSubject(m_subject);
			message.setFrom(new InternetAddress(d_email));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(m_to));
			
			Transport.send(message);
			} catch (MessagingException e) {
				e.printStackTrace();
			}
	}
}
