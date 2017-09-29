##Customer Employee Employer Membership User Creator Company
official representative

##users
id
first_name
last_name
user_name
address
city
state
country
postal_code
phone
fax
email
birth_date

##memberships
id
user_id
company_id
role_id
type **Customer/Employee**

title
parent_id *report_to*
hired_at
salary

support_by_id *employee_id*
credit_rating

##companies
id
name
city



