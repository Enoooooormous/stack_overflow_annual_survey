# stack_overflow_annual_survey

Data analysis project sent by a company as part of the hiring process (data science position in Sao Paulo BR)

Challenge:
Stack Overflow is a widely known platform in the technology community and allows users to ask questions and also respond to them. In addition, they can, through registration and active participation, vote on more or less useful questions and answers.

You've probably already accessed it to remedy any code doubts you had.
Every year Stack Overflow does a search with its developer community on a variety of topics, ranging from their technological preferences to professional issues. And we're super curious to know what the developers are talking about. We want to know what technologies they use, how they communicate, how much they earn on average, where they live and a few things.

Your challenge is to help us answer these questions using the search results applied in January 2018. We divide the challenge into two main parts:
	
	1. Populate a database from raw search data (we'll give you the database structure)
	2. Perform queries on the database to satiate our curiosity
  

Assembling the database

We will give you a text file (CSV format) containing a portion of the search results performed by Stack Overflow and another text file (CSV format) containing the description of the answer columns present in the first file (i.e. it tells you which Questions were asked and that generated the answers).

You will use a programming language to read this file, process it according to the business rules outlined below, and then enter that data into a database of your choice (see the Stack of technologies section).

We'll give you the database relationship entity model, but it will be up to you to assemble the SQL code that implements that model in the bank.


Data source

You will find in the attachment of this project two files, the first of which contains a sample of only 10000 lines of answers to the search, and the second, an explanation of the meaning of the response columns.

The first file is named Base_de_respostas_10k_amostra. csv  and the second,  base_de_conhecimento. csv. If you want to see the full results of the search, simply access this   kagglelink.


Database structure

The image below contains the structure of the database that you will implement. You can also access the larger-sized image in the MER-summer-job.png file, which is attached to the project.


Business rules  

•	Empty salary or with "NA" value should be converted to zero (0.0).
•	Salary should always be calculated in reais and monthly. For this calculation you will use the column ConvertedSalary, which contains the yearly salary. Consider  that 1  dollar  is equivalent to R $3,81.
•	The respondent's name must follow the responder rule [number]  . (e.g.: respondente_1, respondente_2,  respondente_3). The criterion for generating that number is all yours.
•	Each row in the Linguagem_programacao table must contain a single programming language.
•	Each row in the ferramenta_comunic table should contain only one communication tool.

It is important to note that in some response fields there are multiple results, such as in the Languageworkedwithcolumn, which contains several programming languages in a row. In these cases, you must break the string at the points that there are semicolons (";").


Questions to  be  answered

With your bank structure ready, you can perform SQL queries on the bank you created and kill our curiosity. The  list  below  contains  everything  we  need to know:

1.	How many respondents from each country?
2.	How many users who live in "United States" like Windows?
3.	What is the average salary of users who live in Israel and like Linux?
4.	What is the average and standard deviation of the salary of users who use Slack for each available company size? (Hint: The result should be a table similar to the one shown below)
5.	What is the difference between the average salary of Brazilian respondents who think that creating code is a hobby and the average salary of all Brazilian respondents grouped by each operating system they use? 
6.	What are the top 3 technologies most used by developers?
7.	What are the top 5 countries in question of salary?
8.	The table below contains the monthly minimum wages of five countries present in the data sample. Based on these values, we would like to know how many users earn more than 5 minimum wages in each of these countries.





