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
-- Gender/Sexual Orientiation Survey Questions: https://www.hrc.org/resources/collecting-transgender-inclusive-gender-data-in-workplace-and-other-surveys
-- Race/Ethnicity Survey Questions: https://ir.aa.ufl.edu/surveys/race-and-ethnicity-survey/
-- Leadership breakdown how to tackle this and possibly split diversity metrics into multiple tables?
-- i.e. founders/ceo metrics, executive leadership team breakdown, management breakdown
CREATE TABLE diversity_metrics (
  id SERIAL PRIMARY KEY,
  gender_female_count INTEGER NOT NULL,
  gender_male_count INTEGER NOT NULL,
  gender_nonbinary_count INTEGER NOT NULL,
  gender_selfdescribe_count INTEGER NOT NULL,
  gender_private_count INTEGER NOT NULL,
  transgender_count INTEGER NOT NULL,
  so_heterosexual_count INTEGER NOT NULL,
  so_gay_count INTEGER NOT NULL,
  so_bisexual_count INTEGER NOT NULL,
  so_selfdescribe_count INTEGER NOT NULL,
  so_private_count INTEGER NOT NULL,
  re_hispanic_latinx_spanish_count INTEGER NOT NULL,
  re_american_indian_alaskan_count INTEGER NOT NULL,
  re_asian_count INTEGER NOT NULL,
  re_hawaii_pacific_islander_count INTEGER NOT NULL,
  re_black_african_american_count INTEGER NOT NULL,
  re_white_count INTEGER NOT NULL,
  re_multiple_races_count INTEGER NOT NULL,
  re_other_count INTEGER NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  last_updated_at TIMESTAMP DEFAULT NOW(),
);

-- Diversity for a collective by the numbers
-- As a collective, I would like to be transparent about how we're doing with diversity and what sort of goals
CREATE TABLE collective_diversity_metrics (
  collective_id INTEGER NOT NULL,
  diversity_metrics_id INTEGER NOT NULL,
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
