% Parameters for the 36-point sliding-cylinder comparison example.
rolling_params

% The ballbot wheel contact uses a circular contact arrangement.
r_ball = r_wheel;

% Per-patch stiffness values keep the aggregate 36-contact stiffness
% comparable to the continuous rolling contact model.
k_gy = 20;
k_gx = 60;

% Match the friction coefficients used by the rolling contact model.
mu_stick = miu_p;
mu_slide = miu_s;
