-- Transparent about our frontend and backend costs
-- Optional donation/subscription model with users and businesses
-- Portion of it goes away to other causes 

-- Certified B Corp? B lab, verified social/environmental performance, public transparency, business as a force for good

-- Auth0 Roles
-- Users (base shared by all types of user roles)

-- Businesses
--  Scopes:
--    businesses:read
--    businesses:create
--    businesses:update
--    businesses:delete

-- Moderators
--  Scopes:
--    businesses:read
--    moderators:read
--    moderators:update
--    moderators:create
--    moderators:delete

-- Admins
--  Scopes:
--    admins:read
--    admins:create
--    admins:update
--    admins:delete

-- User signup/login/other auth things handled through Auth0, but we need our own 
-- forthright users table to distinguish between normal users and businesses i.e. local businesses, communities, stores
-- These forthrightusers will then serve as the main reference to the other tables
-- GET /users => list all users for moderators/admin
-- GET /users/:userId => get user details for a moderator/admin or from the user itself
-- POST /users => create a user with a certain type, tied to Auth0, will also generate a row in the corresponding type table
-- DELETE /users/:userId => delete user from admin perspective or from the user itself
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  type VARCHAR(20) NOT NULL, -- normal, business, moderator, admin
  auth_id VARCHAR(255) NOT NULL, -- Reference auth0 user id
  created_at DEFAULT TIMESTAMP NOW()
);

-- Businesses
-- GET /businesses => list all businesses for everyone
-- GET /businesses/:businessId => get business details i.e. business name, verified status, etc.
-- PUT /businesses/:businessId => update business details i.e. name, diversity statement, etc. only if it's the business itself
CREATE TABLE businesses (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  business_name VARCHAR(255) NOT NULL, 
  application_id INTEGER NOT NULL, -- Application status to become a verified business: "pending", "reviewing", "verified", "denied"
  is_visible BOOLEAN NOT NULL,
  business_size_classification_id INTEGER NOT NULL,
  diversity_statement VARCHAR(255), 
  environment_statement VARCHAR(255),
  about_us_statement VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (application_id) REFERENCES business_applications(id),
  FOREIGN KEY (business_size_classification_id) REFERENCES business_size_classifications(id)
);

-- Business Applications
-- As a business, I would like to prove that I am legit and part of this business
-- How do we prove this on our end as a moderator/admin?
CREATE TABLE business_applications (
  id SERIAL PRIMARY KEY,
  status VARCHAR(20) NOT NULL, -- "pending", "reviewing", "verified", "denied"
  reviewer_id INTEGER,
  reviewee_id INTEGER NOT NULL,
  FOREIGN KEY (reviewer_id) REFERENCES users(id),
  FOREIGN KEY (reviewee_id)
);

-- Business Locations
-- As a business, I would like to report my multiple locations around the US
CREATE TABLE business_locations (
  business_id INTEGER NOT NULL,
  state_id INTEGER NOT NULL,
  city_id INTEGER NOT NULL,
  address VARCHAR(255) NOT NULL,
  zip_code VARCHAR(10) NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  FOREIGN KEY (state_id) REFERENCES us_states(id),
  FOREIGN KEY (city_id) REFERENCES us_cities(id),
  PRIMARY KEY (business_id, state_id, city_id)
);

-- Business Size
-- Small 1-49, Mid 50-999, Large 1000+
CREATE TABLE business_size_classifications (
  id SERIAL PRIMARY KEY,
  size_name VARCHAR(255) NOT NULL, -- i.e. small, mid, large
  min_employees INTEGER NOT NULL, -- i.e. 1 for small, 50 for mid, 1000 for large
  max_employees INTEGER, -- i.e. 49 for small, 999 for mid, null for large
  created_at DEFAULT TIMESTAMP NOW(),
);

INSERT INTO business_size_classifications (size_name, min_employees, max_employees) VALUES 
('small', 1, 49),
('mid', 50, 999),
('large', 1000, null);

