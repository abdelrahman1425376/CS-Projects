DROP TABLE Reviews;
DROP TABLE Paper_Author;
DROP TABLE Log_Transaction;
DROP TABLE Reviewer;
DROP TABLE Author;
DROP TABLE Paper;
DROP TABLE Log_In;


CREATE TABLE Log_In (
  User_Name      VARCHAR2(50) PRIMARY KEY,
  Email          VARCHAR2(100) UNIQUE NOT NULL,
  Password       VARCHAR2(50) UNIQUE NOT NULL,
  Credentials    VARCHAR2(50) NOT NULL
);

CREATE TABLE Log_Transaction (
  User_Name      VARCHAR2(50) NOT NULL,
  TheDate        DATE NOT NULL,
  Transaction_Type VARCHAR2(50) NOT NULL,
  Table_Name     VARCHAR2(50) NOT NULL,
  Email          VARCHAR2(100) NOT NULL,
  FOREIGN KEY (User_Name) REFERENCES Log_In(User_Name)
);

CREATE TABLE Reviewer (
  Email            VARCHAR2(100) PRIMARY KEY,
  Topic_Of_Intrest VARCHAR2(100) NOT NULL,
  Affiliation      VARCHAR2(100) NOT NULL,
  First_name       VARCHAR2(50) NOT NULL,
  Last_name        VARCHAR2(50) NOT NULL,
  Max_No_Paper     NUMBER NOT NULL,
  EXP_level        VARCHAR2(50) NOT NULL,
  Phone_Number     VARCHAR2(20) NOT NULL,
  FOREIGN KEY (Email) REFERENCES Log_In(Email)
);

CREATE TABLE Author (
  Email_ID       VARCHAR2(100) PRIMARY KEY,
  First_name     VARCHAR2(50) NOT NULL,
  Last_name      VARCHAR2(50) NOT NULL,
  Organization   VARCHAR2(100) NOT NULL,
  Country        VARCHAR2(50) NOT NULL
);

CREATE TABLE Paper (
  ID             NUMBER PRIMARY KEY,
  Status         VARCHAR2(20) CHECK (Status IN ('Submitted', 'Under Review', 'Accepted', 'Rejected')) NOT NULL,
  Title          VARCHAR2(200) NOT NULL,
  Abstract       VARCHAR2(100) NOT NULL,
  Submission_Date DATE NOT NULL,
  conference_track   VARCHAR2(200) NOT NULL
);

CREATE TABLE Paper_Author (
  Email_ID       VARCHAR2(100) NOT NULL,
  ID             NUMBER NOT NULL,
  Contact_Author VARCHAR2(5) CHECK (Contact_Author IN ('Yes', 'No')) NOT NULL,
  PRIMARY KEY (Email_ID, ID),
  FOREIGN KEY (Email_ID) REFERENCES Author(Email_ID),
  FOREIGN KEY (ID) REFERENCES Paper(ID)
);

CREATE TABLE Reviews (
  ID                          NUMBER NOT NULL,
  Email                       VARCHAR2(100) NOT NULL,
  Submission_Date             DATE NOT NULL,
  readability_score           NUMBER CHECK (readability_score BETWEEN 1 AND 10),
  originality_score           NUMBER CHECK (originality_score BETWEEN 1 AND 10),
  conference_relevance_score NUMBER CHECK (conference_relevance_score BETWEEN 1 AND 10),
  technical_merit_score       NUMBER CHECK (technical_merit_score BETWEEN 1 AND 10),
  PRIMARY KEY (ID, Email),
  FOREIGN KEY (ID) REFERENCES Paper(ID),
  FOREIGN KEY (Email) REFERENCES Reviewer(Email)
);

