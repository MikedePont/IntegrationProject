function [VAF] = VaF(ref_state, real_state)

    VAF = (1-(var(ref_state - real_state))/var(real_state));
end