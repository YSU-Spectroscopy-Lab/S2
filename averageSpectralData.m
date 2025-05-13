function [wave, avg_spectrum] = averageSpectralData(directory, file_list, n)
    Q = [];
    len = length(file_list);
    for i = (len - n + 1):len
        fileID = fopen(fullfile(directory, file_list(i).name));
        A = textscan(fileID, '%f%f');
        Q = [Q; A];
        fclose(fileID);
    end

    % Compute average spectrum
    wavelength = Q{1,1};
    avg_spectrum = zeros(length(wavelength), 1);
    for j = 1:length(Q)
        avg_spectrum = avg_spectrum + Q{j,2};
    end
    avg_spectrum = avg_spectrum / length(Q);

    wave = [wavelength, avg_spectrum];
end