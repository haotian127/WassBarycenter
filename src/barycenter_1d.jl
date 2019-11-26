using Plots, Interpolations

N = 256;
t = LinRange(0,1,N)

gauss(m,s) = exp.(-(t .- m).^2 ./ (2*s).^2);
normalize(x) = x ./ sum(x[:]);

s = .6;
a = gauss(.3*s,.05*s) + .5*gauss(.6*s,.15*s);
b = .5*gauss(1-s*.2,.04*s) + .8*gauss(1-s*.5,.05*s) + .5*gauss(1-s*.8,.04*s);
vmin = .025;
a = normalize(vmin .+ a);
b = normalize(vmin .+ b);

plot(t,[a b])


# cumulative
ca = cumsum(a);
cb = cumsum(b);
# inverse cumulatives
ica = quantile(ca);
icb = quantile(cb);
ica = interp1(ca, t, t, 'spline');
icb = interp1(cb, t, t, 'spline');
# composition of function
Tab = interp1(t, icb, ca, 'spline'); % icb o ca
Tba = interp1(t, ica, cb, 'spline'); % ica o cb
# should be close to Id
Iaa = interp1(t, Tba, Tab, 'spline'); % Tba o Tab
Ibb = interp1(t, Tab, Tba, 'spline'); % Tab o Tba

plot(t, [ca cb], legend = false, aspect_ratio = 1)

plot([ica icb], legend = false)






itp = interpolate(ica, BSpline(Cubic(Line(OnGrid()))))

ica = [itp(1+4*k/256) for k in t]

plot(t, ica)
