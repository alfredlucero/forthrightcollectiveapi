-- Transparent about our frontend and backend costs
-- Optional donation/subscription model with users and businesses
-- Portion of it goes away to other causes 

-- Certified B Corp? B lab, verified social/environmental performance, public transparency, business as a force for good

-- User signup/login/other auth things handled through Auth0, but we need our own 
-- forthright users table to distinguish between normal users and businesses i.e. local businesses, communities, stores
-- These forthrightusers will then serve as the main reference to the other tables
-- /users
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL, -- Could be username/name of the user or business
  type VARCHAR(255) NOT NULL, -- Normal or business
  auth_id VARCHAR(255) NOT NULL, -- Reference auth0 user id
  created_at DEFAULT TIMESTAMP NOW()
);

-- Businesses
-- /businesses
CREATE TABLE businesses (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  verified_status BOOLEAN, -- Application status to become a verified business
  diversity_statement VARCHAR(255) NOT NULL, 
  environment_statement VARCHAR(255) NOT NULL,
  about_us_statement VARCHAR(255) NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
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
-- /businesses/news
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

-- Age Groups (16-19, 20-24, 25-34, 35-44, 45-54, 55-64, 65+)?
-- https://www.bls.gov/cps/cpsaat11b.htm
-- As a user, I would like to see how businesses hire based on age
-- As a business, I would like to self-report how we're doing with respect to age
-- /diversity_metrics/ages/*
CREATE TABLE diversity_age_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  sixteen_to_nineteen_count INTEGER NOT NULL,
  twenty_to_twentyfour_count INTEGER NOT NULL,
  twentyfive_to_thirtyfour_count INTEGER NOT NULL,
  thirtyfive_to_fortyfour_count INTEGER NOT NULL,
  fortyfive_to_fiftyfour_count INTEGER NOT NULL,
  fiftyfive_to_sixtyfour_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Education (less than high school diploma, high school only, some college or associate degree, bachelor's degree and higher)
-- https://www.bls.gov/webapps/legacy/cpsatab4.htm
-- As a user, I would like to see how businesses hire based on education
-- As a business, I would like to self-report our employees' educational background
-- /diversity_metrics/educational_backgrounds/*
CREATE TABLE diversity_education_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  less_than_high_school_count INTEGER NOT NULL,
  high_school_only_count INTEGER NOT NULL,
  some_college_count INTEGER NOT NULL,
  associate_degree_count INTEGER NOT NULL,
  bachelor_degree_count INTEGER NOT NULL,
  masters_degree_and_above_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Marital/Families Status (Single without kids, Single with Kids, Married without kids, Married with Kids)
-- As a user, I would like to see how businesses hire based on marital/families status
-- As a business, I would like to self-report how we're doing with respect to hiring people with different marital/families statuses
-- /diversity_metrics/marital_families/*
CREATE TABLE diversity_marital_families_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  single_without_kids_count INTEGER NOT NULL,
  single_with_kids_count INTEGER NOT NULL,
  married_without_kids_count INTEGER NOT NULL,
  married_with_kids_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Veterans vs Not Veterans
-- As a user, I would like to see how businesses are doing with respect to hiring veterans
-- As a business, I would like to self-report how we're doing with hiring veterans
-- /diversity_metrics/veterans/*
CREATE TABLE diversity_veterans_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  veterans_count INTEGER NOT NULL,
  nonveterans_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Disabled vs. Not Disabled
-- As a user, I would like to see how businesses are doing with hiring disabled people
-- As a business, I would like to self-report how we're doing with hiring disabled people
-- /diversity_metrics/disabled_workers/*
CREATE TABLE diversity_disabled_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  disabled_count INTEGER NOT NULL,
  nondisabled_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Foreign born vs. native born
-- https://www.bls.gov/webapps/legacy/cpsatab7.htm
-- As a user, I would like to see how businesses are hiring foreign vs. native born workers
-- As a business, I would like to self-report how we're doing with hiring foreign vs. native born workers
-- CRUD for /diversity_metrics/foreign_workers
CREATE TABLE diversity_foreign_worker_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  foreign_worker_count INTEGER NOT NULL,
  native_born_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Salary Breakdown between men and women in similar roles
-- Individual contributor/non-management, management, elt
-- As a user, I would like to see how men vs. women stack up in terms of salary in similar roles in businesses
-- As a business, I would like to self-report how our business is doing in terms of giving equal pay in similar roles across genders
-- /diversity_metrics/gender_salaries
CREATE TABLE diversity_gender_salary_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  ic_junior_male_avg_salary INTEGER NOT NULL,
  ic_junior_female_avg_salary INTEGER NOT NULL,
  ic_mid_male_avg_salary INTEGER NOT NULL,
  ic_mid_female_avg_salary INTEGER NOT NULL,
  ic_senior_male_avg_salary INTEGER NOT NULL,
  ic_senior_female_avg_salary INTEGER NOT NULL,
  mgr_male_avg_salary INTEGER NOT NULL,
  mgr_female_avg_salary INTEGER NOT NULL,
  elt_male_avg_salary INTEGER NOT NULL,
  elt_female_avg_salary INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to gender 
-- Race/Ethnicity Survey Questions: https://ir.aa.ufl.edu/surveys/race-and-ethnicity-survey/
-- As a business, I would like to self-report and be transparent about our gender breakdowns
-- /diversity_metrics/genders
CREATE TABLE diversity_gender_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id),
);

-- As a user, I would like to see how businesses are doing with respect to sexual orientation
-- Gender/Sexual Orientiation Survey Questions: https://www.hrc.org/resources/collecting-transgender-inclusive-gender-data-in-workplace-and-other-surveys
-- As a business, I would like to self-report and be transparent about our gender breakdowns
-- /diversity_metrics/sexual_orientations
CREATE TABLE diversity_sexual_orientation_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  heterosexual_count INTEGER NOT NULL,
  gay_count INTEGER NOT NULL,
  bisexual_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to race and ethnicity
-- As a business, I would like to self-report how we're doing with respect to race and ethnicity
-- /diversity_metrics/race_ethnicities
CREATE TABLE diversity_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  hispanic_latinx_spanish_count INTEGER NOT NULL,
  american_indian_alaskan_count INTEGER NOT NULL,
  asian_count INTEGER NOT NULL,
  hawaii_pacific_islander_count INTEGER NOT NULL,
  black_african_american_count INTEGER NOT NULL,
  white_count INTEGER NOT NULL,
  multiple_races_count INTEGER NOT NULL,
  other_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to gender
-- As a business, I would like to self-report about how we're doing with respect to gender
-- /diversity_metrics/elt_genders
CREATE TABLE diversity_elt_gender_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses' elt is doing with respect to race and ethnicity
-- As a business, I would like to self-report our race and ethnicity in the elt
-- /diversity_metrics/elt_race_ethnicities
CREATE TABLE diversity_elt_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  hispanic_latinx_spanish_count INTEGER NOT NULL,
  american_indian_alaskan_count INTEGER NOT NULL,
  asian_count INTEGER NOT NULL,
  hawaii_pacific_islander_count INTEGER NOT NULL,
  black_african_american_count INTEGER NOT NULL,
  white_count INTEGER NOT NULL,
  multiple_races_count INTEGER NOT NULL,
  other_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to gender in management
-- As a business, I would like to self-report our gender breakdown in management
-- /diversity_metrics/management_genders
CREATE TABLE diversity_management_gender_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- As a user, I would like to see how businesses are doing with respect to race/ethnicity in management roles
-- As a business, I would like to self-report how we're doing with respect to race and ethnicity in management
-- /diversity_metrics/management_race_ethnicities
CREATE TABLE diversity_management_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
  business_id INTEGER NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  hispanic_latinx_spanish_count INTEGER NOT NULL,
  american_indian_alaskan_count INTEGER NOT NULL,
  asian_count INTEGER NOT NULL,
  hawaii_pacific_islander_count INTEGER NOT NULL,
  black_african_american_count INTEGER NOT NULL,
  white_count INTEGER NOT NULL,
  multiple_races_count INTEGER NOT NULL,
  other_count INTEGER NOT NULL,
  FOREIGN KEY (business_id) REFERENCES businesses(id)
);

-- Industries a business/user is participating in
-- Tech, Medical, Education, Finance, Entertainment, etc.
-- I want to find businesses that are in a certain industry or match up with the industry I am in
CREATE TABLE industries (
  id SERIAL PRIMARY KEY,
  industry_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- Businesses report what industries they participate in
-- /businesses/industries
CREATE TABLE business_industries (
  industry_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  FOREIGN KEY (industry_id) REFERENCES industries(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (industry_id, business_id)
);

-- Users report what industries they participate in 
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
CREATE TABLE causes (
  id SERIAL PRIMARY KEY,
  cause_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- As a user, I would like to maintain the causes that I am passionate about and support to match up against other businesses focusing on the same things
CREATE TABLE user_causes (
  cause_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (cause_id, user_id)
);

-- As a business, we would like to highlight the causes we are currently supporting and are passionate about so other users can match up with us
CREATE TABLE business_causes (
  cause_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (cause_id, user_id)
);

-- Businesses/Users can endorse certain initiatives, organizations, political candidates, and other entities
CREATE TABLE endorsements (
  id SERIAL PRIMARY KEY,
  endorsement_title VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_endorsements (
  endorsement_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (endorsement_id) REFERENCES endorsements(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (endorsement_id, user_id)
);

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
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

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
-- /vouches/*
CREATE TABLE vouches (
  user_id INTEGER NOT NULL,
  business_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (business_id) REFERENCES businesses(id),
  PRIMARY KEY (user_id, business_id)
);

-- Moderators aka volunteers/checks and balances in the communities
CREATE TABLE moderators (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  verified_status BOOLEAN, -- Application status to become a moderator
  -- Moderator specific profile fields here
  FOREIGN KEY (user_id) REFERENCES users(id)
);
