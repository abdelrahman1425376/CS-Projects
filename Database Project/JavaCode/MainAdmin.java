package database;

import java.awt.EventQueue;
import javax.swing.*;
import javax.swing.border.EmptyBorder;

import java.awt.event.*;
import java.awt.Font;

public class MainAdmin extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;

	public static void main(String[] args) {
		EventQueue.invokeLater(() -> {
			try {
				MainAdmin frame = new MainAdmin();
				frame.setVisible(true);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}

	public MainAdmin() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 448, 281);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(10, 10, 10, 10));
		setContentPane(contentPane);
		contentPane.setLayout(null);

		JLabel lblTitle = new JLabel("Manage Authors");
		lblTitle.setFont(new Font("Tahoma", Font.PLAIN, 18));
		lblTitle.setBounds(154, 10, 160, 30);
		contentPane.add(lblTitle);

		JButton btnAdd = new JButton("Add Author");
		btnAdd.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnAdd.setBounds(10, 60, 198, 40);
		btnAdd.addActionListener(e -> {
			setVisible(false);
			AddAuthor.main(null);
		});
		contentPane.add(btnAdd);

		JButton btnUpdate = new JButton("Update Author");
		btnUpdate.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnUpdate.setBounds(233, 60, 198, 40);
		btnUpdate.addActionListener(e -> {
			setVisible(false);
			UpdateAuthor.main(null);
		});
		contentPane.add(btnUpdate);

		JButton btnDelete = new JButton("Delete Author");
		btnDelete.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnDelete.setBounds(233, 110, 198, 40);
		btnDelete.addActionListener(e -> {
			setVisible(false);
			DeleteAuthor.main(null);
		});
		contentPane.add(btnDelete);
		
		JButton btnStatusReport = new JButton("Paper Status Report");
		btnStatusReport.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				PaperStatusReport.main(null);
			}
		});
		btnStatusReport.setFont(new Font("Tahoma", Font.PLAIN, 14));
		btnStatusReport.setBounds(10, 110, 198, 40);
		contentPane.add(btnStatusReport);
		
		JButton btnSummaryReport = new JButton("Conference Summary Report");
		btnSummaryReport.addActionListener(new ActionListener() {
    	public void actionPerformed(ActionEvent e) {
        setVisible(false);
        ConferenceSummaryReport.main(null); 
   			}
		});
		btnSummaryReport.setFont(new Font("Tahoma", Font.PLAIN, 12));
		btnSummaryReport.setBounds(10, 167, 198, 40);
		contentPane.add(btnSummaryReport);

		
	}
}