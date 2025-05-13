function [wavelength, intensity] = processDifferenceSpectrum(cel_spectrum, bei_spectrum, u, v, m, n, manbian_degree)
    xishoupu = cel_spectrum(:,2) ./ bei_spectrum(:,2);%除背地，吸收谱

    u_index_1 = find(cel_spectrum(:,1) == u);
    v_index_1 = find(cel_spectrum(:,1) == v);%索引到 用的吸收谱波长 所在位置
    u_index_2 = find(cel_spectrum(:,1) == m);
    v_index_2 = find(cel_spectrum(:,1) == n);%索引到 拟合吸收谱波长 所在位置
    
    yongdexishoupu = xishoupu(u_index_1:v_index_1);
    yongdebochang = cel_spectrum(u_index_1:v_index_1, 1);

    nihebochang = cel_spectrum(u_index_2:v_index_2, 1);
    nihexishoupu = xishoupu(u_index_2:v_index_2);

    manbianxishou = polyfit(nihebochang, nihexishoupu, manbian_degree);
    slow_variation_fit = polyval(manbianxishou, nihebochang);%慢变部分

    u_index_3 = find(nihebochang == u);
    v_index_3 = find(nihebochang == v);%索引到 拟合吸收谱波长 所在位置
    slow_variation_fit_2 = slow_variation_fit(u_index_3:v_index_3);

    rapid_variation = yongdexishoupu ./ slow_variation_fit_2;
    intensity = log(rapid_variation);

    wavelength = yongdebochang;
end