-- REM   Script: Green Gadgets - DDL
-- REM   DDL and DML for Green Gadgets - Refurb and Recycle
-- Have used Mockaroo to generate data and have maintained the foreign key contraints and all the other constraints using specific data. 

CREATE TABLE CollectionCenter (
                                  CollectionCenterID INT GENERATED ALWAYS AS IDENTITY
                                      (START WITH 1
                                      INCREMENT BY 1
                                      MINVALUE 1
                                      MAXVALUE 10000
                                      NOCYCLE) ,
                                  Address VARCHAR(250) NOT NULL,
                                  CenterName VARCHAR(100) NOT NULL,
                                  Capactity INT NOT NULL,
                                  Email VARCHAR(100) NOT NULL,
                                  OpeningTime DATE NOT NULL,
                                  ClosingTime DATE NOT NULL,
                                  State CHAR(2) NOT NULL,
                                  City VARCHAR(50) NOT NULL,
                                  Zipcode CHAR(5) NOT NULL,
                                  PRIMARY KEY (CollectionCenterID),
                                  CONSTRAINT CK_State CHECK (State IN ('AL','AK','AZ','AR','AS','CA','CO','CT','DE','DC','FL','GA','GU','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','MP','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','TT','UT','VT','VA','VI','WA','WV','WI','WY'))
);

CREATE TABLE ItemLine (
                          ItemLineID INT GENERATED ALWAYS AS IDENTITY
                              (START WITH 1
                              INCREMENT BY 1
                              MINVALUE 1
                              MAXVALUE 10000
                              NOCYCLE) ,
                          ItemName VARCHAR(50) NOT NULL,
                          Category VARCHAR(50) CHECK (Category IN ('PHONE', 'LAPTOP', 'EARPHONE', 'CHARGER', 'ADAPTER', 'CABLE', 'KEYBOARD', 'MOUSE', 'TRACKPAD', 'MONITOR')) NOT NULL,
                          Brand VARCHAR(50) NOT NULL,
                          Year CHAR(4) NOT NULL,
                          CONSTRAINT PK_ItemLine PRIMARY KEY (ItemLineID)
);

CREATE TABLE Customer (
                          CustomerID INT GENERATED ALWAYS AS IDENTITY
                              (START WITH 1
                              INCREMENT BY 1
                              MINVALUE 1
                              MAXVALUE 10000
                              NOCYCLE),
                          Address VARCHAR(250) NOT NULL,
                          FirstName VARCHAR(50) NOT NULL,
                          LastName VARCHAR(50) NOT NULL,
                          MobileNo CHAR(10) NOT NULL,
                          EmailID VARCHAR(100),
                          RegistrationDate DATE DEFAULT SYSDATE,
                          State CHAR(2) NOT NULL,
                          City VARCHAR(50) NOT NULL,
                          Zipcode CHAR(5) NOT NULL,
                          PRIMARY KEY (CustomerID),
                          CONSTRAINT CK_Customer_State CHECK (State IN ('AL','AK','AZ','AR','AS','CA','CO','CT','DE','DC','FL','GA','GU','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','MP','OH','OK','OR','PA','PR','RI','SC','SD','TN','TX','TT','UT','VT','VA','VI','WA','WV','WI','WY'))
);

CREATE TABLE "Order" (
                         OrderID INT GENERATED ALWAYS AS IDENTITY
                             (START WITH 1
                             INCREMENT BY 1
                             MINVALUE 1
                             MAXVALUE 10000
                             NOCYCLE),
                         CustomerID INT NOT NULL,
                         OrderDate Date DEFAULT SYSDATE NOT NULL,
                         Amount Decimal(10,2) NOT NULL,
                         PRIMARY KEY (OrderID),
                         CONSTRAINT FK_Order FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Item (
                      ItemID INT GENERATED ALWAYS AS IDENTITY
                          (START WITH 1
                          INCREMENT BY 1
                          MINVALUE 1
                          MAXVALUE 10000
                          NOCYCLE) ,
                      ItemLineID INT  NOT NULL,
                      OrderID INT  NOT NULL,
                      SerialNo VARCHAR(20) NOT NULL,
                      Price Decimal(10,2) NOT NULL,
                      Status VARCHAR(50) CHECK (STATUS IN ('DISCARDED', 'REFURBISHED')),
                      FaultReason VARCHAR(250),
                      CollectionCenterID INT,
                      CONSTRAINT PK_Item PRIMARY KEY (ItemID),
                      CONSTRAINT FK_Item FOREIGN KEY (ItemLineID) REFERENCES ItemLine(ItemLineID),
                      CONSTRAINT FK_Item_Order FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID),
                      CONSTRAINT CK_Item_FaultReason_NotNull CHECK (Status != 'DISCARDED' OR FaultReason IS NOT NULL),
  CONSTRAINT CK_Item_CollectionCenterID_NotNull CHECK (Status != 'REFURBISHED' OR CollectionCenterID IS NOT NULL),
  CONSTRAINT FK_RefurbishedItem FOREIGN KEY (CollectionCenterID) REFERENCES CollectionCenter(CollectionCenterID)
    );

