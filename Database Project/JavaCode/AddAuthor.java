package database;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;

public class AddAuthor extends JFrame {
	private static final long serialVersionUID = 1L;
	private JTextField txtEmail, txtFirstName, txtLastName, txtOrg, txtCountry;

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			try {
				AddAuthor frame = new AddAuthor();
				frame.setVisible(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}

	public AddAuthor() {
		setTitle("Add Author");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 400, 350);
		getContentPane().setLayout(null);

		JLabel lblTitle = new JLabel("Add Author");
		lblTitle.setFont(new Font("Tahoma", Font.BOLD, 16));
		lblTitle.setBounds(140, 10, 120, 30);
		getContentPane().add(lblTitle);

		JLabel[] labels = {
			new JLabel("Email ID:"), new JLabel("First Name:"), new JLabel("Last Name:"),
			new JLabel("Organization:"), new JLabel("Country:")
		};

		JTextField[] fields = {
			txtEmail = new JTextField(), txtFirstName = new JTextField(),
			txtLastName = new JTextField(), txtOrg = new JTextField(),
			txtCountry = new JTextField()
		};

		for (int i = 0; i < labels.length; i++) {
			labels[i].setBounds(30, 50 + i * 40, 100, 25);
			fields[i].setBounds(140, 50 + i * 40, 200, 25);
			getContentPane().add(labels[i]);
			getContentPane().add(fields[i]);
		}

		JButton btnSubmit = new JButton("Add Author");
		btnSubmit.setBounds(140, 260, 120, 30);
		btnSubmit.addActionListener(e -> addAuthor());
		getContentPane().add(btnSubmit);
	}

	private void addAuthor() {
		try  {
			Utility ut = new Utility();
			 String sql = "INSERT INTO Author VALUES (?, ?, ?, ?, ?)";
            ut.pstmt = ut.conn.prepareStatement(sql);
            ut.pstmt.setString(1, txtEmail.getText());
            ut.pstmt.setString(2, txtFirstName.getText());
            ut.pstmt.setString(3, txtLastName.getText());
            ut.pstmt.setString(4, txtOrg.getText());
            ut.pstmt.setString(5, txtCountry.getText());
            int Result = ut.pstmt.executeUpdate(); 
            JOptionPane.showMessageDialog(this, "Author added successfully.");
		} catch (SQLException ex) {
			JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
		}
	}
}
