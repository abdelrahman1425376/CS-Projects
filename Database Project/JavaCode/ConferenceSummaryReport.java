package database;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConferenceSummaryReport extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JLabel totalSubmittedLabel;
    private JLabel totalAcceptedLabel;
    private JButton Back;

    
    
    public static void main(String[] args) {
        EventQueue.invokeLater(new Runnable() {
            public void run() {
                try {
                    ConferenceSummaryReport frame = new ConferenceSummaryReport();
                    frame.setVisible(true);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    

    public ConferenceSummaryReport() {
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 450, 250);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(null);

        JLabel lblHeader = new JLabel("Conference Summary Report");
        lblHeader.setFont(new Font("Tahoma", Font.BOLD, 16));
        lblHeader.setBounds(90, 10, 300, 30);
        contentPane.add(lblHeader);

        totalSubmittedLabel = new JLabel("Total Submitted Papers: ");
        totalSubmittedLabel.setBounds(30, 60, 300, 25);
        contentPane.add(totalSubmittedLabel);

        totalAcceptedLabel = new JLabel("Total Accepted Papers: ");
        totalAcceptedLabel.setBounds(30, 100, 300, 25);
        contentPane.add(totalAcceptedLabel);

        Back = new JButton("Back");
        Back.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                MainAdmin.main(null);
            }
        });
        Back.setBounds(150, 150, 120, 30);
        contentPane.add(Back);

        loadSummaryData();
    }

    private void loadSummaryData() {
        try {
            Utility ut = new Utility();
            String sql = "SELECT * FROM Conference_Summary_Report";
            ut.pstmt = ut.conn.prepareStatement(sql);
            ResultSet rs = ut.pstmt.executeQuery();

            if (rs.next()) {
                int totalSubmitted = rs.getInt("Total_Paper_Submitted");
                int totalAccepted = rs.getInt("Total_Paper_Accepted");

                totalSubmittedLabel.setText("Total Submitted Papers: " + totalSubmitted);
                totalAcceptedLabel.setText("Total Accepted Papers: " + totalAccepted);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }
    }
} 