INSERT INTO Log_In VALUES ('admin', 'admin@gmail.com', 'admin', 'admin');
INSERT INTO Log_In VALUES ('jane', 'jane@gmail.com', 'jane', 'Reviewer');
INSERT INTO Log_In VALUES ('michael', 'michael@gmail.com', 'michael', 'Reviewer');
INSERT INTO Log_In VALUES ('susan', 'susan@gmail.com', 'susan', 'Reviewer');
INSERT INTO Log_In VALUES ('linda', 'linda@gmail.com', 'linda', 'Reviewer'); 
INSERT INTO Log_In VALUES ('john', 'john@gmail.com', 'john', 'Reviewer');
INSERT INTO Log_In VALUES ('alice', 'author1@gmail.com', 'author1', 'Author');
INSERT INTO Log_In VALUES ('bob', 'author2@gmail.com', 'author2', 'Author');
INSERT INTO Log_In VALUES ('charlie', 'author3@gmail.com', 'author3', 'Author');
INSERT INTO Log_In VALUES ('diana', 'author4@gmail.com', 'author4', 'Author');
INSERT INTO Log_In VALUES ('eric', 'author5@gmail.com', 'author5', 'Author');


INSERT INTO Log_Transaction VALUES ('linda', TO_DATE('2024-04-01', 'YYYY-MM-DD'), 'ADD', 'Author', 'linda@gmail.com');
INSERT INTO Log_Transaction VALUES ('michael', TO_DATE('2024-04-02', 'YYYY-MM-DD'), 'UPDATE', 'Author', 'michael@gmail.com');
INSERT INTO Log_Transaction VALUES ('susan', TO_DATE('2024-04-03', 'YYYY-MM-DD'), 'DELETE', 'Author', 'susan@gmail.com');
INSERT INTO Log_Transaction VALUES ('linda', TO_DATE('2024-04-04', 'YYYY-MM-DD'), 'ADD', 'Author', 'linda@gmail.com');
INSERT INTO Log_Transaction VALUES ('linda', TO_DATE('2024-04-05', 'YYYY-MM-DD'), 'UPDATE', 'Author', 'linda@gmail.com');


INSERT INTO Reviewer VALUES ('jane@gmail.com', 'AI and ML', 'Tech University', 'Jane', 'Smith', 5, 'Expert', '555-1234');
INSERT INTO Reviewer VALUES ('michael@gmail.com', 'Cybersecurity', 'Cyber Corp', 'Michael', 'Brown', 3, 'Intermediate', '555-5678');
INSERT INTO Reviewer VALUES ('susan@gmail.com', 'Data Science', 'DataWorks', 'Susan', 'King', 4, 'Expert', '555-9876');
INSERT INTO Reviewer VALUES ('linda@gmail.com', 'Blockchain', 'Block Inc.', 'Linda', 'Carter', 2, 'Beginner', '555-4567');
INSERT INTO Reviewer VALUES ('john@gmail.com', 'Networks', 'Net Solutions', 'John', 'Doe', 6, 'Advanced', '555-1122');


INSERT INTO Author VALUES ('author1@gmail.com', 'Alice', 'Wong', 'Global Uni', 'USA');
INSERT INTO Author VALUES ('author2@gmail.com', 'Bob', 'Lee', 'Tech Corp', 'Canada');
INSERT INTO Author VALUES ('author3@gmail.com', 'Charlie', 'Kim', 'Future Lab', 'UK');
INSERT INTO Author VALUES ('author4@gmail.com', 'Diana', 'Lopez', 'InnovateX', 'Germany');
INSERT INTO Author VALUES ('author5@gmail.com', 'Eric', 'Nguyen', 'NextGen Institute', 'Australia');


INSERT INTO Paper VALUES (1, 'Submitted', 'Next-Gen AI', 'A deep dive into future of AI.', TO_DATE('2024-03-15', 'YYYY-MM-DD'), 'ai');
INSERT INTO Paper VALUES (2, 'Under Review', 'Cybersecurity Threats', 'Examining the modern threats to cyber world.', TO_DATE('2024-03-18', 'YYYY-MM-DD'), 'cyber_threats');
INSERT INTO Paper VALUES (3, 'Accepted', 'Data-Driven Decisions', 'Using big data for smarter choices.', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'data_decisions');
INSERT INTO Paper VALUES (4, 'Rejected', 'Blockchain Basics', 'Foundational understanding of blockchain.', TO_DATE('2024-03-22', 'YYYY-MM-DD'), 'blockchain_basics');
INSERT INTO Paper VALUES (5, 'Submitted', 'Quantum Computing', 'The quantum leap in computing.', TO_DATE('2024-03-25', 'YYYY-MM-DD'), 'quantum_paper');