CREATE TABLE Technician (
                            TechnicianID INT GENERATED ALWAYS AS IDENTITY
                                (START WITH 1
                                INCREMENT BY 1
                                MINVALUE 1
                                MAXVALUE 10000
                                NOCYCLE),
                            Expertise VARCHAR(100) NOT NULL,
                            Email VARCHAR(100),
                            MobileNo CHAR(10) NOT NULL,
                            PRIMARY KEY (TechnicianID)
);

CREATE TABLE RefurbishmentService (
                                      ServiceID INT GENERATED ALWAYS AS IDENTITY
                                          (START WITH 1
                                          INCREMENT BY 1
                                          MINVALUE 1
                                          MAXVALUE 10000
                                          NOCYCLE),
                                      ItemID INT NOT NULL,
                                      TechnicianID INT NOT NULL,
                                      RefurbDate DATE,
                                      PRIMARY KEY (ServiceID),
                                      CONSTRAINT FK_TechnicianID FOREIGN KEY (TechnicianID) REFERENCES Technician(TechnicianID),
                                      CONSTRAINT FK_ItemID FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
);

CREATE TABLE Feedback (
                          FeedbackID INT GENERATED ALWAYS AS IDENTITY
                              (START WITH 1
                              INCREMENT BY 1
                              MINVALUE 1
                              MAXVALUE 10000
                              NOCYCLE),
                          OrderID INT NOT NULL,
                          Message VARCHAR(350) NOT NULL,
                          PRIMARY KEY (FeedbackID),
                          CONSTRAINT FK_Feedback FOREIGN KEY (OrderID) REFERENCES "Order"(OrderID)
);

---- INSERT ---

