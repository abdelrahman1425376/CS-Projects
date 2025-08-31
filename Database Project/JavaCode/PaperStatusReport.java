package database;

import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.sql.SQLException;

public class PaperStatusReport extends JFrame {

    private static final long serialVersionUID = 1L;
    private JPanel contentPane;
    private JTable table;
    private DefaultTableModel tableModel;

    


    public static void main(String[] args) {
        EventQueue.invokeLater(() -> {
            try {
                PaperStatusReport frame = new PaperStatusReport();
                frame.setVisible(true);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }



    public PaperStatusReport() {
        setTitle("Paper Status Report");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setBounds(100, 100, 900, 400);
        contentPane = new JPanel();
        contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
        setContentPane(contentPane);
        contentPane.setLayout(new BorderLayout());

        
        tableModel = new DefaultTableModel(new String[]{
            "Paper ID", "Title", "Status", 
            "Author First Name", "Author Last Name", 
            "Reviewer First Name", "Reviewer Last Name"
        }, 0);
        table = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(table);
        contentPane.add(scrollPane, BorderLayout.CENTER);

        
        loadReportData();

        
        JButton backButton = new JButton("Back");
        backButton.addActionListener((ActionEvent e) -> {
            setVisible(false);
            MainAdmin.main(null);
        });
        JPanel bottomPanel = new JPanel();
        bottomPanel.add(backButton);
        contentPane.add(bottomPanel, BorderLayout.SOUTH);
    }

    private void loadReportData() {
        try {
            Utility ut = new Utility();
            String sql = "SELECT * FROM Paper_Status_Report";
            ut.pstmt = ut.conn.prepareStatement(sql);
            ut.rs = ut.pstmt.executeQuery();

            while (ut.rs.next()) {
                Object[] row = {
                    ut.rs.getInt("Paper_ID"),
                    ut.rs.getString("Title"),
                    ut.rs.getString("Status"),
                    ut.rs.getString("Author_First_Name"),
                    ut.rs.getString("Author_Last_Name"),
                    ut.rs.getString("Reviewer_First_Name"),
                    ut.rs.getString("Reviewer_Last_Name")
                };
                tableModel.addRow(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }
    }
}