INSERT INTO Paper_Author VALUES ('author1@gmail.com', 1, 'Yes');
INSERT INTO Paper_Author VALUES ('author2@gmail.com', 1, 'No');
INSERT INTO Paper_Author VALUES ('author3@gmail.com', 2, 'No');
INSERT INTO Paper_Author VALUES ('author4@gmail.com', 3, 'No');
INSERT INTO Paper_Author VALUES ('author5@gmail.com', 4, 'No');
INSERT INTO Paper_Author VALUES ('author1@gmail.com', 5, 'No');


INSERT INTO Reviews VALUES (1,'jane@gmail.com', TO_DATE('2024-04-10', 'YYYY-MM-DD'), 8, 9, 7, 10);
INSERT INTO Reviews VALUES (2,'michael@gmail.com', TO_DATE('2024-04-11', 'YYYY-MM-DD'), 7, 8, 8, 9);
INSERT INTO Reviews VALUES (3,'susan@gmail.com', TO_DATE('2024-04-12', 'YYYY-MM-DD'), 9, 9, 10, 10);
INSERT INTO Reviews VALUES (4,'linda@gmail.com', TO_DATE('2024-04-13', 'YYYY-MM-DD'), 6, 7, 6, 7);
INSERT INTO Reviews VALUES (5,'john@gmail.com', TO_DATE('2024-04-14', 'YYYY-MM-DD'), 8, 8, 9, 9);

COMMIT;




CREATE OR REPLACE TRIGGER author_logIn_trigger
AFTER INSERT OR DELETE OR UPDATE ON Author
FOR EACH ROW
DECLARE
  v_Email     Log_In.Email%type;
  v_userName Log_In.User_Name%type;
  v_transaction    VARCHAR2(10);    
  
BEGIN

  IF INSERTING THEN
    v_Email  := :NEW.Email_ID;
    v_transaction := 'ADD';
  ELSIF DELETING THEN
    v_Email  := :OLD.Email_ID;
    v_transaction := 'DELETE';
  ELSIF UPDATING THEN
    v_Email  := :NEW.Email_ID;
    v_transaction := 'UPDATE';
  END IF;


  SELECT User_Name INTO v_userName
  FROM Log_In
  WHERE Email = v_Email ;

 
  INSERT INTO Log_Transaction (User_Name, TheDate, Transaction_Type, Table_Name, Email)
  VALUES (v_username, SYSDATE, v_transaction, 'Author', v_email);
END;

/



CREATE OR REPLACE TRIGGER paper_status_trigger
AFTER UPDATE OF Status ON Paper
FOR EACH ROW
DECLARE
   v_Email      Log_In.Email%type;
   v_userName   Log_In.User_Name%type;
BEGIN
  IF :OLD.Status IN ('Submitted', 'Under Review') AND :NEW.Status IN ('Accepted', 'Rejected') THEN


    SELECT Email_ID INTO v_Email
    FROM Paper_Author
    WHERE ID = :NEW.ID AND Contact_Author = 'Yes';


    SELECT User_Name INTO v_userName
    FROM Log_In
    WHERE Email = v_Email;

    
    INSERT INTO Log_Transaction (User_Name, TheDate, Transaction_Type, Table_Name, Email)
    VALUES (v_userName, SYSDATE, 'STATUS CHANGE', 'Paper', v_Email);

  END IF;
END;
/

CREATE OR REPLACE VIEW Paper_Status_Report AS
SELECT
  P.ID AS Paper_ID,
  P.Title,
  P.Status,
  A.First_name AS Author_First_Name,
  A.Last_name AS Author_Last_Name,
  R.First_name AS Reviewer_First_Name,
  R.Last_name AS Reviewer_Last_Name
FROM Paper P
JOIN Paper_Author PA ON P.ID = PA.ID
JOIN Author A ON PA.Email_ID = A.Email_ID
LEFT JOIN Reviews RV ON P.ID = RV.ID
LEFT JOIN Reviewer R ON RV.Email = R.Email;


CREATE OR REPLACE VIEW Conference_Summary_Report AS
SELECT
  COUNT(*) AS Total_Paper_Submitted,
  SUM(CASE
  WHEN Status = 'Accepted'
  THEN 1 
  ELSE 0 
  END) AS Total_Paper_Accepted
FROM Paper;