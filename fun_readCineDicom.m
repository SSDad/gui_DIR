function [cineData] = fun_readCineDicom(dcmPath, ffn_mat) 

dcmC = dicomCollection(dcmPath);
dcmFileNames = dcmC.Filenames{1};
nFile = numel(dcmFileNames);
inst = nan(nFile, 1);
v = [];

hWB = waitbar(0);
for n = 1:nFile
    ffn = dcmFileNames(n);
    di = dicominfo(ffn);
    iop = di.ImageOrientationPatient;
    inst(n) = di.InstanceNumber;
    
    I = dicomread(ffn);
    v = cat(3, v, I);

    waitbar(n/nFile, hWB, ['Processing ', num2str(n), '/', num2str(nFile)])

end

[~, ind] = sort(inst);
cineData.v = v(:,:,ind);

cineData.IMP = di.ImagePositionPatient;
cineData.PS = di.PixelSpacing;

waitbar(1, hWB, ['saving cine data']);

save(ffn_mat,'cineData');

close(hWB);