INSERT INTO CollectionCenter (Address, CenterName, Capactity, Email, OpeningTime, ClosingTime, State, City, Zipcode)
SELECT '368 Grim Center', 'Kessler-Keebler', 5051, 'miron0@parallels.com', TO_DATE('2024-07-20 11:02:16', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-17 06:00:59', 'YYYY-MM-DD HH24:MI:SS'), 'DC', 'Washington', '20319' FROM dual
UNION ALL
SELECT '93888 Upham Parkway', 'Boehm, Jacobson and Mraz', 9453, 'nburridge1@joomla.org', TO_DATE('2024-07-23 22:38:08', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-01 23:39:25', 'YYYY-MM-DD HH24:MI:SS'), 'IA', 'Des Moines', '50315' FROM dual
UNION ALL
SELECT '84337 Montana Place', 'D''Amore Inc', 6749, 'schansonnau2@dyndns.org', TO_DATE('2024-05-15 03:27:30', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-05-10 07:52:10', 'YYYY-MM-DD HH24:MI:SS'), 'KS', 'Shawnee Mission', '66220' FROM dual
UNION ALL
SELECT '453 Morning Alley', 'Johnston-Hessel', 1180, 'kdoumerque3@wired.com', TO_DATE('2024-04-27 17:54:55', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-12-13 21:25:17', 'YYYY-MM-DD HH24:MI:SS'), 'OH', 'Columbus', '43210' FROM dual
UNION ALL
SELECT '3 Iowa Point', 'Gulgowski, Rowe and Goyette', 872, 'lminogue4@ft.com', TO_DATE('2024-06-03 04:13:41', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-02-28 12:31:16', 'YYYY-MM-DD HH24:MI:SS'), 'MA', 'Watertown', '02472' FROM dual
UNION ALL
SELECT '5 Ridge Oak Trail', 'Parisian Inc', 2553, 'dcakes5@harvard.edu', TO_DATE('2023-11-03 07:26:44', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-01-11 10:06:08', 'YYYY-MM-DD HH24:MI:SS'), 'NJ', 'New Brunswick', '08922' FROM dual
UNION ALL
SELECT '371 Marquette Trail', 'Jones and Sons', 7066, 'myakunin6@examiner.com', TO_DATE('2024-01-21 13:56:31', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-07 13:37:14', 'YYYY-MM-DD HH24:MI:SS'), 'WV', 'Charleston', '25331' FROM dual
UNION ALL
SELECT '41321 Acker Alley', 'Kutch-Sawayn', 2239, 'abertomier7@youtube.com', TO_DATE('2024-01-19 03:35:50', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-04-08 21:24:37', 'YYYY-MM-DD HH24:MI:SS'), 'IL', 'Palatine', '60078' FROM dual
UNION ALL
SELECT '8 Cordelia Center', 'Howe Inc', 2773, 'mkubczak8@cmu.edu', TO_DATE('2023-10-25 03:15:55', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-12-09 09:01:17', 'YYYY-MM-DD HH24:MI:SS'), 'NY', 'Brooklyn', '11241' FROM dual
UNION ALL
SELECT '52077 Bunting Crossing', 'Romaguera LLC', 3540, 'gfrancescuzzi9@people.com.cn', TO_DATE('2024-03-24 16:29:33', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-06-05 06:05:44', 'YYYY-MM-DD HH24:MI:SS'), 'PA', 'Philadelphia', '19172' FROM dual
UNION ALL
SELECT '66 Bashford Way', 'Veum LLC', 3284, 'gmillerya@google.nl', TO_DATE('2023-08-14 23:50:32', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-08-29 03:58:02', 'YYYY-MM-DD HH24:MI:SS'), 'TX', 'Plano', '75074' FROM dual
UNION ALL
SELECT '01282 Maryland Trail', 'Kuhic-Wolff', 7812, 'cshayesb@oracle.com', TO_DATE('2024-01-25 10:49:47', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2024-03-31 08:43:19', 'YYYY-MM-DD HH24:MI:SS'), 'LA', 'New Orleans', '70116' FROM dual
UNION ALL
SELECT '549 Straubel Crossing', 'Wisozk, McClure and Erdman', 4609, 'amitchelmorec@alibaba.com', TO_DATE('2024-05-01 00:33:35', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-02 23:16:41', 'YYYY-MM-DD HH24:MI:SS'), 'CA', 'Northridge', '91328' FROM dual
UNION ALL
SELECT '768 Springview Alley', 'Schamberger-Lebsack', 7641, 'psconesd@prlog.org', TO_DATE('2024-06-06 09:48:15', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-10-22 13:37:39', 'YYYY-MM-DD HH24:MI:SS'), 'PA', 'Philadelphia', '19115' FROM dual
UNION ALL
SELECT '407 Holy Cross Parkway', 'Grimes Group', 7308, 'ktrusslovee@liveinternet.ru', TO_DATE('2023-10-23 20:44:36', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2023-12-27 16:11:57', 'YYYY-MM-DD HH24:MI:SS'), 'NV', 'Carson City', '89714' FROM dual;


INSERT INTO ItemLine (ItemName, Brand, Category, Year)
SELECT 'LG CU515', 'LG', 'PHONE', '2007' FROM dual
UNION ALL
SELECT 'HP Pre 3', 'HP', 'PHONE', '2011' FROM dual
UNION ALL
SELECT 'Sony Ericsson T610', 'Sony', 'PHONE', '2003' FROM dual
UNION ALL
SELECT 'Sony Ericsson W380', 'Sony', 'PHONE', '2008' FROM dual
UNION ALL
SELECT 'alcatel 1V (2020)', 'alcatel', 'PHONE', '2020' FROM dual
UNION ALL
SELECT 'Sony Ericsson Live with Walkman', 'Sony', 'PHONE', '2011' FROM dual
UNION ALL
SELECT 'Gionee S12 Lite', 'Gionee', 'PHONE', '2020' FROM dual
UNION ALL
SELECT 'Eten M600', 'Eten', 'PHONE', '2005' FROM dual
UNION ALL
SELECT 'alcatel 3 (2019)', 'alcatel', 'PHONE', '2019' FROM dual
UNION ALL
SELECT 'XOLO A500S IPS', 'XOLO', 'PHONE', '2013' FROM dual
UNION ALL
SELECT 'XOLO A500', 'XOLO', 'PHONE', '2013' FROM dual
UNION ALL
SELECT 'LG A230', 'LG', 'PHONE', '2011' FROM dual
UNION ALL
SELECT 'Samsung M8910 Pixon12', 'Samsung', 'PHONE', '2009' FROM dual
UNION ALL
SELECT 'VK Mobile VK4000', 'VK', 'PHONE', '2006' FROM dual
UNION ALL
SELECT 'Kyocera S1600', 'Kyocera', 'PHONE', '2008' FROM dual;


INSERT INTO Customer (Address, FirstName, LastName, MobileNo, EmailId, RegistrationDate, State, City, Zipcode)
SELECT '6620 Grayhawk Road', 'Tedi', 'Megarrell', '6064272098', 'tmegarrell0@quantcast.com', TO_DATE('08/09/2023', 'MM/DD/YYYY'), 'KY', 'London', '40745' FROM dual
UNION ALL
SELECT '5 Mockingbird Pass', 'Staffard', 'Taplow', '3186599997', 'staplow1@wiley.com', TO_DATE('07/10/2023', 'MM/DD/YYYY'), 'LA', 'Shreveport', '71166' FROM dual
UNION ALL
SELECT '07 Havey Park', 'Antony', 'Myers', '5059134502', 'amyers2@sakura.ne.jp', TO_DATE('06/09/2022', 'MM/DD/YYYY'), 'NM', 'Albuquerque', '87121' FROM dual
UNION ALL
SELECT '4194 Kropf Junction', 'Cherye', 'McNeigh', '2026541635', 'cmcneigh3@last.fm', TO_DATE('02/07/2023', 'MM/DD/YYYY'), 'DC', 'Washington', '20231' FROM dual
UNION ALL
SELECT '38355 Summer Ridge Point', 'Johannes', 'Pavy', '2539512273', 'jpavy4@constantcontact.com', TO_DATE('11/11/2023', 'MM/DD/YYYY'), 'WA', 'Tacoma', '98411' FROM dual
UNION ALL
SELECT '624 Aberg Road', 'Gill', 'Creagh', '4053553151', 'gcreagh5@myspace.com', TO_DATE('12/09/2022', 'MM/DD/YYYY'), 'OK', 'Oklahoma City', '73142' FROM dual
UNION ALL
SELECT '9 Paget Road', 'Teresina', 'Byllam', '2036276167', 'tbyllam6@usda.gov', TO_DATE('01/22/2024', 'MM/DD/YYYY'), 'CT', 'New Haven', '6520' FROM dual
UNION ALL
SELECT '9578 Daystar Court', 'Walker', 'Fitzsimons', '5028427577', 'wfitzsimons7@techcrunch.com', TO_DATE('05/05/2024', 'MM/DD/YYYY'), 'KY', 'Louisville', '40210' FROM dual
UNION ALL
SELECT '57 Mccormick Road', 'Annabel', 'Cawker', '3091571326', 'acawker8@smugmug.com', TO_DATE('03/09/2024', 'MM/DD/YYYY'), 'IL', 'Bloomington', '61709' FROM dual
UNION ALL
SELECT  '77451 Continental Parkway', 'Myron', 'Older', '7579694790', 'molder9@last.fm', TO_DATE('02/09/2024', 'MM/DD/YYYY'), 'VA', 'Norfolk', '23509' FROM dual
UNION ALL
SELECT  '6 Petterle Road', 'Alejandra', 'Worgen', '7726512237', 'aworgen@blinklist.com', TO_DATE('04/09/2024', 'MM/DD/YYYY'), 'FL', 'West Palm Beach', '33405' FROM dual
UNION ALL
SELECT  '03 Reindahl Way', 'Jamie', 'Rosebotham', '7168674533', 'jrosebothamb@prlog.org', TO_DATE('05/09/2024', 'MM/DD/YYYY'), 'NY', 'Buffalo', '14263' FROM dual
UNION ALL
SELECT '35 Homewood Road', 'Doro', 'Bolens', '9165623169', 'dbolensc@barnesandnoble.com', TO_DATE('07/09/2024', 'MM/DD/YYYY'), 'CA', 'Sacramento', '94237' FROM dual
UNION ALL
SELECT '471 Nova Circle', 'Keenan', 'Kisar', '9158115536', 'kkisard@auda.org.au', TO_DATE('03/15/2022', 'MM/DD/YYYY'), 'TX', 'El Paso', '88519' FROM dual
UNION ALL
SELECT '99 Scott Circle', 'Starr', 'Blowin', '2021961777', 'sblowine@123-reg.co.uk', TO_DATE('10/12/2023', 'MM/DD/YYYY'), 'DC', 'Washington', '20442' FROM dual;


INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (1, TO_DATE('08/09/2023', 'MM/DD/YYYY'), 250.75);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (2, TO_DATE('07/10/2023', 'MM/DD/YYYY'), 1500.00);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (3, TO_DATE('06/09/2022', 'MM/DD/YYYY'), 325.50);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (4, TO_DATE('02/07/2023', 'MM/DD/YYYY'), 980.25);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (5, TO_DATE('11/11/2023', 'MM/DD/YYYY'), 780.40);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (6, TO_DATE('12/09/2022', 'MM/DD/YYYY'), 450.80);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (7, TO_DATE('01/22/2024', 'MM/DD/YYYY'), 999.99);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (8, TO_DATE('05/05/2024', 'MM/DD/YYYY'), 1230.60);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (9, TO_DATE('03/09/2024', 'MM/DD/YYYY'), 560.45);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (10, TO_DATE('02/09/2024', 'MM/DD/YYYY'), 875.00);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (11, TO_DATE('04/09/2024', 'MM/DD/YYYY'), 1150.25);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (12, TO_DATE('05/09/2024', 'MM/DD/YYYY'), 670.80);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (13, TO_DATE('07/09/2024', 'MM/DD/YYYY'), 890.30);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (14, TO_DATE('03/15/2022', 'MM/DD/YYYY'), 430.00);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (15, TO_DATE('10/12/2023', 'MM/DD/YYYY'), 1299.99);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (14, SYSDATE - 1, 540.75);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (14, SYSDATE - 3, 320.25);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (5, SYSDATE - 10, 450.00);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (5, SYSDATE - 20, 230.60);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (3, SYSDATE - 5, 675.80);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (3, SYSDATE - 13, 980.25);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (2, SYSDATE - 11, 1200.50);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (2, SYSDATE - 14, 875.00);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (9, SYSDATE - 12, 745.65);
INSERT INTO "Order" (CustomerID, OrderDate, Amount) VALUES (9, SYSDATE - 5, 510.30);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (3, 1, 'EE-C7-31-C0-A7-E2', 920.48, 'DISCARDED', 'keypad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (5, 2, '3C-DF-6F-E5-2C-95', 3826.57, 'REFURBISHED', NULL, 2);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (4, 3, '1C-53-16-92-2A-52', 9422.58, 'DISCARDED', 'keypad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (10, 4, '38-03-95-3E-4D-47', 4384.39, 'REFURBISHED', NULL, 5);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (13, 5, '66-DD-63-60-60-4C', 8731.33, 'REFURBISHED', NULL, 14);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (7, 6, '01-23-0F-ED-17-2E', 7011.04, 'DISCARDED', 'volume button not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (13, 7, '68-64-4D-69-C7-CA', 7572.82, 'DISCARDED', 'touch pad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (2, 8, '36-A3-B4-46-B0-78', 1995.20, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (1, 9, 'FF-03-AE-4F-63-AB', 5814.71, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (4, 10, 'E3-DA-19-11-FF-23', 752.42, 'DISCARDED', 'faulty camera', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (2, 11, '93-A1-E6-6F-46-BB', 7040.44, 'REFURBISHED', NULL, 11);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (3, 12, '38-F6-A8-2C-FE-72', 2944.26, 'DISCARDED', 'touch pad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (12, 13, 'DA-30-C4-95-34-D6', 7851.76, 'DISCARDED', 'display broken', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (5, 14, '97-AA-B2-C8-7C-C1', 3509.61, 'DISCARDED', 'faulty camera', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (9, 15, '28-45-1F-BD-A6-51', 5933.39, 'REFURBISHED', NULL, 5);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (7, 16, '6D-6F-F7-CC-65-B6', 1572.40, 'REFURBISHED', NULL, 13);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (7, 17, '85-22-F7-35-CE-77', 533.71, 'DISCARDED', 'touch pad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (2, 18, '2E-E3-08-E1-4A-19', 1176.40, 'REFURBISHED', NULL, 4);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (14, 19, 'BD-B2-22-2F-56-61', 6738.82, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (1, 20, 'E8-72-91-72-E9-EA', 9596.35, 'REFURBISHED', NULL, 2);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (9, 21, '3C-C3-2D-A4-F3-34', 7067.79, 'REFURBISHED', NULL, 15);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (11, 22, '32-9C-9E-A0-9E-96', 6534.96, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (14, 23, 'B0-3C-92-2E-68-DD', 279.35, 'DISCARDED', 'touch pad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (5, 24, '8D-8F-26-71-B3-8E', 532.45, 'DISCARDED', 'volume button not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (2, 25, '60-64-25-3A-7A-68', 5320.47, 'REFURBISHED', NULL, 13);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (14, 1, 'AF-27-72-3D-8A-54', 3834.76, 'DISCARDED', 'touch pad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (13, 2, '4D-32-F9-AE-50-27', 2425.81, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (7, 3, 'D1-19-A6-F5-11-A9', 1935.25, 'DISCARDED', 'keypad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (12, 4, 'F6-23-30-BE-25-58', 7551.43, 'REFURBISHED', NULL, 2);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (8, 5, '4A-9A-B0-72-C5-C8', 5418.28, 'REFURBISHED', NULL, 13);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (1, 6, '97-91-20-48-A5-63', 4870.24, 'DISCARDED', 'faulty speaker', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (14, 7, '0F-8B-BC-82-19-1D', 6887.28, 'DISCARDED', 'keypad not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (2, 8, 'F9-63-73-24-22-11', 5197.64, 'DISCARDED', 'faulty camera', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (6, 9, '7F-D5-A7-94-5F-13', 7609.41, 'DISCARDED', 'faulty camera', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (7, 10, '69-68-F2-C4-5A-E9', 2957.78, 'REFURBISHED', NULL, 9);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (3, 11, 'A5-53-7A-65-47-E2', 3089.74, 'DISCARDED', 'faulty camera', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (4, 12, 'D3-32-55-EC-93-11', 4169.75, 'DISCARDED', 'volume button not working', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (11, 13, '5A-07-72-32-A2-AB', 8199.91, 'DISCARDED', 'display broken', NULL);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (15, 14, '16-B0-9F-0C-DA-C2', 5923.04, 'REFURBISHED', NULL, 4);

INSERT INTO Item (ItemLineID, OrderID, SerialNo, Price, Status, FaultReason, CollectionCenterID)
VALUES (3, 15, '2D-B9-B9-8A-DB-FF', 7336.54, 'DISCARDED', 'keypad not working', NULL);


INSERT INTO Technician (Expertise, Email, MobileNo)
SELECT 'Device Calibration', 'tchown0@1688.com', '7358909588' FROM dual UNION ALL
SELECT 'Hardware Maintenance', 'jocalleran1@whitehouse.gov', '4348239201' FROM dual UNION ALL
SELECT 'Device Calibration', 'hflint2@theatlantic.com', '4935016395' FROM dual UNION ALL
SELECT 'Device Calibration', 'crothwell3@comcast.net', '5944752776' FROM dual UNION ALL
SELECT 'Device Calibration', 'svanyashin4@skyrock.com', '7908773534' FROM dual UNION ALL
SELECT 'Hardware Maintenance', 'btowsey5@youku.com', '7678941001' FROM dual UNION ALL
SELECT 'Electronics Repair', 'eogaven6@pinterest.com', '6153058343' FROM dual UNION ALL
SELECT 'Hardware Maintenance', 'tcharlick7@cpanel.net', '6113329662' FROM dual UNION ALL
SELECT 'Device Calibration', 'ctomsu8@meetup.com', '2573894889' FROM dual UNION ALL
SELECT 'Device Calibration', 'ajantel9@mapy.cz', '3856471078' FROM dual;

INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES (1, 1, TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 2, 2, TO_DATE('2024-02-15', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 3, 3, TO_DATE('2024-03-20', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 4, 4, TO_DATE('2024-04-25', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 5, 5, TO_DATE('2024-05-30', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 6, 6, TO_DATE('2024-06-10', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 7, 7, TO_DATE('2024-07-15', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 8, 8, TO_DATE('2024-08-10', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 9, 9, TO_DATE('2024-07-08', 'YYYY-MM-DD'));
INSERT INTO RefurbishmentService (ItemID, TechnicianID, RefurbDate) VALUES ( 10, 10, TO_DATE('2024-06-30', 'YYYY-MM-DD'));


INSERT INTO Feedback (OrderID, Message)
SELECT  1, 'Good job' FROM dual UNION ALL
SELECT  2, 'Excellent service' FROM dual UNION ALL
SELECT  3, 'Good job' FROM dual UNION ALL
SELECT  4, 'Good job' FROM dual UNION ALL
SELECT  5, 'Can be better' FROM dual UNION ALL
SELECT  6, 'Good job' FROM dual UNION ALL
SELECT  7, 'Can be better' FROM dual UNION ALL
SELECT  8, 'Good job' FROM dual UNION ALL
SELECT  9,'Excellent service' FROM dual UNION ALL
SELECT  10,  'Excellent service' FROM dual;

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------Queries-----------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------

--Query 1: MIN and MAX
--Question 1: Find the earliest and latest order dates for each customer.
SELECT CustomerID, MIN(OrderDate) AS EarliestOrder, MAX(OrderDate) AS LatestOrder
FROM "Order"
GROUP BY CustomerID;

-- same as above but with customer info
-- What are the earliest and latest order dates for each customer, along with their corresponding customer information?
SELECT c.CustomerID, c.FirstName, c.LastName, MIN(o.OrderDate) AS EarliestOrder, MAX(o.OrderDate) AS LatestOrder
FROM Customer c
         JOIN "Order" o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

--Query 2: COUNT and DISTINCT
--Question: How many unique items (based on ItemLineID) have been ordered?

SELECT COUNT(DISTINCT ItemLineID) AS UniqueItems
FROM Item;

--Query 3: Basic Aggregation and GROUP BY
--Question: What is the average price of items for each category?

SELECT Category, AVG(Price) AS AveragePrice
FROM ItemLine i
         JOIN Item it ON i.ItemLineID = it.ItemLineID
GROUP BY Category;

--Query 4: Subquery and Comparison Operator
--Question: Find customers who have placed orders with a total amount greater than the average order amount.

SELECT CustomerID, FirstName, LastName
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM "Order"
    GROUP BY CustomerID
    HAVING SUM(Amount) > (SELECT AVG(Amount) FROM "Order")
);

--Query 5: Inner Join and Aliasing
--Question: What is the total amount for each customer, along with their first and last name?

SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.Amount) AS TotalAmount
FROM Customer c
         INNER JOIN "Order" o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY c.CustomerID;

--Query 6: Left Outer Join
--Question: List all Collection Centers with the number of Items present in the center, including centers with no items

SELECT  c.Centername, count(i.CollectioncenterID) AS ITEMSPRESENT
FROM Collectioncenter c
        LEFT OUTER JOIN ITEM i on c.CollectioncenterID = i.CollectioncenterID
GROUP BY i.CollectioncenterID, c.Centername order by ITEMSPRESENT desc;


--Query 7: HAVING and ORDER BY
--Question: Find collection centers with an average item price greater than $4000, ordered by average price descending.

SELECT cc.CenterName, ROUND(AVG(i.Price),2) AS AveragePrice
FROM CollectionCenter cc
         JOIN Item i ON cc.CollectionCenterID = i.CollectionCenterID
GROUP BY cc.CenterName
HAVING AVG(i.Price) > 4000
ORDER BY AveragePrice DESC;