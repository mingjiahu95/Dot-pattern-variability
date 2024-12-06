 function Pr_corr = GCM_baseline(S_p, S_l, S_m, S_h, S_c,gamma,condition)
%condition: 1 low 2 med 3 high *4 mix
%item type: 1 proto 2 old 3 newlow 4 newmed 5 newhigh
ntrain_per_cat = 9;
ncat = 3;


S_within_proto = ntrain_per_cat*S_p;
S_within_low = ntrain_per_cat*S_l;
S_within_med = ntrain_per_cat*S_m;
S_within_high = ntrain_per_cat*S_h;
switch condition
    case 1
        S_within_old = 1 + (ntrain_per_cat - 1)*S_within_low;
    case 2
        S_within_old = 1 + (ntrain_per_cat - 1)*S_within_med;
    case 3
        S_within_old = 1 + (ntrain_per_cat - 1)*S_within_high;
end
S_between_per_cat = ntrain_per_cat*S_c;

Pr_corr = NaN([1,5]);
Pr_corr(1) = S_within_proto^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_proto^gamma);
Pr_corr(2) = S_within_old^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_old^gamma);
Pr_corr(3) = S_within_low^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_low^gamma);
Pr_corr(4) = S_within_med^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_med^gamma);
Pr_corr(5) = S_within_high^gamma / (S_between_per_cat^gamma *(ncat - 1) + S_within_high^gamma);
end
