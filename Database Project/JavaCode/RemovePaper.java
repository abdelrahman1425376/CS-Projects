package database;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.sql.SQLException;
import java.awt.event.ActionEvent;

public class RemovePaper extends JFrame {

	private static final long serialVersionUID = 1L;
	private JPanel contentPane;
	private JTextField PaperID;
	private JButton Back;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					RemovePaper frame = new RemovePaper();
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
	public RemovePaper() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 376, 208);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel lblNewLabel = new JLabel("PaperID");
		lblNewLabel.setBounds(75, 41, 51, 40);
		contentPane.add(lblNewLabel);
		
		PaperID = new JTextField();
		PaperID.setBounds(130, 47, 157, 30);
		contentPane.add(PaperID);
		PaperID.setColumns(10);
		
		JButton btnNewButton = new JButton("Remove");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
                	int ID=0;
                    try {
                    	Utility ut = new Utility();
                        

                        
                        
                           
                            String deleteSQL1 = "DELETE FROM Paper_Author WHERE ID = ?";
                            ut.pstmt = ut.conn.prepareStatement(deleteSQL1);
                            ut.pstmt.setString(1, PaperID.getText());
                            ut.pstmt.executeUpdate();
                            
                            String deleteSQL2 = "DELETE FROM Reviews WHERE ID = ?";
                            ut.pstmt = ut.conn.prepareStatement(deleteSQL2);
                            ut.pstmt.setString(1, PaperID.getText());
                            ut.pstmt.executeUpdate();
                            
                            String deleteSQL3 = "DELETE FROM Paper WHERE ID = ?";
                            ut.pstmt = ut.conn.prepareStatement(deleteSQL3);
                            ut.pstmt.setString(1, PaperID.getText());
                            ut.pstmt.executeUpdate();
                            JOptionPane.showMessageDialog(null, "Paper deleted successfully.");
                       
                        
                        
                        
                        
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
                    }
				
				
				
				
			}
		});
		btnNewButton.setBounds(63, 114, 85, 21);
		contentPane.add(btnNewButton);
		
		Back = new JButton("Back");
		Back.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				setVisible(false);
				MainAothur.main(null);
			}
		});
		Back.setBounds(218, 114, 85, 21);
		contentPane.add(Back);
	}
}
