package database;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;

public class UpdateAuthor extends JFrame {
	private static final long serialVersionUID = 1L;
	private JTextField txtEmail, txtFirstName, txtLastName, txtOrg, txtCountry;

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			try {
				UpdateAuthor frame = new UpdateAuthor();
				frame.setVisible(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}

	public UpdateAuthor() {
		setTitle("Update Author");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 400, 350);
		getContentPane().setLayout(null);

		JLabel lblTitle = new JLabel("Update Author");
		lblTitle.setFont(new Font("Tahoma", Font.BOLD, 16));
		lblTitle.setBounds(130, 10, 150, 30);
		getContentPane().add(lblTitle);

		JLabel[] labels = {
			new JLabel("Email ID (key):"), new JLabel("New First Name:"), new JLabel("New Last Name:"),
			new JLabel("New Organization:"), new JLabel("New Country:")
		};

		JTextField[] fields = {
			txtEmail = new JTextField(), txtFirstName = new JTextField(),
			txtLastName = new JTextField(), txtOrg = new JTextField(),
			txtCountry = new JTextField()
		};

		for (int i = 0; i < labels.length; i++) {
			labels[i].setBounds(30, 50 + i * 40, 130, 25);
			fields[i].setBounds(170, 50 + i * 40, 180, 25);
			getContentPane().add(labels[i]);
			getContentPane().add(fields[i]);
		}

		JButton btnUpdate = new JButton("Update");
		btnUpdate.setBounds(140, 260, 120, 30);
		btnUpdate.addActionListener(e -> updateAuthor());
		getContentPane().add(btnUpdate);
	}

	private void updateAuthor() {
		try {
			Utility ut = new Utility();
			 String sql = "UPDATE Author SET First_name=?, Last_name=?, Organization=?, Country=? WHERE Email_ID=?";
           ut.pstmt = ut.conn.prepareStatement(sql);
           ut.pstmt.setString(1, txtFirstName.getText());
           ut.pstmt.setString(2, txtLastName.getText());
           ut.pstmt.setString(3, txtOrg.getText());
           ut.pstmt.setString(4, txtCountry.getText());
           ut.pstmt.setString(5, txtEmail.getText());
           int Result = ut.pstmt.executeUpdate(); 
           
			JOptionPane.showMessageDialog(this, Result > 0 ? "Author updated." : "Author not found.");
		} catch (SQLException ex) {
			JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
		}
	}
}
