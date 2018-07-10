TRUNCATE TABLE `billing`;
TRUNCATE TABLE `billing_transaction`;
TRUNCATE TABLE `contact`;
TRUNCATE TABLE `expert_referral`;
TRUNCATE TABLE `log_email`;
TRUNCATE TABLE `log_search`;
TRUNCATE TABLE `metric_action`;
TRUNCATE TABLE `project_expert`;
TRUNCATE TABLE `session`;
TRUNCATE TABLE `sf_user`;
TRUNCATE TABLE `sf_user_opportunity`;

-- update to clean / obfuscate / whatever
UPDATE `user_expert_profile` SET quality=1;
UPDATE `user` u SET
    signupHash='',
    resetHash='',
    phoneSecondary='',
    paypalEmail=NULL,
    privateNotes=NULL,
    availabilityNotes=NULL,
    abn=NULL,
    crn=NULL,
    signupIp='127.0.0.1',
    loginIp='127.0.0.2',
    hasProfilePicture=0,
    phoneMobile=ROUND(RAND()*1000000),
    email=CONCAT('dev+', role, id, '@expert360.com'),
    password='',
    username=CONCAT(role, id)
WHERE
    role != 'admin' AND
    role != 'superadmin';