CREATE TABLE business_sizes (
  business_id INTEGER NOT NULL,
  business_size_classification_id INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  FOREIGN KEY (business_size_classification_id) REFERENCES business_size_classifications(id),
  PRIMARY KEY (business_id, business_size_classification_id)
);

-- Business News
-- As a business, I would like to update my followers and new users with what we are currently up to
-- As a user, I would like to see what is currently going on with a business
-- GET /businesses/:businessId/news - get list of all the latest news for a business id
-- GET /businesses/:businessId/news/:newsId - get details of specific news status
-- POST /businesses/:businessId/news - create a news status update for the business
-- PUT /businesses/:businessId/news/:newsId - update details of a specific news status
-- DELETE /businesses/:businessId/news/:newsId - delete specific news status
CREATE TABLE business_news (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  title VARCHAR(255) NOT NULL,
  content VARCHAR(255) NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Anonymous diversity metrics across companies for data analysis
-- As a user, I would like to see general stats about how businesses in general are doing in relation to diversity
-- As a business, I would like to anonymously see how my business is doing compared to others and where we can improve
-- Base /diversity_metrics endpoint to filter across all the diversity metrics tables/endpoints
-- GET /businesses/:businessId/diversity_metrics -> retrieves all the diversity metrics for a certain business id

-- Paid time off for maternal and paternity leave
-- Pay equality for men and women i.e. average pay for men and women
-- Healthcare access? birth control, other issues
-- * Average pay gap percentage between men and women
-- * Employ veterans? Percentage of employees that are veterans
-- * Employ disabled workers? Percentage of employees that are disabled
-- * Percentage of gender breakdown
-- * Support lgbtiq+
-- * Race/ethnicities percentage breakdown
-- * Management race/ethnicities percentage breakdown

-- Veterans vs Not Veterans
-- As a user, I would like to see how businesses are doing with respect to hiring veterans
-- As a business, I would like to self-report how we're doing with hiring veterans
-- GET /businesses/:businessId/diversity_metrics/veterans - get diversity veterans metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/veterans - create diversity veterans metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/veterans/:metricId - update diversity veterans metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/veterans/:metricId - delete diversity veterans metrics for a certain business id
-- Do you currently employ veterans? Yes/no
-- How many veterans 
CREATE TABLE diversity_veterans_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  veterans_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Disabled vs. Not Disabled
-- As a user, I would like to see how businesses are doing with hiring disabled people
-- As a business, I would like to self-report how we're doing with hiring disabled people
-- GET /businesses/:businessId/diversity_metrics/disabled_workers - get diversity marital families metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/disabled_workers - create diversity marital families metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/disabled_workers/:metricId - update diversity marital families metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/disabled_workers/:metricId - delete diversity marital families metrics for a certain business id
-- 
CREATE TABLE diversity_disabled_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  disabled_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Salary Breakdown between men and women in similar roles
-- Individual contributor/non-management, management, elt
-- As a user, I would like to see how men vs. women stack up in terms of salary in similar roles in businesses
-- As a business, I would like to self-report how our business is doing in terms of giving equal pay in similar roles across genders
-- GET /businesses/:businessId/diversity_metrics/gender_salaries - get diversity gender salaries metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/gender_salaries - create diversity gender salaries metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/gender_salaries/:metricId - update diversity gender salaries metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/gender_salaries/:metricId - delete diversity gender salaries metrics for a certain business id
CREATE TABLE diversity_gender_salary_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  average_pay_gap_percentage INTEGER NOT NULL;
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to gender 
-- Race/Ethnicity Survey Questions: https://ir.aa.ufl.edu/surveys/race-and-ethnicity-survey/
-- As a business, I would like to self-report and be transparent about our gender breakdowns
-- GET /businesses/:businessId/diversity_metrics/genders - get diversity gender metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/genders - create diversity gender metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/genders/:metricId - update diversity gender metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/genders/:metricId - delete diversity gender metrics for a certain business id
CREATE TABLE diversity_gender_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_percentage INTEGER NOT NULL,
  male_percentage INTEGER NOT NULL,
  nonbinary_percentage INTEGER NOT NULL,
  transgender_percentage INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id),
);

