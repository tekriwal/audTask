% RES_BOOTSTRP: Generalized bootstrap and/or randomization routine, designed to
%           iteratively call a user-supplied 'objective' function and
%           accumulate and summarize the results.  Confidence intervals are 
%           based on within-group bootstrapped samples, and p-values are based 
%           on pooled-group bootstrapped samples.
%
%     Syntax: [ci,pr,power,boot] = ...
%               bootstrp('func',procs,iter,alpha,X,grps,nulldist,p1,...,p10)
%
%           func =     name of function (in single quotes), to be called as:
%
%                        f = func(X,grps,initial_solution,nulldist,{p1,...,p10})
%
%                        Function should return a row vector as solution.
%                        The initial_solution is set to [] for first call, but
%                        is returned to the user function thereafter.
%           procs =    vector of boolean values indicating procedures
%                        to be done (used so that four output arguments can be 
%                        used without requiring all to be calculated):
%                          1) bootstrapped confidence limits;
%                          2) significance level based on null distribution;
%                          3) power based on null & sampling distributions;
%                          4) suppress report displays.
%                        Default = [1 0 0 1].
%           iter =     number of iterations.
%           alpha =    expected probability of Type I error.
%           X =        [n x p] data matrix.
%           grps =     vector of group membership, or matrix in which rows 
%                        identify groups (if no groups, pass as null).
%           nulldist = flag indicating source of null distribution:
%                          0 = null distribution generated by this function, by 
%                                randomizing group identifiers or by randomizing 
%                                observations within variables [default];
%                          1 = null distribution generated by user function 
%                                (set to false after null-distribution step).
%           p1,... =   1-10 additional parameters to be passed to 'func'.
%           --------------------------------------------------------------------
%           ci =       [2 x length(f)] matrix of estimates:
%                          row 1 = lower confidence limits;
%                              2 = upper confidence limits.
%           pr =       [1 x length(f)] vector of significance levels of 
%                        observed values.
%           power =    [1 x length(f)] vector of power levels at the given 
%                        alpha-level.
%           boot =     [iter x length(f)] matrix of sorted bootstrap distributions.
%

% RE Strauss, 5/25/95
%   1/22/00 - allow for groups to be matrix rather than just a vector.
%   5/24/00 - provide default value for procs vector.

