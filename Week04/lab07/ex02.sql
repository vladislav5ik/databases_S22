--3NF
CREATE TABLE IF NOT EXISTS Schools (
  schoolId serial NOT NULL PRIMARY KEY,
  schoolName varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Rooms (
  roomId serial NOT NULL PRIMARY KEY,
  roomName varchar(100) NOT NULL,
  schoolId integer NOT NULL REFERENCES Schools(schoolId)
);

CREATE TABLE IF NOT EXISTS Publishers (
  publisherId serial NOT NULL PRIMARY KEY,
  publisherName varchar(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS Books (
  bookId serial NOT NULL PRIMARY KEY,
  bookName varchar(100) NOT NULL,
  publisherId integer NOT NULL REFERENCES Publishers(publisherId)
);

CREATE TABLE IF NOT EXISTS Teachers (
  teacherId serial NOT NULL PRIMARY KEY,
  teacherName varchar(100) NOT NULL,
  schoolId integer NOT NULL REFERENCES Schools(schoolId)
);

CREATE TABLE IF NOT EXISTS Courses (
  courseId serial NOT NULL PRIMARY KEY,
  courseName varchar(100) NOT NULL,
  grade integer NOT NULL
);

CREATE TABLE IF NOT EXISTS SchoolCourses (
  id serial NOT NULL PRIMARY KEY,
  courseId integer NOT NULL REFERENCES Courses(courseId),
  schoolId integer NOT NULL REFERENCES Schools(schoolId)
);

CREATE TABLE IF NOT EXISTS TeacherCourses (
  id serial NOT NULL PRIMARY KEY,
  teacherId integer NOT NULL REFERENCES Teachers(teacherId),
  courseId integer NOT NULL REFERENCES Courses(courseId)
);

CREATE TABLE IF NOT EXISTS Loan (
  loanId serial NOT NULL PRIMARY KEY,
  bookId integer NOT NULL REFERENCES Books(bookId),
  teacherCoursesId integer NOT NULL REFERENCES TeacherCourses(id),
  loadDate date NOT NULL
);

--Obtain for each of the schools, the number of books that have been loaned to each publishers.
select t.schoolid, b.publisherid, count(*) as "books loaned"
from loan l
inner join books b on b.bookid = l.bookid
inner join teachercourses tc on tc.id = l.teachercoursesid
inner join teachers t on t.teacherid = tc.teacherid
group by t.schoolid, b.publisherid;

--For each school, find the book that has been on loan the longest and the teacher in charge of it.
select tt.school, l2.bookid, t.teacherid, tt.minLoanDate
from loan l2
inner join (select t.schoolid as school, MIN(l.loaddate) as minLoanDate
			  from teachers t
			  inner join teachercourses tc on tc.teacherid = t.teacherid
			  inner join loan l on l.teachercoursesid = tc.id
			  group by t.schoolid) tt on l2.loaddate = tt.minLoanDate
inner join teachercourses tc on tc.id = l2.teachercoursesid
inner join teachers t on tc.teacherid =t.teacherid
where t.schoolid = tt.school;