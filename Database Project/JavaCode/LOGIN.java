package database;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;

public class LOGIN extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField USER;
	private JTextField PASS;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					LOGIN frame = new LOGIN();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public LOGIN() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("USERNAME");
		lblNewLabel.setBounds(72, 57, 74, 13);
		contentPane.add(lblNewLabel);
		
		JLabel lblNewLabel_1 = new JLabel("PASSWORD");
		lblNewLabel_1.setBounds(72, 80, 74, 13);
		contentPane.add(lblNewLabel_1);
		
		USER = new JTextField();
		USER.setBounds(157, 54, 96, 19);
		contentPane.add(USER);
		USER.setColumns(10);
		
		PASS = new JTextField();
		PASS.setBounds(157, 77, 96, 19);
		contentPane.add(PASS);
		PASS.setColumns(10);
		
		JButton btnNewButton = new JButton("LOGIN");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				String username = USER.getText();
				String password = PASS.getText();

				try {
					Utility ut = new Utility();
					
					String sql = "SELECT User_Name, Password, Credentials FROM Log_In WHERE User_Name=? AND Password=?";
					ut.pstmt = ut.conn.prepareStatement(sql);
					ut.pstmt.setString(1, username);
					ut.pstmt.setString(2, password);
					ut.rs = ut.pstmt.executeQuery();

					if (ut.rs.next()) {
						String role = ut.rs.getString("Credentials");

						JOptionPane.showMessageDialog(null, "Login Successful");
						setVisible(false);

						if (role.equalsIgnoreCase("admin")) {
							MainAdmin.main(null);
						} else {
							MainAothur.main(null);
						}
					} else {
						JOptionPane.showMessageDialog(null, "Login NOT Successful");
					}
				} catch (SQLException e1) {
					e1.printStackTrace();
				}
			}
		});

		btnNewButton.setFont(new Font("Tahoma", Font.BOLD, 12));
		btnNewButton.setBounds(157, 106, 110, 21);
		contentPane.add(btnNewButton);
	}

}
