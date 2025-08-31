package database;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;

public class DeleteAuthor extends JFrame {
	private static final long serialVersionUID = 1L;
	private JTextField txtEmail;

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			try {
				DeleteAuthor frame = new DeleteAuthor();
				frame.setVisible(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}

	public DeleteAuthor() {
		setTitle("Delete Author");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 350, 200);
		getContentPane().setLayout(null);

		JLabel lblEmail = new JLabel("Email ID to delete:");
		lblEmail.setBounds(30, 40, 120, 25);
		getContentPane().add(lblEmail);

		txtEmail = new JTextField();
		txtEmail.setBounds(160, 40, 140, 25);
		getContentPane().add(txtEmail);

		JButton btnDelete = new JButton("Delete");
		btnDelete.setBounds(110, 90, 100, 30);
		btnDelete.addActionListener(e -> deleteAuthor());
		getContentPane().add(btnDelete);
	}

	private void deleteAuthor() {
		try  {
			 Utility ut = new Utility();
			 String sql2 = "DELETE FROM Paper_Author WHERE Email_ID=?";
             ut.pstmt = ut.conn.prepareStatement(sql2);
             ut.pstmt.setString(1, txtEmail.getText());
             int Result2 = ut.pstmt.executeUpdate(); 
             
             
             
             String sql = "DELETE FROM Author WHERE Email_ID=?";
             ut.pstmt = ut.conn.prepareStatement(sql);
             ut.pstmt.setString(1, txtEmail.getText());
             int Result = ut.pstmt.executeUpdate();
             
             
             
             
			JOptionPane.showMessageDialog(this, Result > 0 && Result2>0? "Author deleted." : "Author not found.");
		} catch (SQLException ex) {
			JOptionPane.showMessageDialog(this, "Error: " + ex.getMessage());
		}
	}
}
