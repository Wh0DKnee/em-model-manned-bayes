function []=RUN_uncor_batch(num, duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)

%dbstop in RUN_uncor_func;
%fprintf('num %u, duration %u, north_ft %f, east_ft %f, up_ft %f, v_ft_s %f, dot_v_ft_ss %f, dot_h_ft_s %f, dot_psi_rad_s %f, psi_rad%f\n', num, duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad)
tic
parfor i = 1:num
   if num >= 1000
        if mod(i, 100) == 0
            fprintf("monte carlo iteration: %u from %u\n", i, num);
        end
   end
   
   RUN_uncor_func(i, duration, north_ft, east_ft, up_ft, v_ft_s, dot_v_ft_ss, dot_h_ft_s, dot_psi_rad_s, psi_rad); 
end
toc

end