function [ci,pr,power,boot] = ...
    res_bootstrp(func,procs,iter,alpha,X,grps,nulldist,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10)

  if (nargin < 6) grps = []; end;
  if (nargin < 7) nulldist = []; end;

  if (nargin < 5)
    error('  BOOTSTRP: required arguments not passed');
  end;

  [nobs,nvars] = size(X);
  if (isempty(alpha))
    alpha = 0.05;
  end;
  if (alpha>1)
    alpha = alpha/100;
  end;
  ci_level = 1-alpha;
  incr = 1/iter;

  if (isempty(procs))
    procs = [1 0 0 1];
  end;
  if (isempty(nulldist))
    nulldist = 0;
  end;

  get_ci = 0;
  get_pr = 0;
  get_power = 0;
  get_distrib = 0;
  no_grps = 0;
  user_null = 0;
  suppress_display = 1;

  n_proc = 4;
  if (size(procs,1)>1)            % Pad procedure-option vector to full length
    procs = procs';
  end;
  if (length(procs) < n_proc)
    procs = [procs, zeros(1,n_proc-length(procs))];
  end;

  if (procs(1))
    get_ci = 1;
  end;
  if (procs(2))
    get_pr = 1;
  end;
  if (procs(3))
    get_power = 1;
  end;
  if (procs(4))
    suppress_display = 1;
  end;

  if (nargout > 3)                % Bootstrap distribution to be returned
    get_distrib = 1;
  end;

  if (nulldist)
    user_null = 1;
  end;

  if (isempty(grps))
    no_grps = 1;
  else
    if (isvector(grps))
      grps = grps(:);
      gg = grps;
    else
      gg = rowtoval(grps);
    end;

    [u,f] = uniquef(gg);
    if (any(f<2))
      error('  BOOTSTRP: all groups must have >1 observations');
    end;
  end;
  save_grps = grps;

  ci = [];                              % Allocate return matrices
  pr = [];
  power = [];
  boot = [];

  clk = clock;                          % Seed random-number generator
  rand('seed',clk(6));                  %   from system clock

  % --- Create function call ---

  init_soln = [];
  evalstr=[func, '(data,grps,init_soln,nulldist'];
  for i=1:(nargin-7)
    evalstr = [evalstr,',p',int2str(i)];
  end;
  evalstr = [evalstr,')'];

  % --- Initial solution ---

  if (user_null)
    nulldist = 0;
  end;

  data = X; 
  init_soln = eval(evalstr);
  ln_soln = length(init_soln);

  % --- Get null distributions for significance and power levels ---

  if (user_null)
    nulldist = 1;
  end;

  if (get_pr | get_power)
    if (~suppress_display)
      disp('  BOOTSTRP: Generating null distributions...');
    end;

    if (get_pr)                           % Allocate vector of significance levels
      pr = zeros(1,ln_soln);
    end;

    if (get_power)
      null =  zeros(iter,ln_soln);        % Allocate null matrix
      power = zeros(1,ln_soln);           % Allocate vector of power levels
    end;

    for rit = 1:iter
      if (~user_null)                     % If null sample provided by this function, ...
        if (no_grps)                        % Depending on existence of groups,
          data = X;                           % Randomize observations separately
          for j = 1:nvars                     %   for each variable
            data(:,j) = data(randperm(nobs),j);
          end;
        else                                  %   or, if have multiple groups, 
          grps = grps(randperm(nobs),:);      % Randomize group membership
        end;
      end;

      f = eval(evalstr);                  % Get results

      if (get_power)                      % Stash in results matrix
        null(rit,:) = f;
      end;

      if (get_pr)                         % Determine whether results are in right tail
        pr = pr + (incr*(f >= init_soln));
      end;
    end;

    if (get_power)
      null = sort(null);                  % Sort columns independently
      cl = floor((1-alpha)*iter);
      cu = ceil((1-alpha)*iter);
      crit = mean([null(cl,:);null(cu,:)]); % Stash critical values
      null = [];                            % Release space
    end;
  end;  % if (get_pr | get_power)

  if (user_null)
    nulldist = 0;
  end;

  % --- Get sampling distributions 
  %     for bootstrapped confidence intervals and power ---

  if (get_ci | get_power | get_distrib)
    if (~suppress_display)
      disp('  BOOTSTRP: Generating sampling distributions...');
    end;

    grps = save_grps;                     % Restore original grouping variable

    if (get_ci | get_distrib)
      jack = zeros(nobs,ln_soln);         % Allocate jackknife matrix
      boot = zeros(iter,ln_soln);         % Allocate bootstrap matrix
    end;

%    if (get_ci | get_distrib)             % Jackknife step
%      if (~suppress_display)
%        disp('    Jackknife step...');
%      end;
%
%      for n = 1:nobs                        % Jackknife observations
%        data = X;                             % Omit obs from data and grps
%        data(n,:) = [];
%
%        if (~no_grps)
%          grps = save_grps;
%          grps(n) = [];
%        end;
%        f = eval(evalstr);                    % Get results
%        jack(n,:) = f;                        % Stash in results matrix
%      end;
%    end;
jack = [];

    if (get_ci | get_distrib)               % Bootstrap step
      if (~suppress_display)
        disp('    Bootstrap step...');
      end;
      boot(1,:) = init_soln;                % Begin with initial solution
      if (get_power)
        for i = 1:ln_soln
          if (init_soln(i) >= crit(i))
            power(i) = power(i) + incr;
          end;
        end;
      end;
    end;

    grps = save_grps;
    for bit = 2:iter
      data = bootsamp(X,grps);              % Sample rows of data
      f = eval(evalstr);                    % Get results
      if (get_ci | get_distrib)
        boot(bit,:) = f;                    % Accumulate results
      end;
      if (get_power)
        for i = 1:ln_soln
          if (f(i) >= crit(i))              % Determine power (= proportion of
            power(i) = power(i) + incr;     %   sampling distribution >= critical
          end;                              %   value of null distribution
        end;
      end;
    end;

    if (get_ci)
      boot = sort(boot);                          % Sort columns independently
      ci = bootci(boot,init_soln,jack,ci_level);  % Confidence limits
    end;

  end;  % if (get_ci | get_power | get_distrib)

  return;
