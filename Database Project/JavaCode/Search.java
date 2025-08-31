package database;

import java.awt.EventQueue;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.sql.SQLException;

public class Search extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField FirstNameField;
	private JTextField LastNameField;
	private JButton Back;
	private JTable table;
	private DefaultTableModel tableModel;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					Search frame = new Search();
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
	public Search() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 800, 500); // Expanded size to fit table
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);

		JLabel lblNewLabel = new JLabel("First Name");
		lblNewLabel.setBounds(29, 25, 92, 34);
		contentPane.add(lblNewLabel);

		FirstNameField = new JTextField();
		FirstNameField.setBounds(129, 28, 157, 30);
		contentPane.add(FirstNameField);
		FirstNameField.setColumns(10);

		JLabel LastName = new JLabel("Last Name");
		LastName.setBounds(29, 69, 92, 34);
		contentPane.add(LastName);

		LastNameField = new JTextField();
		LastNameField.setColumns(10);
		LastNameField.setBounds(129, 72, 157, 30);
		contentPane.add(LastNameField);

		JButton btnNewButton = new JButton("Search");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				try {
					Utility ut = new Utility();

					// Clear previous results
					tableModel.setRowCount(0);

					// Step 1: Get Author Email_ID
					String sql1 = "SELECT Email_ID FROM Author WHERE First_name = ? AND Last_name = ?";
					ut.pstmt = ut.conn.prepareStatement(sql1);
					ut.pstmt.setString(1, FirstNameField.getText());
					ut.pstmt.setString(2, LastNameField.getText());
					ut.rs = ut.pstmt.executeQuery();

					if (!ut.rs.next()) {
						JOptionPane.showMessageDialog(null, "Author not found.");
						return;
					}
					String Email_ID = ut.rs.getString("Email_ID");

					// Step 2: Get Paper_IDs by this author
					String sql2 = "SELECT ID FROM Paper_Author WHERE Email_ID = ?";
					ut.pstmt = ut.conn.prepareStatement(sql2);
					ut.pstmt.setString(1, Email_ID);
					ut.rs = ut.pstmt.executeQuery();

					while (ut.rs.next()) {
						int paperId = ut.rs.getInt("ID");

						String sql3 = "SELECT ID, Status, Abstract, Submission_Date, conference_track, Title FROM Paper WHERE ID = ?";
						ut.pstmt = ut.conn.prepareStatement(sql3);
						ut.pstmt.setInt(1, paperId);
						java.sql.ResultSet rsTitle = ut.pstmt.executeQuery();

						if (rsTitle.next()) {
							Object[] row = {
								rsTitle.getInt("ID"),
								rsTitle.getString("Status"),
								rsTitle.getString("Abstract"),
								rsTitle.getDate("Submission_Date"),
								rsTitle.getString("conference_track"),
								rsTitle.getString("Title")
							};
							tableModel.addRow(row);
						}
						rsTitle.close();
					}

					if (tableModel.getRowCount() == 0) {
						JOptionPane.showMessageDialog(null, "No papers found for this author.");
					}

				} catch (SQLException ex) {
					ex.printStackTrace();
					JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
				}
			}
		});
		btnNewButton.setBounds(51, 120, 85, 30);
		contentPane.add(btnNewButton);

		Back = new JButton("Back");
		Back.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				MainAothur.main(null);
			}
		});
		Back.setBounds(201, 120, 85, 30);
		contentPane.add(Back);

		// Table Model and Table
		tableModel = new DefaultTableModel(new String[]{"ID", "Status", "Abstract", "Submission Date", "Track", "Title"}, 0);
		table = new JTable(tableModel);
		JScrollPane scrollPane = new JScrollPane(table);
		scrollPane.setBounds(10, 170, 760, 270);
		contentPane.add(scrollPane);
	}
}
