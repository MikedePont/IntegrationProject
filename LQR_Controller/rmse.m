function RMSE = rmse(measured, ref)

y = measured;
yhat = ref;

RMSE = sqrt(mean((y - yhat).^2));