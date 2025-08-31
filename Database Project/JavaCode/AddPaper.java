package database;

import java.awt.EventQueue;
import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.event.ActionListener;
import java.sql.*;
import java.awt.event.ActionEvent;

public class AddPaper extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTextField title;
    private JTextField abstractField;
    private JTextField submissionDate;
    private JTextField conference_track;
    private JTextField authorEmail;
    private JTextField contactAuthor;
    private JButton back;

    /**
     * Launch the application.
     */
    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            try {
                AddPaper frame = new AddPaper();
                frame.setVisible(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    /**
     * Create the frame.
     */
    public AddPaper() {
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

        JButton btnAddPaper = new JButton("Add Paper");
        btnAddPaper.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                try {
                	int count=0;
                    Utility ut = new Utility();
                    try {
                        ut = new Utility();
                        String sql2 = "SELECT COUNT(*) AS total FROM Paper";
                        ut.pstmt = ut.conn.prepareStatement(sql2);
                        ut.rs = ut.pstmt.executeQuery();

                        if (ut.rs.next()) {
                            count = ut.rs.getInt("total");
                            
                        }
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                        JOptionPane.showMessageDialog(null, "Error: " + ex.getMessage());
                    }

                    
                    String sql = "INSERT INTO Paper (ID, Status, Title, Abstract, Submission_Date, conference_track) " +
                                 "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?) " ;

                    ut.pstmt = ut.conn.prepareStatement(sql);
                    ut.pstmt.setInt(1, count+1);
                    ut.pstmt.setString(2, "Submitted");
                    ut.pstmt.setString(3, title.getText());
                    ut.pstmt.setString(4, abstractField.getText());
                    ut.pstmt.setString(5, submissionDate.getText());
                    ut.pstmt.setString(6, conference_track.getText());
                    

                    int Result = ut.pstmt.executeUpdate();
                    if (Result > 0) {
                        JOptionPane.showMessageDialog(null, "Paper added successfully!\nPaper ID: ");
                    } else {
                        JOptionPane.showMessageDialog(null, "Paper added, but failed to add Author.");
                    }
                    
               

                   
                    String authorSql = "INSERT INTO Paper_Author (Email_ID, ID, Contact_Author) VALUES (?, ?, ?)";
                    ut.pstmt = ut.conn.prepareStatement(authorSql);
                    ut.pstmt.setString(1, authorEmail.getText());
                    ut.pstmt.setInt(2, count+1);
                    ut.pstmt.setString(3, contactAuthor.getText());

                    int authorResult = ut.pstmt.executeUpdate();

                    if (authorResult > 0) {
                        JOptionPane.showMessageDialog(null, "Paper and Author added successfully! ");
                    } else {
                        JOptionPane.showMessageDialog(null, "Paper added, but failed to add Author.");
                    }

                } catch (SQLException ex) {
                    ex.printStackTrace();
                    JOptionPane.showMessageDialog(null, "Database Error: " + ex.getMessage());
                }
            }
        });

        btnAddPaper.setBounds(76, 270, 150, 30);
        contentPane.add(btnAddPaper);
        
        back = new JButton("Back");
        back.addActionListener(new ActionListener() {
        	public void actionPerformed(ActionEvent e) {
        		setVisible(false);
        		MainAothur.main(null);
        	}
        });
        back.setBounds(341, 270, 153, 30);
        contentPane.add(back);
    }
}
