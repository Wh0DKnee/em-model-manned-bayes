function []=RUN_uncor_batch(num, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)

tic
parfor i = 1:num
   RUN_uncor_func(up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad); 
end
toc

end