-- As a user, I would like to see how businesses are doing with respect to race and ethnicity
-- As a business, I would like to self-report how we're doing with respect to race and ethnicity
-- GET /businesses/:businessId/diversity_metrics/race_ethnicities - get diversity race ethnicity metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/race_ethnicities - create diversity race ethnicity metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/race_ethnicities/:metricId - update diversity race ethnicity metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/race_ethnicities/:metricId - delete diversity race ethnicity metrics for a certain business id
CREATE TABLE diversity_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  hispanic_latinx_spanish_percentage INTEGER NOT NULL,
  american_indian_alaskan_percentage INTEGER NOT NULL,
  asian_percentage INTEGER NOT NULL,
  hawaii_pacific_islander_percentage INTEGER NOT NULL,
  black_african_american_percentage INTEGER NOT NULL,
  white_percentage INTEGER NOT NULL,
  multiple_races_percentage INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to gender in management
-- As a business, I would like to self-report our gender breakdown in management
-- GET /businesses/:businessId/diversity_metrics/management_genders - get diversity management gender metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/management_genders - create diversity management gender metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/management_genders/:metricId - update diversity management gender metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/management_genders/:metricId - delete diversity management gender metrics for a certain business id
CREATE TABLE diversity_management_gender_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  male_percentage INTEGER NOT NULL,
  female_percentage INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to race/ethnicity in management roles
-- As a business, I would like to self-report how we're doing with respect to race and ethnicity in management
-- GET /businesses/:businessId/diversity_metrics/management_race_ethnicities - get diversity management race ethnicity metrics for a certain business id
-- POST /businesses/:businessId/diversity_metrics/management_race_ethnicities - create diversity management race ethnicity metrics for a certain business id
-- PUT /businesses/:businessId/diversity_metrics/management_race_ethnicities/:metricId - update diversity management race ethnicity metrics for a certain business id
-- DELETE /businesses/:businessId/diversity_metrics/management_race_ethnicities/:metricId - delete diversity management race ethnicity metrics for a certain business id
CREATE TABLE diversity_management_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  hispanic_latinx_spanish_percentage INTEGER NOT NULL,
  american_indian_alaskan_percentage INTEGER NOT NULL,
  asian_percentage INTEGER NOT NULL,
  hawaii_pacific_islander_percentage INTEGER NOT NULL,
  black_african_american_percentage INTEGER NOT NULL,
  white_percentage INTEGER NOT NULL,
  multiple_races_percentage INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Industries a business/user is participating in
