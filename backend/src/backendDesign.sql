-- User signup/login/other auth things handled through Auth0, but we need our own 
-- forthright users table to distinguish between normal users and collectives i.e. local businesses, communities, stores
-- These forthrightusers will then serve as the main reference to the other tables
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL, -- Could be username/name of the user or collective
  type VARCHAR(255) NOT NULL, -- Normal or collective
  auth_id VARCHAR(255) NOT NULL, -- Reference auth0 user id
  created_at DEFAULT TIMESTAMP NOW()
);

-- Collectives aka local businesses/communities/stores
CREATE TABLE collectives (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  verified_status BOOLEAN -- Application status to become a verified collective
  -- Collective specific profile fields here
  diversity_statement VARCHAR(255) NOT NULL,
  -- Address/location related things
  -- Background/About Us information
  -- Contact information
  -- Hooking up with Social Media i.e. Instagram, Facebook, Twitter
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Collective News
-- As a collective, I would like to update my followers and new users with what we are currently up to
-- As a user, I would like to see what is currently going on with a collective
CREATE TABLE collective_news (
  id SERIAL PRIMARY KEY,
  collective_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  -- url?
  FOREIGN KEY (collective_id) REFERENCES collectives(id)
);

-- Anonymous diversity metrics across companies for data analysis
-- As a user, I would like to see general stats about how collectives in general are doing in relation to diversity
-- As a collective, I would like to anonymously see how my collective is doing compared to others and where we can improve

-- Age Groups (16-19, 20-24, 25-34, 35-44, 45-54, 55-64, 65+)?
-- https://www.bls.gov/cps/cpsaat11b.htm
CREATE TABLE diversity_age_metrics (
  id SERIAL PRIMARY KEY,
  sixteen_to_nineteen_count INTEGER NOT NULL,
  twenty_to_twentyfour_count INTEGER NOT NULL,
  twentyfive_to_thirtyfour_count INTEGER NOT NULL,
  thirtyfive_to_fortyfour_count INTEGER NOT NULL,
  fortyfive_to_fiftyfour_count INTEGER NOT NULL,
  fiftyfive_to_sixtyfour_count INTEGER NOT NULL
);

CREATE TABLE collective_diversity_age_metrics (

);

-- Education (less than high school diploma, high school only, some college or associate degree, bachelor's degree and higher)
-- https://www.bls.gov/webapps/legacy/cpsatab4.htm
CREATE TABLE diversity_education_metrics (

);

CREATE TABLE collective_diversity_education_metrics (

);

-- Marital/Families Status (Single without kids, Single with Kids, Married without kids, Married with Kids)
CREATE TABLE diversity_marital_families_metrics (

);

CREATE TABLE collective_diversity_marital_families_metrics (

);

-- Veterans vs Not Veterans
CREATE TABLE diversity_veterans_metrics (
  id SERIAL PRIMARY KEY,
  veterans_count INTEGER NOT NULL,
  nonveterans_count INTEGER NOT NULL,
);

CREATE TABLE collective_diversity_veterans_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
);

-- Disabled vs. Not Disabled
CREATE TABLE diversity_disabled_metrics (
  id SERIAL PRIMARY KEY,
  disabled_count INTEGER NOT NULL,
  nondisabled_count INTEGER NOT NULL,
);

CREATE TABLE collective_diversity_disabled_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
);

-- Foreign born vs. native born
-- https://www.bls.gov/webapps/legacy/cpsatab7.htm
CREATE TABLE diversity_foreign_worker_metrics (

);

CREATE TABLE collective_diversity_foreign_worker_metrics (

);

-- Salary? Breakdown between men and women in similar roles
-- Individual contributor/non-management, management, elt
CREATE TABLE diversity_salary_metrics (

);

-- As a user, I would like to see how collectives are doing with respect to gender 
-- Race/Ethnicity Survey Questions: https://ir.aa.ufl.edu/surveys/race-and-ethnicity-survey/
CREATE TABLE diversity_gender_metrics (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
);

-- As a collective, I would like to self-report and be transparent about our gender breakdowns
CREATE TABLE collective_diversity_gender_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_gender_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives are doing with respect to sexual orientation
-- Gender/Sexual Orientiation Survey Questions: https://www.hrc.org/resources/collecting-transgender-inclusive-gender-data-in-workplace-and-other-surveys
CREATE TABLE diversity_sexual_orientation_metrics (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  heterosexual_count INTEGER NOT NULL,
  gay_count INTEGER NOT NULL,
  bisexual_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
);

-- As a collective, I would like to self-report and be transparent about our gender breakdowns
CREATE TABLE collective_diversity_sexual_orientation_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_sexual_orientation_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives are doing with respect to race and ethnicity
CREATE TABLE diversity_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
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
);

