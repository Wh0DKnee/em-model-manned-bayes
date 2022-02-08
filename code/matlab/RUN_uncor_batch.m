function []=RUN_uncor_batch(num, duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)

%dbstop in RUN_uncor_func;
%fprintf('num %u, duration %u, north_ft %f, east_ft %f, up_ft %f, v_ft_s %f, dot_v_ft_ss %f, dot_h_ft_s %f, dot_psi_rad_s %f, psi_rad%f\n', num, duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)
tic
%parfor i = 1:num
for i = 1:num
    fprintf("iteration: %u\n", i);
   RUN_uncor_func(duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad); 
end
toc

end