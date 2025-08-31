package database;

import java.awt.EventQueue;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.event.ActionListener;
import java.sql.*;
import java.awt.event.ActionEvent;

public class UpdatePaper extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTextField title;
    private JTextField abstractField;
    private JTextField submissionDate;
    private JTextField conference_track;
    private JTextField authorEmail;
    private JTextField contactAuthor;
    private JButton Back;
    private JTextField PaperID;
    private JLabel lblNewLabel;

    /**
     * Launch the application.
     */
    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            try {
                UpdatePaper frame = new UpdatePaper();
                frame.setVisible(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    /**
     * Create the frame.
     */
    public UpdatePaper() {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 600, 450);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));

        setContentPane(contentPane);
        contentPane.setLayout(null);

        JLabel lblTitle = new JLabel("Title");
        lblTitle.setBounds(30, 26, 100, 13);
        contentPane.add(lblTitle);

        JLabel lblAbstract = new JLabel("Abstract");
        lblAbstract.setBounds(30, 49, 100, 13);
        contentPane.add(lblAbstract);

        JLabel lblSubmissionDate = new JLabel("Submission Date (YYYY-MM-DD)");
        lblSubmissionDate.setBounds(30, 81, 200, 13);
        contentPane.add(lblSubmissionDate);

        JLabel lblFileName = new JLabel("conference track");
        lblFileName.setBounds(30, 110, 100, 13);
        contentPane.add(lblFileName);

 
        JLabel lblAuthorEmail = new JLabel("Author Email");
        lblAuthorEmail.setBounds(30, 143, 100, 13);
        contentPane.add(lblAuthorEmail);

        JLabel lblContactAuthor = new JLabel("Contact Author (Yes/No)");
        lblContactAuthor.setBounds(30, 180, 200, 13);
        contentPane.add(lblContactAuthor);

        title = new JTextField();
        title.setBounds(250, 23, 250, 19);
        contentPane.add(title);

        abstractField = new JTextField();
        abstractField.setBounds(250, 52, 250, 19);
        contentPane.add(abstractField);

        submissionDate = new JTextField();
        submissionDate.setBounds(250, 78, 250, 19);
        contentPane.add(submissionDate);

        conference_track = new JTextField();
        conference_track.setBounds(250, 107, 250, 19);
        contentPane.add(conference_track);

        authorEmail = new JTextField();
        authorEmail.setBounds(250, 140, 250, 19);
        contentPane.add(authorEmail);

        contactAuthor = new JTextField();
        contactAuthor.setBounds(250, 177, 250, 19);
        contentPane.add(contactAuthor);

        JButton btnAddPaper = new JButton("Update Paper");
        btnAddPaper.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                try {
                	int id=-1;
                    Utility ut = new Utility();
                    try {
                        ut = new Utility();
                        

                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
                    }

                    String sql2 = "SELECT ID  FROM Paper_Author where Email_ID=? AND ID=?";
                    ut.pstmt = ut.conn.prepareStatement(sql2);
                    ut.pstmt.setString(1, authorEmail.getText());
                    ut.pstmt.setString(2, PaperID.getText());
                    ut.rs = ut.pstmt.executeQuery();

                    if (ut.rs.next()) {
                    	id = ut.rs.getInt("ID");
                        
                    }
                    String sql = "Update Paper set  Title=?, Abstract=?, Submission_Date=TO_DATE(?, 'YYYY-MM-DD'), conference_track=? where ID=? " ;

                    ut.pstmt = ut.conn.prepareStatement(sql);
                    ut.pstmt.setString(1, title.getText());
                    ut.pstmt.setString(2, abstractField.getText());
                    ut.pstmt.setString(3, submissionDate.getText());
                    ut.pstmt.setString(4, conference_track.getText());
                    ut.pstmt.setInt(5, id);
                    

                    int Result = ut.pstmt.executeUpdate();
                    if (Result > 0) {
                        JOptionPane.showMessageDialog(null, "Paper Updated successfully!");
                    } else {
                        JOptionPane.showMessageDialog(null, "Erorr");
                    }
                    
               

                  
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(null, "Database Error: " + ex.getMessage());
                }
            }
        });

        btnAddPaper.setBounds(80, 281, 150, 30);
        contentPane.add(btnAddPaper);
        
        Back = new JButton("Back");
        Back.addActionListener(new ActionListener() {
        	public void actionPerformed(ActionEvent e) {
        		setVisible(false);
				MainAothur.main(null);
        	}
        });
        Back.setBounds(316, 281, 129, 30);
        contentPane.add(Back);
        
        PaperID = new JTextField();
        PaperID.setColumns(10);
        PaperID.setBounds(250, 221, 250, 19);
        contentPane.add(PaperID);
        
        lblNewLabel = new JLabel("Paper ID");
        lblNewLabel.setBounds(30, 224, 65, 13);
        contentPane.add(lblNewLabel);
    }
}