-- Information/Technology, Healthcare, Education, Finance, Accommodation and Food Services, etc.
-- I want to find businesses that are in a certain industry or match up with the industry I am in
-- GET /industry_sectors - lists out all the industries businesses have declared to be part of
CREATE TABLE industries (
  id SERIAL PRIMARY KEY,
  industry_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- Businesses report what industry sectors they participate in
-- GET /businesses/:businessId/industries
-- POST /businesses/:businessId/industries
-- PUT /businesses/:businessId/industries
CREATE TABLE business_industries (
  industry_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  FOREIGN KEY (industry_id) REFERENCES industries(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (industry_id, business_id)
);

-- Users report what industries they participate in 
-- GET /users/:userId/industries
-- POST /users/:userId/industries
-- PUT /users/:userId/industries
CREATE TABLE user_industries (
  industry_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (industry_id) REFERENCES industries(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (industry_id, business_id)
);

-- Causes supported by a business 
-- i.e. Black Lives Matter, Homeless Veterans
-- I want to find businesses that support these causes or that match up with the causes I want to support and focus on
-- GET /causes - list out all the causes supported by businesses
CREATE TABLE causes (
  id SERIAL PRIMARY KEY,
  cause_name VARCHAR(255) UNIQUE NOT NULL,
  description VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- As a user, I would like to maintain the causes that I am passionate about and support to match up against other businesses focusing on the same things
-- GET /users/:userId/causes
-- POST /users/:userId/causes 
-- PUT /users/:userId/causes
CREATE TABLE user_causes (
  cause_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (cause_id, user_id)
);

-- As a business, we would like to highlight the causes we are currently supporting and are passionate about so other users can match up with us
-- GET /businesses/:businessId/causes
-- POST /businesses/:businessId/causes 
-- PUT /businesses/:businessId/causes
CREATE TABLE business_causes (
  cause_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (cause_id, user_id)
);

-- Businesses/Users can endorse certain initiatives, organizations, political candidates, and other entities
-- GET /endorsements - list out all the things businesses are endorsing
CREATE TABLE endorsements (
  id SERIAL PRIMARY KEY,
  endorsement_title VARCHAR(255) UNIQUE NOT NULL,
  description VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- GET /users/:userId/endorsements
-- POST /users/:userId/endorsements 
-- PUT /users/:userId/endorsements
CREATE TABLE user_endorsements (
  endorsement_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (endorsement_id) REFERENCES endorsements(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (endorsement_id, user_id)
);

-- GET /businesses/:businessId/endorsements
-- POST /businesses/:businessId/endorsements 
-- PUT /businesses/:businessId/endorsements
CREATE TABLE business_endorsements (
  endorsement_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  FOREIGN KEY (endorsement_id) REFERENCES endorsements(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (endorsement_id, business_id)
);

-- Similar to hashtags, a business can create and assign tags to associate with themselves
-- i.e. #blacklivesmatter #forthrightbusiness #asianamerican
-- I want to find all the businesses with a certain tag
-- GET /tags - list out all the things businesses are tagging themselves with
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- GET /businesses/:businessId/tags
-- POST /businesses/:businessId/tags 
-- PUT /businesses/:businessId/tags
CREATE TABLE business_tags (
  business_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id),
  -- Prevents multiple instances of the same tag on the same business
  PRIMARY KEY (business_id, tag_id)
);

-- Similar to likes, a user of any kind i.e. business, user, moderator, can say I support/vouch for this business!
-- It would be cool to highlight how many users/businesses/moderators support other businesses
-- I want to show my support/vouch for a business
-- GET /businesses/:businessId/vouches -> for a certain business id, get the number of vouches/vouch list
-- GET /users/:userId/vouches -> for a certain user id, get all the businesses the user vouches for
-- POST /users/:userId/vouches -> for a certain user id, vouch for a business by passing in business_id in request body
-- DELETE /users/:userId/vouches/businesses/:businessId -> for a certain user id, delete the vouch the user has for a business id
CREATE TABLE vouches (
  user_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (user_id, business_id)
);

-- Moderators aka volunteers/checks and balances in the communities
-- GET /moderators - list out all prospective/current moderators for an admin
-- GET /moderators/:moderatorId - 
CREATE TABLE moderators (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  application_id INTEGER NOT NULL, -- Application status to become a moderator - "pending", "reviewing", "verified", "denied"
  -- Moderator specific profile fields here
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (application_id) REFERENCES moderator_applications(id),
);

-- Moderator applications approved by other moderators and double checked by admin moderators
CREATE TABLE moderator_applications (
  id SERIAL PRIMARY KEY,
  status VARCHAR(20) NOT NULL, -- "pending", "reviewing", "verified", "denied"
  reviewer_id INTEGER NOT NULL,
  reviewee_id INTEGER NOT NULL,
  FOREIGN KEY (reviewer_id) REFERENCES users(id),
  FOREIGN KEY (reviewee_id)
);

-- In order to hold moderators accountable as well with what they're doing, the admin should be able
-- to see all the business/moderator/user related applications/crud they have done for auditing
CREATE TABLE moderator_logs (
  id SERIAL PRIMARY KEY,
  moderator_id INTEGER NOT NULL,

);