-- As a collective, I would like to self-report how we're doing with respect to race and ethnicity
CREATE TABLE collective_diversity_race_ethnicity_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_race_ethnicity_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives are doing with respect to gender
CREATE TABLE diversity_elt_gender_metrics (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
);

-- As a collective, I would like to self-report about how we're doing with respect to gender
CREATE TABLE collective_diversity_elt_gender_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_elt_gender_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives' elt is doing with respect to race and ethnicity
CREATE TABLE diversity_elt_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
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
);

-- As a collective, I would like to self-report our race and ethnicity in the elt
CREATE TABLE collective_diversity_elt_race_ethnicity_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_elt_race_ethnicity_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives are doing with respect to gender in management
CREATE TABLE diversity_management_gender_metrics (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
  female_count INTEGER NOT NULL,
  male_count INTEGER NOT NULL,
  nonbinary_count INTEGER NOT NULL,
  selfdescribe_count INTEGER NOT NULL,
  private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
);

-- As a collective, I would like to self-report our gender breakdown in management
CREATE TABLE collective_diversity_management_gender_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_management_gender_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- As a user, I would like to see how collectives are doing with respect to race/ethnicity in management roles
CREATE TABLE diversity_management_race_ethnicity_metrics (
  id SERIAL PRIMARY KEY,
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
);

-- As a collective, I would like to self-report how we're doing with respect to race and ethnicity in management
CREATE TABLE collective_diversity_management_race_ethnicity_metrics (
  collective_id INTEGER NOT NULL,
  metrics_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (metrics_id) REFERENCES diversity_management_race_ethnicity_metrics(id),
  PRIMARY KEY (collective_id, metrics_id)
);

-- Industries a collective/user is participating in
-- Tech, Medical, Education, Finance, Entertainment, etc.
-- I want to find collectives that are in a certain industry or match up with the industry I am in
CREATE TABLE industries (
  id SERIAL PRIMARY KEY,
  industry_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- Collectives report what industries they participate in
CREATE TABLE collective_industries (
  industry_id INTEGER NOT NULL,
  collective_id INTEGER NOT NULL,
  FOREIGN KEY (industry_id) REFERENCES industries(id),
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  PRIMARY KEY (industry_id, collective_id)
);

-- Users report what industries they participate in 
CREATE TABLE user_industries (
  industry_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (industry_id) REFERENCES industries(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (industry_id, collective_id)
);

-- Causes supported by a collective 
-- i.e. Black Lives Matter, Homeless Veterans
-- I want to find collectives that support these causes or that match up with the causes I want to support and focus on
CREATE TABLE causes (
  id SERIAL PRIMARY KEY,
  cause_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

-- As a user, I would like to maintain the causes that I am passionate about and support to match up against other collectives focusing on the same things
CREATE TABLE user_causes (
  cause_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  PRIMARY KEY (cause_id, user_id)
);

-- As a collective, we would like to highlight the causes we are currently supporting and are passionate about so other users can match up with us
CREATE TABLE collective_causes (
  cause_id INTEGER NOT NULL,
  collective_id INTEGER NOT NULL,
  FOREIGN KEY (cause_id) REFERENCES causes(id),
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  PRIMARY KEY (cause_id, user_id)
);

-- Similar to hashtags, a collective can create and assign tags to associate with themselves
-- i.e. #blacklivesmatter #forthrightcollective #asianamerican
-- I want to find all the collectives with a certain tag
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
);

CREATE TABLE collective_tags (
  collective_id INTEGER NOT NULL,
  tag_id INTEGER NOT NULL,
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  FOREIGN KEY (tag_id) REFERENCES tags(id),
  -- Prevents multiple instances of the same tag on the same collective
  PRIMARY KEY (collective_id, tag_id)
);

-- Similar to likes, a user of any kind i.e. collective, user, moderator, can say I support/endorse this collective!
-- It would be cool to highlight how many users/collectives/moderators support other collectives
-- I want to show my support or endorsement of a certain collective
CREATE TABLE endorsements (
  user_id INTEGER NOT NULL,
  collective_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  PRIMARY KEY (user_id, collective_id)
);

-- Follows for a user to watch certain collectives
-- I want to keep track of all the collectives I want to learn more about or support
CREATE TABLE follows (
  user_id INTEGER NOT NULL,
  collective_id INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (collective_id) REFERENCES collectives(id),
  PRIMARY KEY (user_id, collective_id)
)

-- Moderators aka volunteers/checks and balances in the communities
CREATE TABLE moderators (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL,
  verified_status BOOLEAN, -- Application status to become a moderator
  -- Moderator specific profile fields here
  FOREIGN KEY (user_id) REFERENCES users(id)
);
